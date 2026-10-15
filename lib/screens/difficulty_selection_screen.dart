import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import 'game_screen.dart';

class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  const SizedBox(height: 36),
                  _buildHeaderBanner(),
                  const SizedBox(height: 12),
                  const Text(
                    '¡Selecciona tu nivel de desafío!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(1, 2), blurRadius: 3),
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
                          // 1. DIFICULTAD FÁCIL (3x3)
                          _build3DArcadeButton(
                            text: 'FÁCIL (3x3)',
                            imagePath: 'lib/assets/hongo.png',
                            surfaceColor: const Color(0xFF22C55E),
                            baseColor: const Color(0xFF14532D),
                            badgeColor: const Color(0xFF15803D),
                            textColor: Colors.white,
                            onPressed: () async {
                              SoundService.stopBgm(); // Detiene BGM para entrar a jugar
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameScreen(
                                    gridSize: 3,
                                    difficultyName: 'FÁCIL',
                                  ),
                                ),
                              );
                              SoundService.startBgm(); // Reanuda BGM al regresar
                            },
                          ),
                          const SizedBox(height: 14),

                          // 2. DIFICULTAD MEDIO (4x4)
                          _build3DArcadeButton(
                            text: 'MEDIO (4x4)',
                            imagePath: 'lib/assets/calamar.png',
                            surfaceColor: const Color(0xFFFFCA28),
                            baseColor: const Color(0xFFB45309),
                            badgeColor: const Color(0xFFD97706),
                            textColor: const Color(0xFF1E293B),
                            onPressed: () async {
                              SoundService.stopBgm(); // Detiene BGM para entrar a jugar
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameScreen(
                                    gridSize: 4,
                                    difficultyName: 'MEDIO',
                                  ),
                                ),
                              );
                              SoundService.startBgm(); // Reanuda BGM al regresar
                            },
                          ),
                          const SizedBox(height: 14),

                          // 3. DIFICULTAD DIFÍCIL (5x5)
                          _build3DArcadeButton(
                            text: 'DIFÍCIL (5x5)',
                            imagePath: 'lib/assets/bowser.png',
                            surfaceColor: const Color(0xFFEF4444),
                            baseColor: const Color(0xFF991B1B),
                            badgeColor: const Color(0xFFB91C1C),
                            textColor: Colors.white,
                            onPressed: () async {
                              SoundService.stopBgm(); // Detiene BGM para entrar a jugar
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameScreen(
                                    gridSize: 5,
                                    difficultyName: 'DIFÍCIL',
                                  ),
                                ),
                              );
                              SoundService.startBgm(); // Reanuda BGM al regresar
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

          // 3. BOTÓN FLOTANTE ROJO DE ATRÁS -> REPRODUCE KLICK
          Positioned(
            top: 24,
            left: 20,
            child: SafeArea(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  SoundService.playKlickSound();
                  Navigator.pop(context);
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black, width: 3.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 3),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
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
      constraints: const BoxConstraints(maxWidth: 780),
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFB45309),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black, width: 3.5),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, bottom: 7,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFCA28),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(left: 10, top: 10, child: _buildCornerDot()),
                  Positioned(left: 10, bottom: 10, child: _buildCornerDot()),
                  Positioned(right: 10, top: 10, child: _buildCornerDot()),
                  Positioned(right: 10, bottom: 10, child: _buildCornerDot()),
                  Image.asset(
                    'lib/assets/Nombre.png',
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'PUZZLE SLIDE 64',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFDC2626),
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
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _build3DArcadeButton({
    required String text,
    required String imagePath,
    required Color surfaceColor,
    required Color baseColor,
    required Color badgeColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 3.5),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.videogame_asset_rounded,
                        color: textColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: textColor,
                    size: 28,
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