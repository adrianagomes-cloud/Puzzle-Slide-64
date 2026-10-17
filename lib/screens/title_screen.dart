import 'package:flutter/material.dart';
import 'package:puzzle_slide_64/screens/main_menu_screen.dart';
import 'package:puzzle_slide_64/services/sound_service.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late Animation<double> _headerFloatAnimation;

  @override
  void initState() {
    super.initState();
    SoundService.startBgm();

    // Controlador de animación flotante
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Movimiento flotante para Mario
    _floatAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    // Movimiento flotante suave para el Banner del Título
    _headerFloatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
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

  // BANNER IDÉNTICO AL MAIN MENU
  Widget _buildTitleHeader() {
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

  void _enterMainMenu() async {
    await SoundService.play1UpSound();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainMenuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. FONDO AZUL CON PATRÓN
          Positioned.fill(
            child: Image.asset(
              'lib/assets/azul.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'lib/assets/azul.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF000066),
                ),
              ),
            ),
          ),

          // 2. CAPA PRINCIPAL DE LA INTERFAZ
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 820),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // 🟡 BANNER SUPERIOR CON ANIMACIÓN FLOTANTE
                    AnimatedBuilder(
                      animation: _headerFloatAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _headerFloatAnimation.value),
                          child: _buildTitleHeader(),
                        );
                      },
                    ),

                    const Spacer(),

                    // 🔴 MARIO EN EL CENTRO MÁS GRANDE (380px)
                    AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: SizedBox(
                            height: 380,
                            child: Image.asset(
                              'lib/assets/mario.gif',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                'lib/assets/mario.jpg',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.face_rounded,
                                  size: 200,
                                  color: Color(0xFFEF4444),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const Spacer(),

                    // 🟢 BOTÓN DE ENTRAR (IMAGEN ENTRAR.PNG)
                    GestureDetector(
                      onTap: _enterMainMenu,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Image.asset(
                          'lib/assets/entrar.png',
                          height: 55,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Text(
                            'ENTRAR',
                            style: TextStyle(
                              color: Color(0xFFFFCA28),
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
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