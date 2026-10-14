import 'package:flutter/material.dart';
import 'difficulty_selection_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

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
            ),
          ),

          // 2. CAPA DE INTERFAZ PRINCIPAL
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  // ESPACIO PARA BAJAR EL LOGO SUPERIOR
                  const SizedBox(height: 36),

                  // BANNER SUPERIOR CON EFECTO 3D
                  Container(
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtítulo
                  const Text(
                    '¡Ordena las fichas y supera el desafío!',
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

                  // ESPACIADO EQUILIBRADO PARA CENTRAR BOTONES
                  const Spacer(flex: 2),

                  // BOTONES DEL MENÚ CENTRADOS
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // BOTÓN JUGAR (MARIO) -> NAVEGA A SELECCIÓN DE DIFICULTAD
                          _build3DArcadeButton(
                            text: 'JUGAR',
                            imagePath: 'lib/assets/mario.png',
                            surfaceColor: const Color(0xFFEF4444),
                            baseColor: const Color(0xFF991B1B),
                            badgeColor: const Color(0xFFB91C1C),
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DifficultySelectionScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 14),

                          // BOTÓN RÉCORDS (ESTRELLITA)
                          _build3DArcadeButton(
                            text: 'RÉCORDS',
                            imagePath: 'lib/assets/estrellita.png',
                            surfaceColor: const Color(0xFFFFCA28),
                            baseColor: const Color(0xFFB45309),
                            badgeColor: const Color(0xFFD97706),
                            textColor: const Color(0xFF1E293B),
                            onPressed: () {},
                          ),
                          const SizedBox(height: 14),

                          // BOTÓN OPCIONES (PLANTA PIRAÑA)
                          _build3DArcadeButton(
                            text: 'OPCIONES',
                            imagePath: 'lib/assets/planta.png',
                            surfaceColor: const Color(0xFF22C55E),
                            baseColor: const Color(0xFF14532D),
                            badgeColor: const Color(0xFF15803D),
                            textColor: Colors.white,
                            onPressed: () {},
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

          // 3. BOTÓN "CÓMO JUGAR"
          Positioned(
            top: 16,
            right: 25,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Acción para abrir las instrucciones
                    },
                    child: SizedBox(
                      width: 87,
                      height: 72,
                      child: Image.asset(
                        'lib/assets/bloque.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'CÓMO JUGAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
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

  // WIDGET DE BOTÓN 3D REUTILIZABLE
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
                  // CUADRO DEL ICONO / IMAGEN
                  Container(
                    width: 42,
                    height: 42,
                    padding: imagePath != null ? const EdgeInsets.all(3) : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: imagePath != null
                        ? Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                          )
                        : Icon(
                            icon,
                            color: textColor,
                            size: 24,
                          ),
                  ),
                  const SizedBox(width: 14),

                  // TEXTO DEL BOTÓN
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