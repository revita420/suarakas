import 'package:flutter/material.dart';
import '../beranda.dart';
import 'register.dart';

class HalamanLogin extends StatelessWidget {
  const HalamanLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDB3939), Color(0xFFFFD000)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Selamat Datang!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masuk untuk Melanjutkan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 34),
                    const _KolomIsian(
                      petunjuk: 'Nama Pengguna',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    const _KolomIsian(
                      petunjuk: 'Kata Sandi',
                      icon: Icons.lock_outline,
                      rahasia: true,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          // Membuang layar selamat datang dan login sekaligus,
                          // sehingga beranda jadi halaman paling dasar — tombol
                          // kembali tidak mengantar pengguna balik ke login.
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<void>(
                              builder: (_) => const HalamanBeranda(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Color(0xFFDEDEDE))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Atau lanjutkan dengan',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Color(0xFFDEDEDE))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TombolSosial(
                          child: Text(
                            'G',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFDB4437),
                            ),
                          ),
                        ),
                        SizedBox(width: 22),
                        _TombolSosial(
                          child: Icon(
                            Icons.facebook,
                            size: 26,
                            color: Color(0xFF1877F2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const HalamanRegister(),
                              ),
                            );
                          },
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              color: Color(0xFFDB3939),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KolomIsian extends StatefulWidget {
  const _KolomIsian({
    required this.petunjuk,
    required this.icon,
    this.rahasia = false,
  });

  final String petunjuk;
  final IconData icon;

  /// Menyembunyikan isian dan memunculkan tombol mata untuk mengintipnya.
  final bool rahasia;

  @override
  State<_KolomIsian> createState() => _KolomIsianState();
}

class _KolomIsianState extends State<_KolomIsian> {
  late bool _tersembunyi = widget.rahasia;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _tersembunyi,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: widget.petunjuk,
        prefixIcon: Icon(widget.icon, color: Colors.black87),
        suffixIcon: !widget.rahasia
            ? null
            : IconButton(
                onPressed: () =>
                    setState(() => _tersembunyi = !_tersembunyi),
                icon: Icon(
                  _tersembunyi
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.black87,
                ),
                tooltip: _tersembunyi
                    ? 'Tampilkan kata sandi'
                    : 'Sembunyikan kata sandi',
              ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}

class _TombolSosial extends StatelessWidget {
  const _TombolSosial({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}