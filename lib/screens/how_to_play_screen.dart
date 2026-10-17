import 'package:flutter/material.dart';
import 'package:puzzle_slide_64/services/sound_service.dart';

class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({super.key});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  List<int> _demoBoard = [1, 2, 0, 3]; 
  int _instructionStep = 0;

  final List<Map<String, String>> _instructions = [
    {
      'title': '1. OBJETIVO DEL JUEGO',
      'desc': 'Ordena todas las fichas en secuencia numérica (1, 2, 3...) de izquierda a derecha y de arriba hacia abajo, dejando la casilla vacía al final.',
    },
    {
      'title': '2. DESLIZAR FICHAS',
      'desc': 'Para mover una ficha, simplemente tócala. Solo puedes mover las fichas que estén directamente al lado (arriba, abajo, izquierda o derecha) del espacio vacío.',
    },
    {
      'title': '3. TIEMPO Y MOVIMIENTOS',
      'desc': 'El cronómetro comenzará automáticamente en cuanto hagas tu primer movimiento. ¡Intenta resolverlo en el menor tiempo y número de toques posibles!',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Inicia la música tutorial.mp3 al entrar a la pantalla
    SoundService.startHowToPlayBgm();
  }

  @override
  void dispose() {
    // Restaura la música del menú principal al salir de la pantalla
    SoundService.startBgm();
    super.dispose();
  }

  void _onDemoTileTap(int index) {
    int emptyIndex = _demoBoard.indexOf(0);
    int size = 2;

    int tileRow = index ~/ size;
    int tileCol = index % size;
    int emptyRow = emptyIndex ~/ size;
    int emptyCol = emptyIndex % size;

    bool isAdjacent = (tileRow == emptyRow && (tileCol - emptyCol).abs() == 1) ||
        (tileCol == emptyCol && (tileRow - emptyRow).abs() == 1);

    if (isAdjacent) {
      setState(() {
        _demoBoard[emptyIndex] = _demoBoard[index];
        _demoBoard[index] = 0;
      });
    }
  }

  void _resetDemoBoard() {
    setState(() {
      _demoBoard = [1, 2, 0, 3];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/Fondo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF60A5FA),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildHeaderBanner(),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 780),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildInteractiveDemoBox(),
                            const SizedBox(height: 20),
                            _buildInstructionCard(),
                            const SizedBox(height: 16),
                            _buildStepNavigation(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // BOTÓN FLOTANTE ROJO DE SALIDA
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
      constraints: const BoxConstraints(maxWidth: 500),
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    'lib/assets/Comojugar.png',
                    height: 42,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      '¿CÓMO JUGAR?',
                      style: TextStyle(
                        fontSize: 24,
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

  Widget _buildInteractiveDemoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 3.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.touch_app_rounded, color: Color(0xFFFFCA28), size: 22),
              const SizedBox(width: 8),
              const Text(
                '¡PRUEBA AQUÍ MISMO!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                onPressed: _resetDemoBoard,
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 180,
            height: 180,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                int value = _demoBoard[index];
                if (value == 0) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black38, width: 2),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () => _onDemoTileTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFB45309),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 2.5),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0, left: 0, right: 0, bottom: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFCA28),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: Text(
                                '$value',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Haz clic en la ficha 3 para deslizarla a la casilla vacía.',
            style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard() {
    final currentInstruction = _instructions[_instructionStep];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey<int>(_instructionStep),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 3.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentInstruction['title']!,
              style: const TextStyle(
                color: Color(0xFFB45309),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentInstruction['desc']!,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Opacity(
          opacity: _instructionStep > 0 ? 1.0 : 0.0,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
            ),
            onPressed: _instructionStep > 0
                ? () {
                    setState(() {
                      _instructionStep--;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Anterior'),
          ),
        ),
        Row(
          children: List.generate(_instructions.length, (index) {
            bool isActive = index == _instructionStep;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 22 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFFFCA28) : Colors.white60,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
            );
          }),
        ),
        Opacity(
          opacity: _instructionStep < _instructions.length - 1 ? 1.0 : 0.0,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
            ),
            onPressed: _instructionStep < _instructions.length - 1
                ? () {
                    setState(() {
                      _instructionStep++;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text('Siguiente'),
          ),
        ),
      ],
    );
  }
}