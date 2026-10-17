import 'package:flutter/material.dart';
import '../services/record_service.dart';
import '../services/sound_service.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final difficulties = ['FÁCIL', 'MEDIO', 'DIFÍCIL'];

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

          // 2. INTERFAZ CENTRADA CON ANCHO CONTROLADO (NO TAN ALARGADO)
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildHeaderBanner(),
                    const SizedBox(height: 14),
                    const Text(
                      'MEJORES PARTIDAS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 2),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // LISTA DE RÉCORDS
                    Expanded(
                      child: ListView.separated(
                        itemCount: difficulties.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final difficulty = difficulties[index];
                          final record = RecordService.getRecord(difficulty);
                          return _recordCard(difficulty, record);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // BOTÓN VOLVER (ESTILO BLOQUE 3D ROJO)
                    _build3DBackButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BANNER CON EL BLOQUE ESTILO MARIO Y EL LOGO records.png
  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFB45309),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 3.5),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, bottom: 6,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFCA28),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(left: 8, top: 8, child: _buildDot()),
                  Positioned(left: 8, bottom: 8, child: _buildDot()),
                  Positioned(right: 8, top: 8, child: _buildDot()),
                  Positioned(right: 8, bottom: 8, child: _buildDot()),
                  Image.asset(
                    'lib/assets/records.png',
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'lib/assets/Records.png',
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        'RÉCORDS',
                        style: TextStyle(
                          color: Color(0xFFDC2626),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
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

  // TARJETA DE RÉCORD CON ESTRELLITA
  Widget _recordCard(String difficulty, PuzzleRecord? record) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 3.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 4),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          // ESTRELLITA RETRO
          SizedBox(
            width: 42,
            height: 42,
            child: Image.asset(
              'lib/assets/estrellita.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFCA28),
                size: 38,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              difficulty,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          if (record == null)
            const Text(
              'SIN PARTIDAS',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: Colors.grey,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Tiempo: ${_formatTime(record.seconds)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Color(0xFF15803D),
                  ),
                ),
                Text(
                  'Movimientos: ${record.moves}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // BOTÓN VOLVER 3D
  Widget _build3DBackButton(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF991B1B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, bottom: 5,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(10),
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
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  SoundService.playKlickSound();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}