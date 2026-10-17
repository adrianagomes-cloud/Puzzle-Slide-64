import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import 'difficulty_selection_screen.dart';
import 'how_to_play_screen.dart';
import 'options_screen.dart';
import 'records_screen.dart';
import 'title_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    SoundService.startBgm();
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildHeaderBanner(),
                  const SizedBox(height: 8),
                  const Text(
                    '¡Ordena las fichas y supera el desafío!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _build3DArcadeButton(
                            text: 'JUGAR',
                            imagePath: 'lib/assets/mario.png',
                            surfaceColor: const Color(0xFFEF4444),
                            baseColor: const Color(0xFF991B1B),
                            badgeColor: const Color(0xFFB91C1C),
                            textColor: Colors.white,
                            onPressed: () async {
                              SoundService.playEnterLevelSound();
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DifficultySelectionScreen(),
                                ),
                              );
                              SoundService.startBgm();
                            },
                          ),
                          const SizedBox(height: 12),
                          _build3DArcadeButton(
                            text: 'RÉCORDS',
                            imagePath: 'lib/assets/estrellita.png',
                            surfaceColor: const Color(0xFFFFCA28),
                            baseColor: const Color(0xFFB45309),
                            badgeColor: const Color(0xFFD97706),
                            textColor: const Color(0xFF1E293B),
                            onPressed: () {
                              SoundService.play1UpSound();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RecordsScreen()),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _build3DArcadeButton(
                            text: 'OPCIONES',
                            imagePath: 'lib/assets/planta.png',
                            surfaceColor: const Color(0xFF22C55E),
                            baseColor: const Color(0xFF14532D),
                            badgeColor: const Color(0xFF15803D),
                            textColor: Colors.white,
                            onPressed: () {
                              SoundService.playSettingsSound();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const OptionsScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),

          // 3. BOTÓN REGRESO AL TÍTULO (ARRIBA IZQUIERDA)
          Positioned(
            top: 12,
            left: 12,
            child: SafeArea(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await SoundService.playKlickSound();
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TitleScreen(),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 3),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'TÍTULO',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. BLOQUE ? (CÓMO JUGAR) - EN EL LADO DERECHO, DEBAJO DEL NIVEL DE OPCIONES
          Positioned(
            right: 24,
            bottom: 120,
            child: SafeArea(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  SoundService.playCoinSound();
                  SoundService.stopBgm();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HowToPlayScreen(),
                    ),
                  );
                  SoundService.startBgm();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 85,
                      height: 85,
                      child: Image.asset(
                        'lib/assets/bloque.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFCA28),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black, width: 3.5),
                          ),
                          child: const Icon(
                            Icons.help_outline_rounded,
                            size: 48,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'CÓMO JUGAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1.5, 1.5),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 580),
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFB45309),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 6,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFCA28),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(left: 8, top: 8, child: _buildCornerDot()),
                  Positioned(left: 8, bottom: 8, child: _buildCornerDot()),
                  Positioned(right: 8, top: 8, child: _buildCornerDot()),
                  Positioned(right: 8, bottom: 8, child: _buildCornerDot()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(
                      'lib/assets/Nombre.png',
                      height: 46,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        'PUZZLE SLIDE 64',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFDC2626),
                          letterSpacing: 1.2,
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
    );
  }

  static Widget _buildCornerDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _build3DArcadeButton({
    required String text,
    IconData? icon,
    String? imagePath,
    required Color surfaceColor,
    required Color baseColor,
    required Color badgeColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    padding: imagePath != null
                        ? const EdgeInsets.all(3)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: imagePath != null
                        ? Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              icon ?? Icons.play_arrow_rounded,
                              color: textColor,
                              size: 20,
                            ),
                          )
                        : Icon(
                            icon,
                            color: textColor,
                            size: 20,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: textColor,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}