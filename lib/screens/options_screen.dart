import 'package:flutter/material.dart';
import 'package:puzzle_slide_64/services/sound_service.dart';

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

  // DIÁLOGO MODAL AJUSTADO PARA LOS CRÉDITOS
  void _showCreditsDialog(BuildContext context) {
    SoundService.playCoinSound();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Colors.black, width: 3.5),
        ),
        backgroundColor: Colors.white, // 🟢 FONDO BLANCO
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFCA28), // 🟢 CAJA SUPERIOR AMARILLA
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2.5),
          ),
          child: Image.asset(
            'lib/assets/creditos.png',
            height: 30, // 🟢 TAMAÑO MÁS COMPACTO
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Text(
              'CRÉDITOS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Image.asset(
              'lib/assets/Nombres.png',
              height: 45, // 🟢 TAMAÑO MÁS COMPACTO
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text(
                'ADRIANA GOMES\nDANIEL VERA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                side: const BorderSide(color: Colors.black, width: 2.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                SoundService.playKlickSound();
                Navigator.pop(context);
              },
              child: const Text(
                'CERRAR',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  // BANNER CON ESTILO DE BLOQUE DE MARIO
  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFB45309),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 3.5),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, bottom: 5,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFCA28),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(left: 8, top: 8, child: _buildDot()),
                  Positioned(left: 8, bottom: 8, child: _buildDot()),
                  Positioned(right: 8, top: 8, child: _buildDot()),
                  Positioned(right: 8, bottom: 8, child: _buildDot()),
                  Image.asset(
                    'lib/assets/opciones.png',
                    height: 42,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'OPCIONES',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF15803D),
                        letterSpacing: 1.2,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. FONDO DE PANTALLA
          Positioned.fill(
            child: Image.asset(
              'lib/assets/Fondo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF60A5FA),
              ),
            ),
          ),

          // 2. CAPA DE INTERFAZ PRINCIPAL
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    // BANNER SUPERIOR ESTILO CAJA DE MARIO
                    _buildHeaderBanner(),

                    const SizedBox(height: 16),

                    // TARJETA BLANCA DE CONFIGURACIÓN
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 3.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // TÍTULO VOLUMEN
                              const Text(
                                'VOLUMEN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // DESLIZADOR CON ICONOS Y CONTROLES
                              Row(
                                children: [
                                  const Icon(Icons.volume_down_rounded, color: Colors.black87, size: 22),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        activeTrackColor: const Color(0xFF7C3AED),
                                        inactiveTrackColor: Colors.grey.shade300,
                                        thumbColor: const Color(0xFF7C3AED),
                                        overlayColor: const Color(0x297C3AED),
                                        trackHeight: 6,
                                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                                      ),
                                      child: Slider(
                                        value: _volume,
                                        min: 0.0,
                                        max: 1.0,
                                        onChanged: (value) async {
                                          setState(() {
                                            _volume = value;
                                          });
                                          await SoundService.setVolume(value);
                                        },
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.volume_up_rounded, color: Colors.black87, size: 22),
                                ],
                              ),
                              Text(
                                '${(_volume * 100).round()}%',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),

                              const Divider(height: 24, thickness: 1, color: Colors.black12),

                              // SECCIÓN MÚSICA DE FONDO
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'MÚSICA DE FONDO',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Activar o quitar la música del menú',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch.adaptive(
                                    value: _musicEnabled,
                                    activeColor: const Color(0xFF7C3AED),
                                    onChanged: (value) async {
                                      setState(() {
                                        _musicEnabled = value;
                                      });
                                      await SoundService.setMusicEnabled(value);
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // BOTÓN VERDE "MOSTRAR CRÉDITOS"
                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => _showCreditsDialog(context),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF16A34A),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black, width: 2.5),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.group_rounded, color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'MOSTRAR CRÉDITOS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // BOTÓN ROJO INFERIOR "← VOLVER"
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        SoundService.playKlickSound();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 3.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(0, 4),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'VOLVER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}