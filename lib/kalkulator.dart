import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'navbar.dart';

const _merah = Color(0xFFDA3838);

/// Lambang operator, dipakai di tombol sekaligus di dalam ekspresi.
const _tambah = '+';
const _kurang = '−';
const _kali = '×';
const _bagi = '÷';
const _daftarOperator = [_tambah, _kurang, _kali, _bagi];

/// Radius sudut panel putih. Warna merah diteruskan sejauh ini di belakangnya
/// supaya lengkungan sudut memperlihatkan merah, bukan latar halaman.
const _radiusPanel = 60.0;

/// Tinggi ideal satu baris tombol, termasuk jarak di sekeliling tombolnya.
/// Baris menyusut di bawah nilai ini pada layar pendek — lihat [_tinggiBarisUntuk].
const _tinggiBarisTombol = 66.0;

/// Jarak atas dan bawah di dalam panel tombol.
const _paddingPanel = 44.0;

/// Ruang yang dibutuhkan area merah untuk header, layar dan bilah alat, dengan
/// sisa lega. Hanya berpengaruh di layar pendek; ponsel dapat tinggi penuh.
const _areaLayar = 232.0;

/// Menjaga papan tombol agar tidak mendesak layar keluar di layar pendek.
double _tinggiBarisUntuk(double tinggiTersedia) =>
    ((tinggiTersedia - _areaLayar - _paddingPanel) / 5)
        .clamp(40.0, _tinggiBarisTombol);

// ---------------------------------------------------------------------------
// Penguraian ekspresi
// ---------------------------------------------------------------------------

/// Menghitung ekspresi yang diketik, mis. "(2+3)×4" atau "100−30%".
/// Mengembalikan null bila ekspresinya cacat atau hasilnya bukan bilangan
/// berhingga.
///
/// Tata bahasa:
///   ekspresi := suku (('+' | '−') suku)*
///   suku     := faktor (('×' | '÷' | tersirat) faktor)*
///   faktor   := '−'* dasar '%'?
///   dasar    := angka | '(' ekspresi ')'
///
/// '×' dan '÷' mengikat lebih kuat daripada '+' dan '−', jadi "2+3×4" bernilai
/// 14. Tanda '%' di akhir operan kanan '+' atau '−' dibaca sebagai persen *dari
/// nilai di sebelah kirinya*, sehingga "100−30%" bernilai 70. Di posisi lain
/// '%' sekadar membagi 100.
double? hitungEkspresi(String masukan) {
  final pengurai = _Pengurai(masukan);
  final nilai = pengurai.uraiEkspresi();
  if (nilai == null || !pengurai.diAkhir) return null;
  return nilai.isFinite ? nilai : null;
}

class _Pengurai {
  _Pengurai(this._sumber);

  final String _sumber;
  int _posisi = 0;

  /// Diisi [_uraiSuku] saat sukunya berupa persen tunggal seperti "30%".
  bool _sukuPersenMurni = false;
  bool _faktorPersen = false;

  bool get diAkhir => _posisi >= _sumber.length;

  String? get _lihat => diAkhir ? null : _sumber[_posisi];

  double? uraiEkspresi() {
    var kiri = _uraiSuku();
    if (kiri == null) return null;
    while (_lihat == _tambah || _lihat == _kurang) {
      final operator = _sumber[_posisi++];
      final kanan = _uraiSuku();
      if (kanan == null) return null;
      // "100 − 30%" mengurangi 30% *dari 100*, bukan 0,3.
      final jumlah = _sukuPersenMurni ? kiri! * kanan : kanan;
      kiri = operator == _tambah ? kiri! + jumlah : kiri! - jumlah;
    }
    return kiri;
  }

  double? _uraiSuku() {
    var kiri = _uraiFaktor();
    if (kiri == null) return null;
    var persenMurni = _faktorPersen;
    while (true) {
      final String operator;
      if (_lihat == _kali || _lihat == _bagi) {
        operator = _sumber[_posisi++];
      } else if (_lihat == '(') {
        operator = _kali; // perkalian tersirat, seperti pada "2(3+4)"
      } else {
        break;
      }
      final kanan = _uraiFaktor();
      if (kanan == null) return null;
      kiri = operator == _kali ? kiri! * kanan : kiri! / kanan;
      persenMurni = false;
    }
    _sukuPersenMurni = persenMurni;
    return kiri;
  }

  double? _uraiFaktor() {
    var negatif = false;
    while (_lihat == _kurang) {
      _posisi++;
      negatif = !negatif;
    }
    final nilai = _uraiDasar();
    if (nilai == null) return null;
    var hasil = negatif ? -nilai : nilai;
    var persen = false;
    if (_lihat == '%') {
      _posisi++;
      persen = true;
      hasil = hasil / 100;
    }
    _faktorPersen = persen;
    return hasil;
  }

  double? _uraiDasar() {
    if (_lihat == '(') {
      _posisi++;
      final nilai = uraiEkspresi();
      if (nilai == null || _lihat != ')') return null;
      _posisi++;
      return nilai;
    }
    final awal = _posisi;
    while (!diAkhir && (_apakahAngka(_sumber[_posisi]) ||
        _sumber[_posisi] == '.')) {
      _posisi++;
    }
    if (_posisi == awal) return null;
    return double.tryParse(_sumber.substring(awal, _posisi));
  }
}

bool _apakahAngka(String karakter) {
  final kode = karakter.codeUnitAt(0);
  return kode >= 0x30 && kode <= 0x39;
}

// ---------------------------------------------------------------------------
// Halaman
// ---------------------------------------------------------------------------

class HalamanKalkulator extends StatefulWidget {
  const HalamanKalkulator({super.key});

  @override
  State<HalamanKalkulator> createState() => _HalamanKalkulatorState();
}

class _HalamanKalkulatorState extends State<HalamanKalkulator> {
  /// Ekspresi seperti yang diketik. Tidak dihitung sampai '=' ditekan.
  String _masukan = '0';

  /// Ekspresi yang sudah selesai, ditampilkan samar di atas hasil.
  String _ekspresiTerakhir = '';

  /// True selama [_masukan] berisi hasil dari '=' sebelumnya.
  bool _menampilkanHasil = false;

  final List<String> _riwayat = [];

  int _indexNav = indexNavKalkulator;

  bool _berakhirDenganNilai() => RegExp(r'[0-9)%]$').hasMatch(_masukan);

  /// Deretan angka dan titik yang sedang diketik, bila ada.
  String _angkaTerakhir() =>
      RegExp(r'[0-9.]*$').firstMatch(_masukan)?.group(0) ?? '';

  void _ketikAngka(String angka) {
    setState(() {
      if (_menampilkanHasil) {
        _masukan = angka;
        _menampilkanHasil = false;
        return;
      }
      // Nol pembuka diganti, bukan disimpan, supaya "05" tidak pernah terjadi.
      if (RegExp(r'(^|[+−×÷(])0$').hasMatch(_masukan)) {
        _masukan = _masukan.substring(0, _masukan.length - 1) + angka;
      } else {
        _masukan += angka;
      }
    });
  }

  void _ketikTitik() {
    setState(() {
      if (_menampilkanHasil) {
        _masukan = '0.';
        _menampilkanHasil = false;
        return;
      }
      final angka = _angkaTerakhir();
      if (angka.contains('.')) return;
      _masukan += angka.isEmpty ? '0.' : '.';
    });
  }

  void _ketikOperator(String operator) {
    setState(() {
      _menampilkanHasil = false;
      if (_masukan.isEmpty) _masukan = '0';
      final terakhir = _masukan[_masukan.length - 1];
      if (_daftarOperator.contains(terakhir)) {
        _masukan = _masukan.substring(0, _masukan.length - 1) + operator;
      } else {
        _masukan += operator;
      }
    });
  }

  /// Satu tombol bergantian antara '(' dan ')': menutup kelompok bila ada yang
  /// terbuka dan ada isinya, selain itu membuka kelompok baru.
  void _ketikKurung() {
    setState(() {
      if (_menampilkanHasil) {
        _masukan = '0';
        _menampilkanHasil = false;
      }
      final terbuka = '('.allMatches(_masukan).length;
      final tertutup = ')'.allMatches(_masukan).length;
      if (terbuka > tertutup && _berakhirDenganNilai()) {
        _masukan += ')';
      } else if (_masukan == '0') {
        _masukan = '(';
      } else {
        _masukan += '(';
      }
    });
  }

  void _ketikPersen() {
    setState(() {
      if (!_berakhirDenganNilai() || _masukan.endsWith('%')) return;
      _menampilkanHasil = false;
      _masukan += '%';
    });
  }

  void _bersihkan() {
    setState(() {
      _masukan = '0';
      _ekspresiTerakhir = '';
      _menampilkanHasil = false;
    });
  }

  void _hapusSatu() {
    setState(() {
      if (_menampilkanHasil) {
        _masukan = '0';
        _menampilkanHasil = false;
        return;
      }
      _masukan = _masukan.length <= 1
          ? '0'
          : _masukan.substring(0, _masukan.length - 1);
    });
  }

  /// Membuang operator yang menggantung dan menutup kurung yang lupa ditutup,
  /// sehingga "(2+3" dan "5+" tetap bisa dihitung.
  String _rapikan(String masukan) {
    var teks = masukan;
    while (teks.isNotEmpty && _daftarOperator.contains(teks[teks.length - 1])) {
      teks = teks.substring(0, teks.length - 1);
    }
    final kurang = '('.allMatches(teks).length - ')'.allMatches(teks).length;
    return kurang > 0 ? teks + ')' * kurang : teks;
  }

  void _hitung() {
    final nilai = hitungEkspresi(_rapikan(_masukan));
    setState(() {
      if (nilai == null) {
        _ekspresiTerakhir = _masukan;
        _masukan = 'Error';
        _menampilkanHasil = true;
        return;
      }
      final hasil = _format(nilai);
      _ekspresiTerakhir = '$_masukan =';
      _riwayat.insert(0, '$_masukan = $hasil');
      _masukan = hasil;
      _menampilkanHasil = true;
    });
  }

  /// Memangkas nol di ujung supaya 4.0 tampil sebagai "4", bukan "4.000000".
  String _format(double nilai) {
    if (!nilai.isFinite) return 'Error';
    if (nilai == nilai.roundToDouble() && nilai.abs() < 1e15) {
      return nilai.toInt().toString();
    }
    return nilai
        .toStringAsFixed(6)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  void _tampilkanRiwayat() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (konteksLembar) => _LembarRiwayat(
        daftar: _riwayat,
        onHapusSemua: () {
          setState(_riwayat.clear);
          Navigator.of(konteksLembar).pop();
        },
      ),
    );
  }

  void _saatNavDipilih(int index) {
    final ditangani = bukaMenuNav(
      context,
      index: index,
      indexHalamanIni: indexNavKalkulator,
    );
    if (ditangani) return;
    setState(() => _indexNav = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final tinggiBaris = _tinggiBarisUntuk(constraints.maxHeight);
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: _merah,
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 14, 24, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _Header(
                                onKembali: () => Navigator.of(context).pop(),
                              ),
                              const Spacer(),
                              Text(
                                _ekspresiTerakhir,
                                key: const Key('ekspresi-kalkulator'),
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Ekspresi panjang mengecil, bukan meluber.
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _masukan,
                                  key: const Key('layar-kalkulator'),
                                  style: GoogleFonts.inter(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              _BilahAlat(
                                onRiwayat: _tampilkanRiwayat,
                                onHapus: _hapusSatu,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      // Merah diteruskan di belakang lengkungan sudut panel,
                      // kalau tidak latar putih halaman yang terlihat di sana.
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: _radiusPanel,
                        child: ColoredBox(color: _merah),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(_radiusPanel),
                          ),
                        ),
                        // Padding atas menjauhkan baris tombol pertama dari
                        // lengkungan sudut.
                        padding: const EdgeInsets.fromLTRB(14, 34, 14, 10),
                        child: _PapanTombol(
                          tinggiBaris: tinggiBaris,
                          onAngka: _ketikAngka,
                          onOperator: _ketikOperator,
                          onSamaDengan: _hitung,
                          onPersen: _ketikPersen,
                          onTitik: _ketikTitik,
                          onBersihkan: _bersihkan,
                          onKurung: _ketikKurung,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BilahNav(
        indexAktif: _indexNav,
        onPilih: _saatNavDipilih,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onKembali});

  final VoidCallback onKembali;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Semantics(
          button: true,
          label: 'Kembali',
          child: GestureDetector(
            onTap: onKembali,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 37,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 22,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Kalkulator',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Riwayat dan hapus. Berada di area merah, tepat di atas panel tombol.
class _BilahAlat extends StatelessWidget {
  const _BilahAlat({required this.onRiwayat, required this.onHapus});

  final VoidCallback onRiwayat;
  final VoidCallback onHapus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TombolBilahAlat(
          icon: Icons.history_rounded,
          label: 'Riwayat hitungan',
          onTap: onRiwayat,
        ),
        _TombolBilahAlat(
          icon: Icons.backspace_outlined,
          label: 'Hapus satu karakter',
          onTap: onHapus,
        ),
      ],
    );
  }
}

class _TombolBilahAlat extends StatelessWidget {
  const _TombolBilahAlat({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 26, color: Colors.white),
        tooltip: label,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 48, height: 40),
      ),
    );
  }
}

class _LembarRiwayat extends StatelessWidget {
  const _LembarRiwayat({required this.daftar, required this.onHapusSemua});

  final List<String> daftar;
  final VoidCallback onHapusSemua;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Riwayat Hitungan',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (daftar.isNotEmpty)
                  TextButton(
                    onPressed: onHapusSemua,
                    style: TextButton.styleFrom(foregroundColor: _merah),
                    child: Text(
                      'Hapus Semua',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (daftar.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'Belum ada hitungan.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: daftar.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      daftar[i],
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PapanTombol extends StatelessWidget {
  const _PapanTombol({
    required this.tinggiBaris,
    required this.onAngka,
    required this.onOperator,
    required this.onSamaDengan,
    required this.onPersen,
    required this.onTitik,
    required this.onBersihkan,
    required this.onKurung,
  });

  final double tinggiBaris;
  final ValueChanged<String> onAngka;
  final ValueChanged<String> onOperator;
  final VoidCallback onSamaDengan;
  final VoidCallback onPersen;
  final VoidCallback onTitik;
  final VoidCallback onBersihkan;
  final VoidCallback onKurung;

  Widget _baris(List<Widget> tombol) => SizedBox(
        height: tinggiBaris,
        child: Row(children: [for (final t in tombol) Expanded(child: t)]),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kolom 1-3: bersihkan, kurung, angka dan koma desimal.
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _baris([
                _Tombol(label: 'C', onTap: onBersihkan),
                _Tombol(
                  label: '( )',
                  labelSemantik: 'Tanda kurung',
                  onTap: onKurung,
                ),
                _Tombol(label: _kali, onTap: () => onOperator(_kali)),
              ]),
              for (final barisAngka in const [
                ['7', '8', '9'],
                ['4', '5', '6'],
                ['1', '2', '3'],
              ])
                _baris([
                  for (final angka in barisAngka)
                    _Tombol(label: angka, onTap: () => onAngka(angka)),
                ]),
              _baris([
                _Tombol(label: '%', onTap: onPersen),
                _Tombol(label: '0', onTap: () => onAngka('0')),
                _Tombol(label: '.', onTap: onTitik),
              ]),
            ],
          ),
        ),
        // Kolom 4: operator, dengan '=' menempati dua baris terakhir.
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: tinggiBaris,
                child: _Tombol(label: _bagi, onTap: () => onOperator(_bagi)),
              ),
              SizedBox(
                height: tinggiBaris,
                child: _Tombol(
                  label: _kurang,
                  onTap: () => onOperator(_kurang),
                ),
              ),
              SizedBox(
                height: tinggiBaris,
                child: _Tombol(
                  label: _tambah,
                  onTap: () => onOperator(_tambah),
                ),
              ),
              SizedBox(
                height: tinggiBaris * 2,
                child: _Tombol(
                  label: '=',
                  onTap: onSamaDengan,
                  latar: _merah,
                  warnaTeks: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tombol extends StatelessWidget {
  const _Tombol({
    required this.label,
    required this.onTap,
    this.labelSemantik,
    this.latar = Colors.white,
    this.warnaTeks = Colors.black,
  });

  final String label;
  final VoidCallback onTap;
  final String? labelSemantik;
  final Color latar;
  final Color warnaTeks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Semantics(
        button: true,
        label: labelSemantik ?? label,
        child: Material(
          color: latar,
          shape: StadiumBorder(
            side: latar == Colors.white
                ? BorderSide(color: Colors.black.withValues(alpha: 0.30))
                : BorderSide.none,
          ),
          elevation: 2,
          shadowColor: const Color(0x3F000000),
          child: InkWell(
            onTap: onTap,
            customBorder: const StadiumBorder(),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: warnaTeks,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}