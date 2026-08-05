import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../navbar.dart';

const _merah = Color(0xFFDA3838);
const _kuning = Color(0xFFFFD000);
const _hijau = Color(0xFF86D459);

class Notifikasi {
  Notifikasi({
    required this.judul,
    required this.pesan,
    required this.icon,
    required this.warnaLencana,
    this.sudahDibaca = false,
  });

  final String judul;
  final String pesan;
  final IconData icon;
  final Color warnaLencana;
  bool sudahDibaca;
}

class HalamanNotifikasi extends StatefulWidget {
  const HalamanNotifikasi({super.key});

  @override
  State<HalamanNotifikasi> createState() => _HalamanNotifikasiState();
}

class _HalamanNotifikasiState extends State<HalamanNotifikasi> {
  int _indexNav = indexNavNotifikasi;

  /// True saat penyaring "Belum dibaca" yang sedang dipilih.
  bool _hanyaBelumDibaca = false;

  final List<Notifikasi> _daftarNotifikasi = [
    Notifikasi(
      judul: 'Pengingat Piutang',
      pesan: 'Piutang sebesar Rp250.000 dari Budi Santoso telah jatuh tempo '
          'pada 27 Juli 2026.',
      icon: Icons.schedule_rounded,
      warnaLencana: _hijau,
    ),
    Notifikasi(
      judul: 'Anomali Harga Terdeteksi',
      pesan: 'Harga Cabai 2 kg tercatat Rp20.000, berbeda dari kisaran harga '
          'biasanya.',
      icon: Icons.warning_amber_rounded,
      warnaLencana: _kuning,
    ),
  ];

  List<Notifikasi> get _terlihat => _hanyaBelumDibaca
      ? _daftarNotifikasi.where((n) => !n.sudahDibaca).toList()
      : _daftarNotifikasi;

  int get _jumlahBelumDibaca =>
      _daftarNotifikasi.where((n) => !n.sudahDibaca).length;

  void _tandaiSemuaDibaca() {
    setState(() {
      for (final notifikasi in _daftarNotifikasi) {
        notifikasi.sudahDibaca = true;
      }
    });
  }

  void _saatNavDipilih(int index) {
    final ditangani = bukaMenuNav(
      context,
      index: index,
      indexHalamanIni: indexNavNotifikasi,
    );
    if (ditangani) return;
    setState(() => _indexNav = index);
  }

  @override
  Widget build(BuildContext context) {
    final terlihat = _terlihat;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      _TombolKembali(
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Notifikasi',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: _jumlahBelumDibaca == 0
                          ? null
                          : _tandaiSemuaDibaca,
                      child: Text(
                        'Tandai semua sudah dibaca',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          color: _jumlahBelumDibaca == 0
                              ? Colors.black38
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: _Penyaring(
                    hanyaBelumDibaca: _hanyaBelumDibaca,
                    jumlahBelumDibaca: _jumlahBelumDibaca,
                    onPilih: (belumDibaca) =>
                        setState(() => _hanyaBelumDibaca = belumDibaca),
                  ),
                ),
                const SizedBox(height: 26),
                Expanded(
                  child: terlihat.isEmpty
                      ? Center(
                          child: Text(
                            'Tidak ada notifikasi yang belum dibaca.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(26, 2, 26, 20),
                          itemCount: terlihat.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 18),
                          itemBuilder: (context, i) => _KartuNotifikasi(
                            notifikasi: terlihat[i],
                            onTap: () => setState(
                              () => terlihat[i].sudahDibaca = true,
                            ),
                          ),
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
    );
  }
}

/// Dua tab: "Semua" dan "Belum dibaca". Yang terpilih diberi latar merah.
class _Penyaring extends StatelessWidget {
  const _Penyaring({
    required this.hanyaBelumDibaca,
    required this.jumlahBelumDibaca,
    required this.onPilih,
  });

  final bool hanyaBelumDibaca;
  final int jumlahBelumDibaca;
  final ValueChanged<bool> onPilih;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabPenyaring(
            label: 'Semua',
            aktif: !hanyaBelumDibaca,
            onTap: () => onPilih(false),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TabPenyaring(
            label: jumlahBelumDibaca == 0
                ? 'Belum dibaca'
                : 'Belum dibaca ($jumlahBelumDibaca)',
            aktif: hanyaBelumDibaca,
            onTap: () => onPilih(true),
          ),
        ),
      ],
    );
  }
}

class _TabPenyaring extends StatelessWidget {
  const _TabPenyaring({
    required this.label,
    required this.aktif,
    required this.onTap,
  });

  final String label;
  final bool aktif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: aktif,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: aktif ? _merah : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: aktif ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KartuNotifikasi extends StatelessWidget {
  const _KartuNotifikasi({required this.notifikasi, required this.onTap});

  final Notifikasi notifikasi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black.withValues(alpha: 0.20)),
            borderRadius: BorderRadius.circular(15),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: ShapeDecoration(
                color: notifikasi.warnaLencana,
                shape: const OvalBorder(),
              ),
              alignment: Alignment.center,
              child: Icon(notifikasi.icon, size: 20, color: Colors.black87),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notifikasi.judul,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      // Yang belum dibaca ditebalkan agar mudah dipindai.
                      fontWeight: notifikasi.sudahDibaca
                          ? FontWeight.w400
                          : FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notifikasi.pesan,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.black.withValues(alpha: 0.50),
                    ),
                  ),
                ],
              ),
            ),
            if (!notifikasi.sudahDibaca)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _merah,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}