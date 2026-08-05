import 'package:flutter/material.dart';
import 'buku_kas/pencatatan.dart';
import 'catat_suara/catat_suara.dart';
import 'kalkulator.dart';
import 'notifikasi/notifikasi.dart';

const _merah = Color(0xFFDA3838);
const _kuning = Color(0xFFFFD000);

/// Posisi tiap menu di [daftarItemNav].
const indexNavBeranda = 0;
const indexNavRekamSuara = 1;
const indexNavBukuKas = 2;
const indexNavNotifikasi = 3;
const indexNavKalkulator = 4;

class ItemNav {
  const ItemNav(this.icon, this.label);

  final IconData icon;
  final String label;
}

const daftarItemNav = [
  ItemNav(Icons.home_rounded, 'Beranda'),
  ItemNav(Icons.mic_rounded, 'Rekam Suara'),
  ItemNav(Icons.request_quote_rounded, 'Buku Kas'),
  ItemNav(Icons.notifications_rounded, 'Notifikasi'),
  ItemNav(Icons.calculate_rounded, 'Kalkulator'),
];

/// Menangani penekanan item nav dari halaman yang sedang terbuka di
/// [indexHalamanIni]: membuka halaman tujuan bila menunya punya halaman dan
/// bukan halaman ini sendiri.
///
/// Mengembalikan true bila navigasi terjadi. Bila false, tidak ada halaman yang
/// dibuka dan pemanggil cukup memindahkan sorotan ke menu itu.
bool bukaMenuNav(
  BuildContext context, {
  required int index,
  required int indexHalamanIni,
}) {
  // Menu halaman ini sendiri: tidak ada yang dibuka, tapi sorotannya tetap
  // harus kembali ke sini — karena itu false, bukan true.
  if (index == indexHalamanIni) return false;

  // Beranda adalah halaman paling dasar setelah login, jadi kembali ke sana
  // dengan menutup halaman di atasnya — bukan mendorong salinan barunya.
  if (index == indexNavBeranda) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    return true;
  }

  final tujuan = switch (index) {
    indexNavBukuKas => const HalamanPencatatan(),
    indexNavRekamSuara => const HalamanCatatSuara(),
    indexNavNotifikasi => const HalamanNotifikasi(),
    indexNavKalkulator => const HalamanKalkulator(),
    _ => null,
  };
  if (tujuan == null) return false;
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => tujuan));
  return true;
}

class BilahNav extends StatelessWidget {
  const BilahNav({super.key, required this.indexAktif, required this.onPilih});

  final int indexAktif;
  final ValueChanged<int> onPilih;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kuning,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final (i, item) in daftarItemNav.indexed)
                    _TombolNav(
                      item: item,
                      aktif: i == indexAktif,
                      onTap: () => onPilih(i),
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

class _TombolNav extends StatelessWidget {
  const _TombolNav({
    required this.item,
    required this.aktif,
    required this.onTap,
  });

  final ItemNav item;
  final bool aktif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      item.icon,
      size: 29,
      // Ikon nonaktif dinaikkan ke black87 agar terbaca di latar kuning.
      color: aktif ? _merah : Colors.black87,
    );

    return Semantics(
      button: true,
      selected: aktif,
      label: item.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 63,
          height: 66,
          child: aktif
              // Item aktif diangkat ke dalam lingkaran putih bertumpuk.
              ? Transform.translate(
                  offset: const Offset(0, -14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.14),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: icon,
                  ),
                )
              : Center(child: icon),
        ),
      ),
    );
  }
}
