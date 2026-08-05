import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../navbar.dart';
import 'detail_transaksi.dart';

const _merah = Color(0xFFDA3838);
const _merahTua = Color(0xFFDF1313);
const _hijau = Color(0xFF3E771D);
const _oranye = Color(0xFFEC841C);
const _kuning = Color(0xFFFFD000);

/// Radius sudut panel putih. Warna merah diteruskan sejauh ini di belakangnya
/// supaya lengkungan sudut memperlihatkan merah, bukan latar halaman.
const _radiusPanel = 60.0;

/// Satu baris aktivitas keuangan.
class Transaksi {
  const Transaksi({
    required this.judul,
    required this.tanggal,
    required this.jam,
    required this.jumlah,
    required this.pemasukan,
  });

  final String judul;
  final String tanggal;
  final String jam;
  final int jumlah;

  /// True untuk uang masuk, false untuk uang keluar.
  final bool pemasukan;
}

/// "Rp 8.000.000" — pemisah ribuan memakai titik seperti lazimnya di Indonesia.
String formatRupiah(int jumlah) {
  final angka = jumlah.abs().toString();
  final hasil = StringBuffer('Rp ');
  for (var i = 0; i < angka.length; i++) {
    if (i > 0 && (angka.length - i) % 3 == 0) hasil.write('.');
    hasil.write(angka[i]);
  }
  return hasil.toString();
}

class HalamanPencatatan extends StatefulWidget {
  const HalamanPencatatan({super.key});

  @override
  State<HalamanPencatatan> createState() => _HalamanPencatatanState();
}

class _HalamanPencatatanState extends State<HalamanPencatatan> {
  int _indexNav = indexNavBukuKas;

  final int _pemasukan = 8000000;
  final int _pengeluaran = 3000000;
  final int _piutang = 500000;

  DateTimeRange? _rentangTanggal;

  final List<Transaksi> _daftarTransaksi = const [
    Transaksi(
      judul: 'Rani - Cabai 1Kg',
      tanggal: '26 - 07 - 2026',
      jam: '14.35 WIB',
      jumlah: 30000,
      pemasukan: true,
    ),
    Transaksi(
      judul: 'Pembayaran Makanan',
      tanggal: '26 - 07 - 2026',
      jam: '09.20 WIB',
      jumlah: 10000,
      pemasukan: false,
    ),
    Transaksi(
      judul: 'Rani - Cabai 1Kg',
      tanggal: '26 - 07 - 2026',
      jam: '13.10 WIB',
      jumlah: 30000,
      pemasukan: true,
    ),
    Transaksi(
      judul: 'Rani - Cabai 1Kg',
      tanggal: '26 - 07 - 2026',
      jam: '12.45 WIB',
      jumlah: 30000,
      pemasukan: true,
    ),
    Transaksi(
      judul: 'Rani - Cabai 1Kg',
      tanggal: '26 - 07 - 2026',
      jam: '11.30 WIB',
      jumlah: 30000,
      pemasukan: true,
    ),
    Transaksi(
      judul: 'Rani - Cabai 1Kg',
      tanggal: '26 - 07 - 2026',
      jam: '10.15 WIB',
      jumlah: 30000,
      pemasukan: true,
    ),
  ];

  void _saatNavDipilih(int index) {
    final ditangani = bukaMenuNav(
      context,
      index: index,
      indexHalamanIni: indexNavBukuKas,
    );
    if (ditangani) return;
    setState(() => _indexNav = index);
  }

  Future<void> _bukaFilterPopup(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (_) => _FilterPopup(
        rentangAwal: _rentangTanggal,
        onTampilkan: (rentang, kataKunci, jenis) {
          setState(() => _rentangTanggal = rentang);
          // TODO: terapin filter kataKunci & jenis ke _daftarTransaksi
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: _merah,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
                    child: Column(
                      children: [
                        _Header(
                          onKembali: () => Navigator.of(context).pop(),
                          onFilter: () => _bukaFilterPopup(context),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: _KartuRingkasan(
                                warna: _hijau,
                                judul: 'Pemasukan',
                                keterangan: 'Total uang yang diterima',
                                nilai: formatRupiah(_pemasukan),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _KartuRingkasan(
                                warna: _merahTua,
                                judul: 'Pengeluaran',
                                keterangan: 'Total uang yang dikeluarkan',
                                nilai: formatRupiah(_pengeluaran),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _KartuRingkasan(
                                warna: _oranye,
                                judul: 'Piutang',
                                keterangan:
                                    'Total uang yang belum dibayar pelanggan',
                                nilai: formatRupiah(_piutang),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 37),
                        const _AksiCepat(),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
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
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(_radiusPanel),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 11),
                            Container(
                              width: 55,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'Aktivitas',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: ListView.separated(
                                padding:
                                    const EdgeInsets.fromLTRB(22, 0, 22, 8),
                                itemCount: _daftarTransaksi.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, i) => _BarisTransaksi(
                                  transaksi: _daftarTransaksi[i],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(49, 8, 49, 12),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 44,
                                  width: 190,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      shape: const StadiumBorder(),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                    ),
                                    child: Text(
                                      'Lihat Grafik',
                                      style:
                                          GoogleFonts.inter(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BilahNav(
        indexAktif: _indexNav,
        onPilih: _saatNavDipilih,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onKembali, required this.onFilter});

  final VoidCallback onKembali;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TombolKotak(
          icon: Icons.arrow_back_rounded,
          label: 'Kembali',
          onTap: onKembali,
        ),
        const SizedBox(width: 24),
        Text(
          'Pencatatan',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        _TombolKotak(
          icon: Icons.filter_alt_outlined,
          label: 'Pilih periode',
          onTap: onFilter,
        ),
      ],
    );
  }
}

class _TombolKotak extends StatelessWidget {
  const _TombolKotak({
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
      child: GestureDetector(
        onTap: onTap,
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
          child: Icon(icon, size: 22, color: Colors.black),
        ),
      ),
    );
  }
}

/// Kartu putih dengan pita berwarna di tepi kirinya.
class _KartuRingkasan extends StatelessWidget {
  const _KartuRingkasan({
    required this.warna,
    required this.judul,
    required this.keterangan,
    required this.nilai,
  });

  final Color warna;
  final String judul;
  final String keterangan;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(width: 14, color: warna),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(7, 9, 5, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Expanded(
                    child: Text(
                      keterangan,
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        color: Colors.black.withValues(alpha: 0.50),
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      nilai,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AksiCepat extends StatelessWidget {
  const _AksiCepat();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TombolAksi(icon: Icons.add_circle_outline, label: 'Pemasukan'),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _TombolAksi(
            icon: Icons.remove_circle_outline,
            label: 'Pengeluaran',
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _TombolAksi(icon: Icons.handshake_outlined, label: 'Piutang'),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _TombolAksi(
            icon: Icons.list_alt_rounded,
            label: 'Aktivitas',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => HalamanDetailTransaksi(
                    judul: 'Rani - Cabai 1Kg',
                    tanggal: '26 - 07 - 2026',
                    jam: '14.35 WIB',
                    jumlah: 30000,
                    pemasukan: true,
                    hargaMinimum: 20000,
                    hargaMaksimum: 35000,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _TombolAksi(icon: Icons.summarize_outlined, label: 'Rekap'),
        ),
      ],
    );
  }
}

class _TombolAksi extends StatelessWidget {
  const _TombolAksi({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: _kuning,
        borderRadius: BorderRadius.circular(10),
        elevation: 2,
        shadowColor: const Color(0x3F000000),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: Colors.black),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BarisTransaksi extends StatelessWidget {
  const _BarisTransaksi({required this.transaksi});

  final Transaksi transaksi;

  @override
  Widget build(BuildContext context) {
    final warna = transaksi.pemasukan ? _hijau : _merahTua;
    final tanda = transaksi.pemasukan ? '+' : '−';

    return Semantics(
      button: true,
      label: 'Buka detail transaksi ${transaksi.judul}',
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => HalamanDetailTransaksi(
                judul: transaksi.judul,
                tanggal: transaksi.tanggal,
                jam: transaksi.jam,
                jumlah: transaksi.jumlah,
                pemasukan: transaksi.pemasukan,
                hargaMinimum: 20000,
                hargaMaksimum: 35000,
              ),
            ),
          );
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black.withValues(alpha: 0.20)),
              borderRadius: BorderRadius.circular(10),
            ),
        ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: OvalBorder(side: BorderSide(width: 1)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  transaksi.pemasukan
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  size: 18,
                  color: warna,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaksi.judul,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      transaksi.tanggal,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.black.withValues(alpha: 0.50),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$tanda ${formatRupiah(transaksi.jumlah)}',
                style: GoogleFonts.inter(fontSize: 12, color: warna),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// Popup Filter — dipicu oleh tombol filter/kalender di header.
/// ============================================================
class _FilterPopup extends StatefulWidget {
  const _FilterPopup({required this.rentangAwal, required this.onTampilkan});

  final DateTimeRange? rentangAwal;
  final void Function(DateTimeRange? rentang, String kataKunci, String jenis)
      onTampilkan;

  @override
  State<_FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<_FilterPopup> {
  final TextEditingController _kataKunciCtrl = TextEditingController();
  DateTimeRange? _rentang;
  final String _jenis = 'Semua Transaksi';

  static const _namaBulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  @override
  void initState() {
    super.initState();
    _rentang = widget.rentangAwal;
  }

  @override
  void dispose() {
    _kataKunciCtrl.dispose();
    super.dispose();
  }

  String _formatTanggal(DateTime d) =>
      '${d.day} ${_namaBulan[d.month - 1]} ${d.year}';

  String get _labelDurasi {
    if (_rentang == null) return 'Pilih durasi';
    return '${_formatTanggal(_rentang!.start)} - ${_formatTanggal(_rentang!.end)}';
  }

  Future<void> _pilihDurasi() async {
    final hasil = await showDialog<DateTimeRange>(
      context: context,
      barrierColor: Colors.black45,
      builder: (_) => _DurasiPopup(rentangAwal: _rentang),
    );
    if (hasil != null) setState(() => _rentang = hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Filter',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close_rounded, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text('Kata Kunci',
                style:
                    GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            TextField(
              controller: _kataKunciCtrl,
              decoration: InputDecoration(
                hintText: 'Nama Pembeli atau Transaksi',
                hintStyle: GoogleFonts.inter(fontSize: 12, color: Colors.black38),
                isDense: true,
                border: const UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            Text('Durasi',
                style:
                    GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _pilihDurasi,
              child: Row(
                children: [
                  Expanded(
                    child: Text(_labelDurasi,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.black87)),
                  ),
                  const Icon(Icons.calendar_today_rounded,
                      size: 18, color: _oranye),
                ],
              ),
            ),
            const Divider(height: 20),
            Text('Jenis Transaksi',
                style:
                    GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(_jenis,
                      style:
                          GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
                ),
                const Icon(Icons.chevron_right_rounded,
                    size: 20, color: Colors.black45),
              ],
            ),
            const Divider(height: 20),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  widget.onTampilkan(_rentang, _kataKunciCtrl.text, _jenis);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _merah,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: Text('Tampilkan',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================
/// Popup Durasi — kalender 2 bulan dengan range picker.
/// ============================================================
class _DurasiPopup extends StatefulWidget {
  const _DurasiPopup({required this.rentangAwal});

  final DateTimeRange? rentangAwal;

  @override
  State<_DurasiPopup> createState() => _DurasiPopupState();
}

class _DurasiPopupState extends State<_DurasiPopup> {
  DateTime? _mulai;
  DateTime? _akhir;

  static const _namaBulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  static const _namaHari = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

  @override
  void initState() {
    super.initState();
    _mulai = widget.rentangAwal?.start;
    _akhir = widget.rentangAwal?.end;
  }

  void _tapTanggal(DateTime tanggal) {
    setState(() {
      if (_mulai == null || _akhir != null) {
        _mulai = tanggal;
        _akhir = null;
      } else if (tanggal.isBefore(_mulai!)) {
        _mulai = tanggal;
      } else {
        _akhir = tanggal;
      }
    });
  }

  String get _labelRentang {
    if (_mulai == null) return 'Pilih tanggal';
    String f(DateTime d) => '${d.day} ${_namaBulan[d.month - 1]} ${d.year}';
    if (_akhir == null) return f(_mulai!);
    return '${f(_mulai!)} - ${f(_akhir!)}';
  }

  @override
  Widget build(BuildContext context) {
    final acuan = _mulai ?? DateTime.now();
    final bulanTampil = [
      DateTime(acuan.year, acuan.month),
      DateTime(acuan.year, acuan.month + 1),
    ];

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Durasi',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close_rounded, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 340,
              child: SingleChildScrollView(
                child: Column(
                  children: bulanTampil
                      .map((b) => _KalenderBulan(
                            bulan: b,
                            mulai: _mulai,
                            akhir: _akhir,
                            onTap: _tapTanggal,
                            namaBulan: _namaBulan,
                            namaHari: _namaHari,
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(_labelRentang,
                style:
                    GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _mulai == null
                    ? null
                    : () => Navigator.of(context).pop(
                          DateTimeRange(start: _mulai!, end: _akhir ?? _mulai!),
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _merah,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _merah.withValues(alpha: 0.4),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: Text('Pilih',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kalender satu bulan dipakai di dalam `_DurasiPopup`.
class _KalenderBulan extends StatelessWidget {
  const _KalenderBulan({
    required this.bulan,
    required this.mulai,
    required this.akhir,
    required this.onTap,
    required this.namaBulan,
    required this.namaHari,
  });

  final DateTime bulan;
  final DateTime? mulai;
  final DateTime? akhir;
  final void Function(DateTime) onTap;
  final List<String> namaBulan;
  final List<String> namaHari;

  bool _sama(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final hariPertama = DateTime(bulan.year, bulan.month, 1);
    final offsetMinggu = hariPertama.weekday % 7; // Minggu = 0
    final jumlahHari = DateTime(bulan.year, bulan.month + 1, 0).day;

    final sel = <DateTime?>[
      for (var i = 0; i < offsetMinggu; i++) null,
      for (var d = 1; d <= jumlahHari; d++) DateTime(bulan.year, bulan.month, d),
    ];
    while (sel.length % 7 != 0) {
      sel.add(null);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Text(
            '${namaBulan[bulan.month - 1]} ${bulan.year}',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Row(
            children: namaHari
                .map((h) => Expanded(
                      child: Center(
                        child: Text(h,
                            style: GoogleFonts.inter(
                                fontSize: 10, color: Colors.black45)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 4),
          for (var baris = 0; baris < sel.length ~/ 7; baris++)
            Row(
              children: List.generate(7, (kolom) {
                final tanggal = sel[baris * 7 + kolom];
                if (tanggal == null) {
                  return const Expanded(child: SizedBox(height: 30));
                }

                final adalahUjung = (mulai != null && _sama(tanggal, mulai!)) ||
                    (akhir != null && _sama(tanggal, akhir!));
                final dalamRentang = mulai != null &&
                    akhir != null &&
                    tanggal.isAfter(mulai!) &&
                    tanggal.isBefore(akhir!);

                Color? warnaLatar;
                var warnaTeks = Colors.black87;
                if (adalahUjung) {
                  warnaLatar = _oranye;
                  warnaTeks = Colors.white;
                } else if (dalamRentang) {
                  warnaLatar = _kuning;
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(tanggal),
                    child: SizedBox(
                      height: 30,
                      child: Center(
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                              color: warnaLatar, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text('${tanggal.day}',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: warnaTeks)),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}