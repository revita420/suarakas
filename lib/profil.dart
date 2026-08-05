import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'navbar.dart';

const _merah = Color(0xFFDA3838);
const _kuning = Color(0xFFFFD000);

class HalamanProfil extends StatefulWidget {
  const HalamanProfil({
    super.key,
    required this.nama,
    this.email = 'purirevitap@gmail.com',
    this.telepon = '+62 88211913576',
  });

  final String nama;
  final String email;
  final String telepon;

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil> {
  int _indexNav = indexNavBeranda;

  void _saatNavDipilih(int index) {
    // Profil bukan salah satu menu, jadi tidak ada halaman ini yang dilewati.
    final ditangani = bukaMenuNav(context, index: index, indexHalamanIni: -1);
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
              const _Header(),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FractionallySizedBox(
                    // Panel berhenti sebelum tepi kanan, seperti rancangannya.
                    widthFactor: 365 / 402,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(60),
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(36, 41, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: _Avatar(
                                inisial:
                                    widget.nama.characters.first.toUpperCase(),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              widget.nama,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: _merah,
                              ),
                            ),
                            const SizedBox(height: 40),
                            _BarisInfo(label: 'Email', nilai: widget.email),
                            const SizedBox(height: 24),
                            _BarisInfo(label: 'Telepon', nilai: widget.telepon),
                            const SizedBox(height: 24),
                            _BarisAksi(
                              label: 'Ubah Kata Sandi',
                              onTap: () {},
                            ),
                            const SizedBox(height: 20),
                            _BarisAksi(
                              label: 'Masuk dengan Email Lain',
                              icon: Icons.swap_horiz_rounded,
                              onTap: () {},
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: SizedBox(
                                width: 198,
                                height: 49,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: const StadiumBorder(),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Keluar',
                                    style: GoogleFonts.inter(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 143,
      decoration: const BoxDecoration(
        color: _merah,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(60)),
        boxShadow: [
          BoxShadow(
            color: Color(0x7F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(
            'Profil Saya',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.inisial});

  final String inisial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 114,
      height: 114,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: OvalBorder(side: BorderSide(width: 1)),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 98,
        height: 98,
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

/// Data yang hanya ditampilkan: label, isinya, lalu garis bawah.
class _BarisInfo extends StatelessWidget {
  const _BarisInfo({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(
          nilai,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.black.withValues(alpha: 0.50),
          ),
        ),
        const SizedBox(height: 6),
        const Divider(height: 1, thickness: 1, color: Colors.black),
      ],
    );
  }
}

/// Baris menu yang bisa ditekan, dengan ikon opsional di ujung kanan.
class _BarisAksi extends StatelessWidget {
  const _BarisAksi({required this.label, required this.onTap, this.icon});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
              ),
            ),
            if (icon != null) Icon(icon, size: 34, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}