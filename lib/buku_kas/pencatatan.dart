import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../navbar.dart';

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
    required this.jumlah,
    required this.pemasukan,
  });

  final String judul;
  final String tanggal;
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

  final List<Transaksi> _daftarTransaksi = const [
    Transaksi(
      judul: 'Rani - Cabai 1Kg',
      tanggal: '26 - 07 - 2026',
      jumlah: 30000,
      pemasukan: true,
    ),
    Transaksi(
      judul: 'Pembayaran Makanan',
      tanggal: '26 - 07 - 2026',
      jumlah: 10000,
      pemasukan: false,
    ),
    Transaksi(
      judul: 'Rani - Cabai 1Kg',
      tanggal: '26 - 07 - 2026',
      jumlah: 30000,
      pemasukan: true,
    ),
    Transaksi(
      judul: 'Rani - Cabai 1Kg',
      tanggal: '26 - 07 - 2026',
      jumlah: 30000,
      pemasukan: true,
    ),
    Transaksi(
      judul: 'Rani - Cabai 1Kg',
      tanggal: '26 - 07 - 2026',
      jumlah: 30000,
      pemasukan: true,
    ),
    Transaksi(
      judul: 'Rani - Cabai 1Kg',
      tanggal: '26 - 07 - 2026',
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
                          onFilter: () {},
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
                              child: SizedBox(
                                height: 58,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: const StadiumBorder(),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Lihat Grafik',
                                    style: GoogleFonts.inter(fontSize: 20),
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
          icon: Icons.calendar_month_rounded,
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
    return const Row(
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
          child: _TombolAksi(icon: Icons.list_alt_rounded, label: 'Aktivitas'),
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
  const _TombolAksi({required this.icon, required this.label});

  final IconData icon;
  final String label;

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
          onTap: () {},
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

    return Container(
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
    );
  }
}