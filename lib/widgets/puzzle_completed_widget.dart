import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../services/supabase_service.dart';
import '../services/audio_service.dart';

class PuzzleCompletedWidget extends ConsumerStatefulWidget {
  const PuzzleCompletedWidget({super.key});

  @override
  ConsumerState<PuzzleCompletedWidget> createState() =>
      _PuzzleCompletedWidgetState();
}

class _PuzzleCompletedWidgetState extends ConsumerState<PuzzleCompletedWidget> {
  final TextEditingController _nameController = TextEditingController();
  bool _saving = false;
  bool _saved = false;
  bool _scoreAlreadySaved =
      false; // Nueva variable para controlar si ya se guardó la puntuación
  VoidCallback? _nameListener;

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el campo de nombre para actualizar el estado
    _nameListener = () {
      if (mounted) setState(() {});
    };
    _nameController.addListener(_nameListener!);
    // Reproducir sonido de completado cuando se muestre este widget
    AudioService.playEffect();
  }

  @override
  void dispose() {
    // Remover listener y disponer el controlador.
    if (_nameListener != null) {
      _nameController.removeListener(_nameListener!);
      _nameListener = null;
    }
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveScore() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _scoreAlreadySaved)
      return; // No permitir guardar si ya se guardó

    setState(() => _saving = true);

    final puzzle = ref.read(puzzleProvider);
    final selectedCategory = ref.read(selectedCategoryProvider);

    final int score = puzzle.selectedWords.length;
    final words = puzzle.selectedWords.map((w) => w.word).toList();

    final success = await SupabaseService.saveScoreRecord(
      categoryId: selectedCategory?.id,
      playerName: name,
      score: score,
      words: words,
    );

    if (!mounted) return;

    setState(() {
      _saving = false;
      _saved = success;
      if (success) {
        _scoreAlreadySaved = true; // Marcar que ya se guardó la puntuación
      }
    });

    // Limpiar el campo de nombre después de guardar exitosamente
    if (success) {
      // Esperar un poco para que el usuario vea el mensaje de éxito
      Future.delayed(Duration(milliseconds: 1500), () {
        if (mounted) {
          _nameController.clear();
          // NO resetear _saved ni _scoreAlreadySaved - mantener que ya se guardó
        }
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              success
                  ? '¡Puntuación guardada exitosamente!'
                  : 'Error guardando puntuación',
            ),
          ],
        ),
        backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
        duration: Duration(seconds: success ? 2 : 3),
      ),
    );
  }

  // _showTop5 removed: AppBar now exposes the unified leaderboard dialog.

  @override
  Widget build(BuildContext context) {
    final puzzle = ref.watch(puzzleProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final int score = puzzle.selectedWords.length;
    final words = puzzle.selectedWords.map((w) => w.word).toList();
    // Evitar overflow en portrait y landscape cuando el teclado aparece.
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          final orientation = MediaQuery.of(context).orientation;

          // En landscape reservamos menos altura para la tarjeta (deja espacio para teclados flotantes)
          final fraction = orientation == Orientation.landscape ? 0.66 : 0.85;
          final cardMaxHeight =
              (constraints.maxHeight * fraction) - bottomInset - 16;
          final cardWidth = constraints.maxWidth > 700
              ? 700.0
              : constraints.maxWidth * 0.96;

          return Stack(
            children: [
              // Contenido principal desplazable
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset, top: 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: cardWidth),
                    child: Card(
                      elevation: 6,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          // La tarjeta nunca excederá `cardMaxHeight`, permitiendo scroll interno si el contenido
                          // supera este valor. También dejamos un mínimo razonable.
                          maxHeight: cardMaxHeight.clamp(
                            220.0,
                            constraints.maxHeight,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.green.shade50,
                                Colors.blue.shade50,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Header con celebración
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green.shade400,
                                          Colors.blue.shade400,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.celebration,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          '¡FELICIDADES! 🎉',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Crucigrama completado',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Información del juego
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Colors.blue.shade200,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.category,
                                                color: Colors.blue.shade600,
                                                size: 20,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Categoría',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                selectedCategory?.nameEs ??
                                                    'Por defecto',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade700,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Colors.green.shade200,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.green.shade600,
                                                size: 20,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Puntuación',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                '$score palabras',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Lista de palabras encontradas
                                  if (words.isNotEmpty) ...[
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.purple.shade200,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.list_alt,
                                                color: Colors.purple.shade600,
                                                size: 18,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'Palabras encontradas:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.purple.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: (cardMaxHeight * 0.25)
                                                  .clamp(60.0, 220.0),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Wrap(
                                                spacing: 6,
                                                runSpacing: 4,
                                                children: words
                                                    .map(
                                                      (w) => Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .purple
                                                              .shade100,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors
                                                                .purple
                                                                .shade300,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          w,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .purple
                                                                .shade700,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],

                                  // Campo de nombre
                                  TextField(
                                    controller: _nameController,
                                    enabled:
                                        !_scoreAlreadySaved, // Deshabilitar si ya se guardó
                                    decoration: InputDecoration(
                                      labelText: 'Tu nombre',
                                      hintText:
                                          'Escribe tu nombre para guardar la puntuación',
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.blue.shade600,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.blue.shade300,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Botones de acción
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed:
                                              _saving ||
                                                  _scoreAlreadySaved ||
                                                  _nameController.text
                                                      .trim()
                                                      .isEmpty
                                              ? null
                                              : () => _saveScore(),
                                          icon: _saving
                                              ? SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                              : Icon(
                                                  _scoreAlreadySaved
                                                      ? Icons.check
                                                      : Icons.save,
                                                ),
                                          label: Text(
                                            _scoreAlreadySaved
                                                ? '¡Guardado!'
                                                : 'Guardar puntuación',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _scoreAlreadySaved
                                                ? Colors.green.shade600
                                                : Colors.blue.shade600,
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Botón jugar otra vez
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      ref.invalidate(workQueueProvider);
                                      ref.invalidate(puzzleProvider);
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Colors.orange.shade600,
                                    ),
                                    label: Text(
                                      'Jugar otra vez',
                                      style: TextStyle(
                                        color: Colors.orange.shade600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.orange.shade600,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // (Botón Top 5 movido al AppBar) - eliminado aquí para evitar duplicados.
            ],
          );
        },
      ),
    );
  }
}
