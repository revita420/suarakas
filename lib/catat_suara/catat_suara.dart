import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../navbar.dart';

const _merah = Color(0xFFDA3838);
const _kuning = Color(0xFFFFD000);

class HalamanCatatSuara extends StatefulWidget {
  const HalamanCatatSuara({super.key});

  @override
  State<HalamanCatatSuara> createState() => _HalamanCatatSuaraState();
}

class _HalamanCatatSuaraState extends State<HalamanCatatSuara> {
  int _indexNav = indexNavRekamSuara;
  bool _isRecording = false;
  String _teksJawa = '';
  String _teksIndonesia = '';
  String _dariBahasa = 'Jawa';
  String _keBahasa = 'Indonesia';
  late stt.SpeechToText _speech;
  bool _speechAvailable = false;
  List<stt.LocaleName> _locales = [];
  String? _currentLocaleId;

  void _saatNavDipilih(int index) {
    final ditangani = bukaMenuNav(
      context,
      index: index,
      indexHalamanIni: indexNavRekamSuara,
    );
    if (ditangani) return;
    setState(() => _indexNav = index);
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onStatus: (status) {},
        onError: (error) {},
      );
      if (_speechAvailable) {
        try {
          _locales = await _speech.locales();
          final sys = await _speech.systemLocale();
          _currentLocaleId = sys?.localeId;
        } catch (_) {
          _locales = [];
        }
      }
      setState(() {});
    } catch (_) {
      _speechAvailable = false;
    }
  }

  void _toggleRecording() async {
    if (!_speechAvailable) {
      // try to re-init
      await _initSpeech();
      if (!_speechAvailable) return;
    }

    if (!_isRecording) {
      setState(() => _isRecording = true);
      final localeId = _getLocaleForLang(_dariBahasa) ?? _currentLocaleId;
      await _speech.listen(
        onResult: (result) {
          setState(() {
            final words = result.recognizedWords;
            if (_dariBahasa == 'Jawa') {
              _teksJawa = words;
            } else {
              _teksIndonesia = words;
            }
          });
        },
        localeId: localeId,
      );
    } else {
      await _speech.stop();
      setState(() => _isRecording = false);
    }
  }

  String? _getLocaleForLang(String lang) {
    if (_locales.isEmpty) return _currentLocaleId;
    final l = lang.toLowerCase();
    if (l.contains('indonesia') ||
        l == 'indonesia' ||
        l.contains('indonesian') ||
        l == 'id') {
      try {
        return _locales.firstWhere((e) => e.localeId.startsWith('id')).localeId;
      } catch (_) {
        return _currentLocaleId;
      }
    }
    if (l.contains('jawa') || l == 'jawa' || l.contains('javanese')) {
      // try jv (Javanese) if available, otherwise fallback to Indonesian
      try {
        return _locales.firstWhere((e) => e.localeId.startsWith('jv')).localeId;
      } catch (_) {
        try {
          return _locales
              .firstWhere((e) => e.localeId.startsWith('id'))
              .localeId;
        } catch (_) {
          return _currentLocaleId;
        }
      }
    }
    // default to english if language looks like english or no match
    try {
      return _locales.firstWhere((e) => e.localeId.startsWith('en')).localeId;
    } catch (_) {
      return _currentLocaleId;
    }
  }

  void _swapLanguages() {
    setState(() {
      final tmp = _dariBahasa;
      _dariBahasa = _keBahasa;
      _keBahasa = tmp;
      final tmpT = _teksJawa;
      _teksJawa = _teksIndonesia;
      _teksIndonesia = tmpT;
    });
  }

  // Inline editing handled inside _TextCard; no dialog helper needed.

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Catat Suara',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _LangPill(label: _dariBahasa),
                        IconButton(
                          onPressed: _swapLanguages,
                          icon: const Icon(Icons.swap_horiz_rounded),
                          color: Colors.black87,
                        ),
                        _LangPill(label: _keBahasa),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _TextCard(
                      label: _dariBahasa,
                      text: _dariBahasa == 'Jawa' ? _teksJawa : _teksIndonesia,
                      onChanged: (val) {
                        setState(() {
                          if (_dariBahasa == 'Jawa') {
                            _teksJawa = val;
                          } else {
                            _teksIndonesia = val;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _TextCard(
                      label: _keBahasa,
                      text: _keBahasa == 'Indonesia'
                          ? _teksIndonesia
                          : _teksJawa,
                      onChanged: (val) {
                        setState(() {
                          if (_keBahasa == 'Indonesia') {
                            _teksIndonesia = val;
                          } else {
                            _teksJawa = val;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_kuning, Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: _isRecording
                          ? Icon(
                              Icons.graphic_eq_rounded,
                              size: 64,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.equalizer_rounded,
                              size: 64,
                              color: Colors.white70,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isRecording) ...[
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isRecording = false;
                              });
                            },
                            icon: const Icon(Icons.check_rounded),
                            color: _merah,
                            iconSize: 36,
                          ),
                        ],
                        FloatingActionButton(
                          onPressed: _toggleRecording,
                          backgroundColor: _merah,
                          child: Icon(
                            _isRecording
                                ? Icons.pause_rounded
                                : Icons.mic_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (_isRecording) ...[
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isRecording = false;
                                _teksJawa = '';
                                _teksIndonesia = '';
                              });
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            color: Colors.black87,
                            iconSize: 32,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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

class _LangPill extends StatelessWidget {
  const _LangPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black.withValues(alpha: 0.20)),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}

class _TextCard extends StatefulWidget {
  const _TextCard({required this.label, required this.text, this.onChanged});
  final String label;
  final String text;
  final ValueChanged<String>? onChanged;

  @override
  State<_TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<_TextCard> {
  late bool _editing;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _editing = false;
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant _TextCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && !_editing) {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final val = _controller.text;
    widget.onChanged?.call(val);
    setState(() => _editing = false);
  }

  void _cancel() {
    _controller.text = widget.text;
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 100,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black.withValues(alpha: 0.20)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _editing
          ? Stack(
              children: [
                // Text area with extra right padding so buttons don't overlap
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 72.0),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                // Circular buttons at top-right
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFFFFF),
                        ),
                        child: IconButton(
                          onPressed: _save,
                          icon: const Icon(Icons.check_rounded),
                          color: _merah,
                          splashRadius: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFFFFF),
                        ),
                        child: IconButton(
                          onPressed: _cancel,
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.black54,
                          splashRadius: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: () => setState(() => _editing = true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.text,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
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
