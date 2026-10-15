import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class GameScreen extends StatefulWidget {
  final int gridSize;
  final String difficultyName;

  const GameScreen({
    super.key,
    required this.gridSize,
    required this.difficultyName,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<int> _board;
  int _moves = 0;
  int _secondsPassed = 0;
  Timer? _timer;
  bool _isTimerRunning = false;
  bool _isSoundOn = true;
  bool _isGameWon = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _initNewGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getDifficultyLogoPath() {
    String diff = widget.difficultyName.toUpperCase();
    if (diff.contains('FÁCIL') || diff.contains('FACIL')) {
      return 'lib/assets/Facil.png';
    } else if (diff.contains('DIFÍCIL') || diff.contains('DIFICIL')) {
      return 'lib/assets/Dificil.png';
    } else {
      return 'lib/assets/Medio.png';
    }
  }

  void _initNewGame() {
    _timer?.cancel();
    _isTimerRunning = false;
    _secondsPassed = 0;
    _moves = 0;
    _isGameWon = false;
    _isPaused = false;

    int totalTiles = widget.gridSize * widget.gridSize;
    List<int> tiles = List.generate(totalTiles, (index) => (index + 1) % totalTiles);

    do {
      tiles.shuffle(Random());
    } while (!_isSolvable(tiles, widget.gridSize) || _isAlreadySolved(tiles));

    setState(() {
      _board = tiles;
    });
  }

  bool _isAlreadySolved(List<int> tiles) {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return tiles.last == 0;
  }

  bool _isSolvable(List<int> board, int size) {
    int inversions = 0;
    int total = size * size;

    for (int i = 0; i < total - 1; i++) {
      for (int j = i + 1; j < total; j++) {
        if (board[i] != 0 && board[j] != 0 && board[i] > board[j]) {
          inversions++;
        }
      }
    }

    if (size % 2 != 0) {
      return inversions % 2 == 0;
    } else {
      int emptyIndex = board.indexOf(0);
      int emptyRowFromBottom = size - (emptyIndex ~/ size);
      if (emptyRowFromBottom % 2 == 0) {
        return inversions % 2 != 0;
      } else {
        return inversions % 2 == 0;
      }
    }
  }

  void _startTimer() {
    if (_isTimerRunning || _isPaused) return;
    _isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _secondsPassed++;
        });
      }
    });
  }

  // --- LÓGICA DE PAUSA (SONIDO SOLO AL PAUSAR) ---
  void _togglePause() {
    if (_isGameWon) return;

    // Solo reproduce el sonido cuando se pulsa PAUSA (no al REANUDAR)
    if (!_isPaused) {
      SoundService.playPauseSound();
    }

    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      _timer?.cancel();
      _isTimerRunning = false;
    } else {
      if (_moves > 0) {
        _startTimer();
      }
    }
  }

  void _onTileTap(int index) {
    if (_isGameWon || _isPaused) return;

    int emptyIndex = _board.indexOf(0);
    int size = widget.gridSize;

    int tileRow = index ~/ size;
    int tileCol = index % size;
    int emptyRow = emptyIndex ~/ size;
    int emptyCol = emptyIndex % size;

    bool isAdjacent = (tileRow == emptyRow && (tileCol - emptyCol).abs() == 1) ||
        (tileCol == emptyCol && (tileRow - emptyRow).abs() == 1);

    if (isAdjacent) {
      if (!_isTimerRunning) {
        _startTimer();
      }

      setState(() {
        _board[emptyIndex] = _board[index];
        _board[index] = 0;
        _moves++;

        if (_isAlreadySolved(_board)) {
          _isGameWon = true;
          _timer?.cancel();
          _showWinDialog();
        }
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 3.5),
        ),
        title: const Text(
          '¡GANASTE!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFB45309),
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFCA28), size: 70),
            const SizedBox(height: 12),
            Text(
              'Tiempo: ${_formatTime(_secondsPassed)}\nMovimientos: $_moves',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _initNewGame();
            },
            child: const Text('Jugar de nuevo', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Menú Principal', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    int totalTiles = (widget.gridSize * widget.gridSize) - 1;

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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildTopPillButton(
                        icon: Icons.arrow_back_rounded,
                        label: 'MENÚ',
                        onPressed: () {
                          SoundService.playKlickSound();
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: _buildHeaderBanner()),
                      const SizedBox(width: 8),
                      _buildTopPillButton(
                        icon: _isSoundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                        label: 'SONIDO',
                        onPressed: () {
                          setState(() {
                            _isSoundOn = !_isSoundOn;
                            SoundService.isSoundOn = _isSoundOn;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1.5),
                  ),
                  child: Text(
                    '• ${widget.difficultyName} • ${widget.gridSize} × ${widget.gridSize} • $totalTiles PIEZAS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 820),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          bool isWide = constraints.maxWidth > 580;

                          if (isWide) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 160, child: _buildLeftStatsPanel()),
                                const SizedBox(width: 16),
                                Flexible(child: Center(child: _buildPuzzleBoard())),
                                const SizedBox(width: 16),
                                SizedBox(width: 160, child: _buildRightActionsPanel()),
                              ],
                            );
                          } else {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(width: 140, child: _buildMarioWhiteStatBox('TIEMPO', _formatTime(_secondsPassed))),
                                      SizedBox(width: 140, child: _buildMarioWhiteStatBox('MOVIMIENTOS', '$_moves')),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildPuzzleBoard(),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 130,
                                        child: _build3DActionButton(
                                          _isPaused ? 'REANUDAR' : 'PAUSA',
                                          _isPaused ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                                          _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                                          _togglePause,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 130,
                                        child: _build3DActionButton(
                                          'REINICIAR',
                                          const Color(0xFF22C55E),
                                          Icons.refresh_rounded,
                                          _initNewGame,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 4),
                  child: Column(
                    children: [
                      Text(
                        '¡Ordena las $totalTiles fichas del 1 al $totalTiles!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                      const Text(
                        'Pulsa una ficha junto al hueco para deslizarla.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFB45309),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, bottom: 4,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFCA28),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(left: 6, top: 6, child: _buildDot()),
                  Positioned(left: 6, bottom: 6, child: _buildDot()),
                  Positioned(right: 6, top: 6, child: _buildDot()),
                  Positioned(right: 6, bottom: 6, child: _buildDot()),
                  Image.asset(
                    _getDifficultyLogoPath(),
                    height: 38,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Text(
                      widget.difficultyName,
                      style: const TextStyle(
                        fontSize: 20,
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
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTopPillButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 2.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftStatsPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'TU PARTIDA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        _buildMarioWhiteStatBox('TIEMPO', _formatTime(_secondsPassed)),
        const SizedBox(height: 10),
        _buildMarioWhiteStatBox('MOVIMIENTOS', '$_moves'),
        const SizedBox(height: 10),
        Text(
          _isPaused ? '¡PARTIDA PAUSADA!' : '¡TÚ PUEDES!\nCada movimiento cuenta.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _isPaused ? const Color(0xFFFFCA28) : Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMarioWhiteStatBox(String title, String value) {
    return Container(
      width: double.infinity,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF94A3B8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 3.5),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, bottom: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(left: 6, top: 6, child: _buildDot()),
                  Positioned(left: 6, bottom: 6, child: _buildDot()),
                  Positioned(right: 6, top: 6, child: _buildDot()),
                  Positioned(right: 6, bottom: 6, child: _buildDot()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightActionsPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'A TU RITMO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        _build3DActionButton(
          _isPaused ? 'REANUDAR' : 'PAUSA',
          _isPaused ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
          _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          _togglePause,
        ),
        const SizedBox(height: 10),
        _build3DActionButton('REINICIAR', const Color(0xFF22C55E), Icons.refresh_rounded, _initNewGame),
        const SizedBox(height: 8),
        const Text(
          'Toca PAUSA para detener',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _build3DActionButton(String text, Color color, IconData icon, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black, width: 2.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzleBoard() {
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 420, maxHeight: 420),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A8A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1E293B), width: 4),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.gridSize,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: _board.length,
            itemBuilder: (context, index) {
              int tileValue = _board[index];
              if (tileValue == 0) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54, width: 2),
                  ),
                );
              }
              return _buildPuzzleTile(tileValue, () => _onTileTap(index));
            },
          ),
        ),

        if (_isPaused)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCA28),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pause_rounded, color: Colors.black, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'PAUSADO',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPuzzleTile(int value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFB45309),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.5),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0, bottom: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCA28),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(left: 4, top: 4, child: _buildDot()),
                    Positioned(left: 4, bottom: 4, child: _buildDot()),
                    Positioned(right: 4, top: 4, child: _buildDot()),
                    Positioned(right: 4, bottom: 4, child: _buildDot()),
                    Text(
                      '$value',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: widget.gridSize == 5 ? 22 : (widget.gridSize == 4 ? 26 : 32),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}