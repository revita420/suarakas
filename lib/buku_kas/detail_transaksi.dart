import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../navbar.dart';

const _merah = Color(0xFFDA3838);
const _hijau = Color(0xFF4E8E23);
const _kuning = Color(0xFFFFD000);

String formatRupiah(int jumlah) {
  final angka = jumlah.abs().toString();
  final hasil = StringBuffer('Rp ');
  for (var i = 0; i < angka.length; i++) {
    if (i > 0 && (angka.length - i) % 3 == 0) hasil.write('.');
    hasil.write(angka[i]);
  }
  return hasil.toString();
}

class HalamanDetailTransaksi extends StatefulWidget {
  const HalamanDetailTransaksi({
    super.key,
    required this.judul,
    required this.tanggal,
    required this.jam,
    required this.jumlah,
    required this.pemasukan,
    required this.hargaMinimum,
    required this.hargaMaksimum,
  });

  final String judul;
  final String tanggal;
  final String jam;
  final int jumlah;
  final bool pemasukan;
  final int hargaMinimum;
  final int hargaMaksimum;

  bool get hargaSesuaiKisaran =>
      jumlah >= hargaMinimum && jumlah <= hargaMaksimum;

  @override
  State<HalamanDetailTransaksi> createState() => _HalamanDetailTransaksiState();
}

class _HalamanDetailTransaksiState extends State<HalamanDetailTransaksi> {
  int _indexNav = indexNavBukuKas;

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
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 116,
                      width: double.infinity,
                      color: _merah,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                        child: Row(
                          children: [
                            _TombolKembali(
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Detail Transaksi',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(color: Colors.white),
                    ),
                  ],
                ),
                Positioned(
                  top: 78,
                  left: 16,
                  right: 16,
                  bottom: 0,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x1F000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    14,
                                    12,
                                    14,
                                    12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rincian Pesanan',
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _BarisRincian(
                                        label: 'Produk',
                                        value: widget.judul,
                                      ),
                                      _BarisRincian(
                                        label: 'Tanggal',
                                        value: '${widget.tanggal} ${widget.jam}',
                                      ),
                                      _BarisRincian(
                                        label: 'Harga Tercatat',
                                        valueWidget: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              formatRupiah(widget.jumlah),
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                            if (!widget.hargaSesuaiKisaran) ...[
                                              const SizedBox(width: 4),
                                              const Icon(
                                                Icons.warning_amber_rounded,
                                                size: 16,
                                                color: _kuning,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      _BarisRincian(
                                        label: 'Kisaran Harga Sebelumnya',
                                        value:
                                            '${formatRupiah(widget.hargaMinimum)} - ${formatRupiah(widget.hargaMaksimum)}',
                                      ),
                                      _BarisRincian(
                                        label: 'Keterangan',
                                        value: widget.hargaSesuaiKisaran
                                            ? 'Harga sesuai dengan kisaran harga transaksi sebelumnya.'
                                            : 'Harga berada di luar kisaran sebelumnya. Periksa kembali data transaksi ini.',
                                        valueMaxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _TombolAksi(
                              warna: _merah,
                              ikon: Icons.edit_outlined,
                              label: 'Edit',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _TombolAksi(
                              warna: _hijau,
                              ikon: Icons.arrow_back_rounded,
                              label: 'Kembali',
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ],
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

class _TombolKembali extends StatelessWidget {
  const _TombolKembali({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Kembali',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 22,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _BarisRincian extends StatelessWidget {
  const _BarisRincian({
    required this.label,
    this.value,
    this.valueWidget,
    this.valueMaxLines = 1,
  }) : assert(value != null || valueWidget != null);

  final String label;
  final String? value;
  final Widget? valueWidget;
  final int valueMaxLines;

  @override
  Widget build(BuildContext context) {
    final isi = valueWidget ??
        Text(
          value ?? '',
          maxLines: valueMaxLines,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.black,
            height: 1.25,
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        DefaultTextStyle.merge(
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.black,
            height: 1.25,
          ),
          child: isi,
        ),
        const SizedBox(height: 11),
        const Divider(height: 1, thickness: 1, color: Color(0xFFD9D9D9)),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _TombolAksi extends StatelessWidget {
  const _TombolAksi({
    required this.warna,
    required this.ikon,
    required this.label,
    required this.onTap,
  });

  final Color warna;
  final IconData ikon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(ikon, size: 18, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: warna,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
    );
  }
}