import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  late double _volume;
  late bool _musicEnabled;

  @override
  void initState() {
    super.initState();
    _volume = SoundService.volume;
    _musicEnabled = SoundService.musicEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('lib/assets/Fondo.jpg', fit: BoxFit.cover)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _header(),
                  const SizedBox(height: 22),
                  _panel(
                    child: Column(
                      children: [
                        const Text('VOLUMEN',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900)),
                        Row(
                          children: [
                            const Icon(Icons.volume_down_rounded),
                            Expanded(
                              child: Slider(
                                value: _volume,
                                min: 0,
                                max: 1,
                                divisions: 10,
                                label: '${(_volume * 100).round()}%',
                                onChanged: (value) {
                                  setState(() => _volume = value);
                                  SoundService.setVolume(value);
                                },
                              ),
                            ),
                            const Icon(Icons.volume_up_rounded),
                          ],
                        ),
                        Text('${(_volume * 100).round()}%',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Divider(height: 28),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('MÚSICA DE FONDO',
                              style: TextStyle(fontWeight: FontWeight.w900)),
                          subtitle:
                              const Text('Activar o quitar la música del menú'),
                          value: _musicEnabled,
                          onChanged: (value) async {
                            setState(() => _musicEnabled = value);
                            await SoundService.setMusicEnabled(value);
                          },
                        ),
                        const Divider(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _showCredits,
                            icon: const Icon(Icons.people_alt_rounded),
                            label: const Text('MOSTRAR CRÉDITOS',
                                style: TextStyle(fontWeight: FontWeight.w900)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF22C55E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(
                                  color: Colors.black, width: 2.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        SoundService.playKlickSound();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('VOLVER',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Colors.black, width: 2.5),
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

  Widget _header() => Container(
        width: double.infinity,
        height: 76,
        decoration: BoxDecoration(
          color: const Color(0xFFFFCA28),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black, width: 3.5),
        ),
        alignment: Alignment.center,
        child: const Text(
          'OPCIONES',
          style: TextStyle(
              color: Color(0xFF15803D),
              fontSize: 30,
              fontWeight: FontWeight.w900),
        ),
      );

  Widget _panel({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: child,
      );

  void _showCredits() {
    SoundService.playKlickSound();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CRÉDITOS', textAlign: TextAlign.center),
        content: const Text(
          'Puzzle SLiDe 64\n\nAdriana Gomes\nDaniel Vera',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CERRAR')),
        ],
      ),
    );
  }
}
