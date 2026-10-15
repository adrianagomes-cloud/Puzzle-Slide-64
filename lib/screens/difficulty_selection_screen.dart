import 'package:flutter/material.dart';
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

                  // BANNER SUPERIOR CON LOGO PUZZLE SLIDE 64
                  _buildHeaderLogo(),

                  const SizedBox(height: 12),

                  // TÍTULO: SELECCIONA LA DIFICULTAD
                  const Text(
                    'SELECCIONA LA DIFICULTAD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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

                  // BOTONES DE DIFICULTAD
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // FÁCIL (3x3 - 8 Piezas)
                          _build3DArcadeButton(
                            text: 'FÁCIL',
                            imagePath: 'lib/assets/hongo.png',
                            imageScale: 1.1,
                            surfaceColor: const Color(0xFF22C55E),
                            baseColor: const Color(0xFF14532D),
                            badgeColor: const Color(0xFF15803D),
                            textColor: Colors.white,
                            onPressed: () {
                              _navigateToGame(context, gridSize: 3, difficultyName: 'FÁCIL');
                            },
                          ),
                          const SizedBox(height: 14),

                          // NORMAL (4x4 - 15 Piezas)
                          _build3DArcadeButton(
                            text: 'NORMAL',
                            imagePath: 'lib/assets/calamar.png',
                            imageScale: 1.5,
                            surfaceColor: const Color(0xFFFFCA28),
                            baseColor: const Color(0xFFB45309),
                            badgeColor: const Color(0xFFD97706),
                            textColor: const Color(0xFF1E293B),
                            onPressed: () {
                              _navigateToGame(context, gridSize: 4, difficultyName: 'NORMAL');
                            },
                          ),
                          const SizedBox(height: 14),

                          // DIFÍCIL (5x5 - 24 Piezas)
                          _build3DArcadeButton(
                            text: 'DIFÍCIL',
                            imagePath: 'lib/assets/bowser.png',
                            imageScale: 0.9,
                            surfaceColor: const Color(0xFFEF4444),
                            baseColor: const Color(0xFF991B1B),
                            badgeColor: const Color(0xFFB91C1C),
                            textColor: Colors.white,
                            onPressed: () {
                              _navigateToGame(context, gridSize: 5, difficultyName: 'DIFÍCIL');
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

          // 3. BOTÓN VOLVER ATRÁS
          Positioned(
            top: 36,
            left: 20,
            child: SafeArea(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black, width: 3.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 4),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToGame(BuildContext context, {required int gridSize, required String difficultyName}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          gridSize: gridSize,
          difficultyName: difficultyName,
        ),
      ),
    );
  }

  static Widget _buildHeaderLogo() {
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
            top: 0,
            left: 0,
            right: 0,
            bottom: 7,
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
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 2),
                        ],
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
    String? imagePath,
    double imageScale = 1.0,
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
            top: 0,
            left: 0,
            right: 0,
            bottom: 6,
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
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: imagePath != null
                        ? Transform.scale(
                            scale: imageScale,
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.grid_view_rounded,
                                color: textColor,
                                size: 24,
                              ),
                            ),
                          )
                        : Icon(Icons.star, color: textColor, size: 24),
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