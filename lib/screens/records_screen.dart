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
    final records = ['FÁCIL', 'MEDIO', 'DIFÍCIL'];
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('lib/assets/Fondo.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _header(),
                  const SizedBox(height: 18),
                  const Text(
                    'MEJORES PARTIDAS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                            color: Colors.black,
                            offset: Offset(1, 2),
                            blurRadius: 3)
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: records.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final difficulty = records[index];
                        final record = RecordService.getRecord(difficulty);
                        return _recordCard(difficulty, record);
                      },
                    ),
                  ),
                  _backButton(context),
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
          'RÉCORDS',
          style: TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 30,
              fontWeight: FontWeight.w900),
        ),
      );

  Widget _recordCard(String difficulty, PuzzleRecord? record) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(
                color: Colors.black45, offset: Offset(0, 4), blurRadius: 2)
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.emoji_events_rounded,
                color: Color(0xFFFFCA28), size: 42),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                difficulty,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ),
            if (record == null)
              const Text('SIN PARTIDAS',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey))
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Tiempo: ${_formatTime(record.seconds)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Movimientos: ${record.moves}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
          ],
        ),
      );

  Widget _backButton(BuildContext context) => SizedBox(
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: Colors.black, width: 2.5),
          ),
        ),
      );
}
