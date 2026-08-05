import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'navbar.dart';
import 'profil.dart';

const _hijau = Color(0xFF3E771D);
const _merah = Color(0xFFDA3838);
const _oranye = Color(0xFFEC841C);
const _biru = Color(0xFF6889FF);
const _kuning = Color(0xFFFFD000);

/// Lebar rancangan asli, dipakai sebagai acuan penskalaan grafik gelembung.
const _lebarDesain = 402.0;

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  int _indexNav = indexNavBeranda;

  void _saatNavDipilih(int index) {
    final ditangani = bukaMenuNav(
      context,
      index: index,
      indexHalamanIni: indexNavBeranda,
    );
    if (ditangani) return;
    setState(() => _indexNav = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _Sapaan(nama: 'Revita'),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _KartuLabaBersih(nilai: '5jt'),
                  ),
                  SizedBox(height: 20),
                  _GrafikGelembung(),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _KartuPerforma(),
                  ),
                ],
              ),
            ),
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

class _Sapaan extends StatelessWidget {
  const _Sapaan({required this.nama});

  final String nama;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $nama!',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Siap mencatat transaksi hari ini?',
                style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Semantics(
          button: true,
          label: 'Buka profil',
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => HalamanProfil(nama: nama),
                ),
              );
            },
            child: _Avatar(inisial: nama.characters.first.toUpperCase()),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.inisial});

  final String inisial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 79,
      height: 79,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: OvalBorder(side: BorderSide(width: 1)),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 68,
        height: 68,
        decoration: const ShapeDecoration(
          gradient: LinearGradient(colors: [_kuning, _merah]),
          shape: OvalBorder(),
        ),
        alignment: Alignment.center,
        child: Text(
          inisial,
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _KartuLabaBersih extends StatelessWidget {
  const _KartuLabaBersih({required this.nilai});

  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_biru, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 44,
            color: Colors.black87,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Laba Bersih',
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  nilai,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.trending_up_rounded, size: 35, color: Colors.black87),
        ],
      ),
    );
  }
}

/// Tiga gelembung bertumpuk: pemasukan, pengeluaran dan piutang.
class _GrafikGelembung extends StatelessWidget {
  const _GrafikGelembung();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final skala = constraints.maxWidth / _lebarDesain;
        return SizedBox(
          height: 229 * skala,
          child: Stack(
            children: [
              Positioned(
                left: 107 * skala,
                top: 0,
                child: _Gelembung(
                  diameter: 190 * skala,
                  warna: _hijau,
                  nilai: '8jt',
                  ukuranNilai: 36 * skala,
                  label: 'Pemasukan',
                  ukuranLabel: 15 * skala,
                ),
              ),
              Positioned(
                left: 25 * skala,
                top: 109 * skala,
                child: _Gelembung(
                  diameter: 121 * skala,
                  warna: _merah,
                  nilai: '3jt',
                  ukuranNilai: 24 * skala,
                  label: 'Pengeluaran',
                  ukuranLabel: 12 * skala,
                ),
              ),
              Positioned(
                left: 281 * skala,
                top: 22 * skala,
                child: _Gelembung(
                  diameter: 83 * skala,
                  warna: _oranye,
                  nilai: '500rb',
                  ukuranNilai: 14 * skala,
                  label: 'Piutang',
                  ukuranLabel: 10 * skala,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Gelembung extends StatelessWidget {
  const _Gelembung({
    required this.diameter,
    required this.warna,
    required this.nilai,
    required this.ukuranNilai,
    required this.label,
    required this.ukuranLabel,
  });

  final double diameter;
  final Color warna;
  final String nilai;
  final double ukuranNilai;
  final String label;
  final double ukuranLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: ShapeDecoration(color: warna, shape: const OvalBorder()),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nilai,
            style: GoogleFonts.inter(
              fontSize: ukuranNilai,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: ukuranLabel,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Satu minggu pada grafik batang berkelompok. Semua nilai dalam juta rupiah.
class _DataMingguan {
  const _DataMingguan({
    required this.label,
    required this.pemasukan,
    required this.pengeluaran,
    required this.piutang,
  });

  final String label;
  final double pemasukan;
  final double pengeluaran;
  final double piutang;
}

const _dataPerforma = [
  _DataMingguan(
    label: 'Minggu 1',
    pemasukan: 1.8,
    pengeluaran: 0.6,
    piutang: 0.1,
  ),
  _DataMingguan(
    label: 'Minggu 2',
    pemasukan: 1.9,
    pengeluaran: 0.7,
    piutang: 0.15,
  ),
  _DataMingguan(
    label: 'Minggu 3',
    pemasukan: 2.0,
    pengeluaran: 0.8,
    piutang: 0.1,
  ),
  _DataMingguan(
    label: 'Minggu 4',
    pemasukan: 2.3,
    pengeluaran: 0.9,
    piutang: 0.15,
  ),
];

/// Batas atas sumbu Y (juta rupiah) dan jarak antar garis bantu.
const _maksSumbuY = 2.5;
const _langkahSumbuY = 0.5;
const _tinggiPlot = 150.0;

/// 2.5 -> "2,5jt", 0.5 -> "500rb", 0 -> "0".
String _formatJuta(double juta) {
  if (juta == 0) return '0';
  if (juta < 1) return '${(juta * 1000).round()}rb';
  final teks = juta.toStringAsFixed(juta.truncateToDouble() == juta ? 0 : 1);
  return '${teks.replaceAll('.', ',')}jt';
}

class _KartuPerforma extends StatelessWidget {
  const _KartuPerforma();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 14),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black.withValues(alpha: 0.20)),
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Performa Keuangan',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const _Legenda(),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 42,
                height: _tinggiPlot,
                child: Stack(
                  // Label teratas menonjol sedikit di atas garis plot.
                  clipBehavior: Clip.none,
                  children: [
                    for (var nilai = 0.0;
                        nilai <= _maksSumbuY + 0.001;
                        nilai += _langkahSumbuY)
                      Positioned(
                        right: 6,
                        // -6 menaruh titik tengah teks tepat di garis bantu.
                        bottom: nilai / _maksSumbuY * _tinggiPlot - 6,
                        child: Text(
                          _formatJuta(nilai),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: _tinggiPlot,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const _GarisBantu(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (final minggu in _dataPerforma)
                                Expanded(child: _KelompokBatang(data: minggu)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        for (final minggu in _dataPerforma)
                          Expanded(
                            child: Text(
                              minggu.label,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legenda extends StatelessWidget {
  const _Legenda();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 4,
      children: [
        _ItemLegenda(warna: _hijau, label: 'Pemasukan'),
        _ItemLegenda(warna: _merah, label: 'Pengeluaran'),
        _ItemLegenda(warna: _oranye, label: 'Piutang'),
      ],
    );
  }
}

class _ItemLegenda extends StatelessWidget {
  const _ItemLegenda({required this.warna, required this.label});

  final Color warna;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: Colors.black87),
        ),
      ],
    );
  }
}

class _GarisBantu extends StatelessWidget {
  const _GarisBantu();

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Garis teratas jatuh persis di tepi plot, jangan dipotong.
      clipBehavior: Clip.none,
      children: [
        for (var nilai = 0.0;
            nilai <= _maksSumbuY + 0.001;
            nilai += _langkahSumbuY)
          Positioned(
            left: 0,
            right: 0,
            bottom: nilai / _maksSumbuY * _tinggiPlot,
            child: Container(
              height: 1,
              color: nilai == 0 ? Colors.black26 : Colors.black12,
            ),
          ),
      ],
    );
  }
}

class _KelompokBatang extends StatelessWidget {
  const _KelompokBatang({required this.data});

  final _DataMingguan data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _Batang(nilai: data.pemasukan, warna: _hijau, label: 'Pemasukan'),
        const SizedBox(width: 5),
        _Batang(nilai: data.pengeluaran, warna: _merah, label: 'Pengeluaran'),
        const SizedBox(width: 5),
        _Batang(nilai: data.piutang, warna: _oranye, label: 'Piutang'),
      ],
    );
  }
}

class _Batang extends StatelessWidget {
  const _Batang({
    required this.nilai,
    required this.warna,
    required this.label,
  });

  final double nilai;
  final Color warna;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label ${_formatJuta(nilai)}',
      child: Container(
        width: 14,
        height: (nilai / _maksSumbuY * _tinggiPlot).clamp(2.0, _tinggiPlot),
        decoration: ShapeDecoration(
          color: warna,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
      ),
    );
  }
}