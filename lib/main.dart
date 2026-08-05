import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kshnntyikqbmfkyabjkt.supabase.co',
    anonKey: 'sb_publishable_hCQZ5EFyPNEssUrXRRQHLw_sFgx_J9V',
  );

  runApp(const Aplikasi());
}

class Aplikasi extends StatelessWidget {
  const Aplikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suarakas',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFDB3939),
          primary: const Color(0xFFDB3939),
          secondary: const Color(0xFFFFD000),
          surface: Colors.white,
        ),
      ),
      home: const HalamanSelamatDatang(),
    );
  }
}

class HalamanSelamatDatang extends StatelessWidget {
  const HalamanSelamatDatang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(
                          text: 'Selamat Datang di ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: 'Suarakas',
                          style: GoogleFonts.dancingScript(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: _Ilustrasi(
                        assetPath: 'assets/images/store_illustration.png',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 92),
                        const Text(
                          'Masuk Sekarang!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const HalamanLogin(),
                              ),
                            );
                          },
                          child: Container(
                            width: 92,
                            height: 92,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD000),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.16),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 42,
                              color: Colors.black,
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
        ),
      ),
    );
  }
}

class _Ilustrasi extends StatelessWidget {
  const _Ilustrasi({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, nilai, child) {
        return Opacity(
          opacity: nilai,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - nilai)),
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: 260,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Cipratan kuas di belakang ilustrasi utama.
            Image.asset(
              'assets/images/brush_splash.png',
              width: 260,
              height: 220,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 260,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD000).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(28),
                  ),
                );
              },
            ),
            Image.asset(
              assetPath,
              height: 96,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.storefront_outlined,
                  size: 96,
                  color: Colors.black,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
