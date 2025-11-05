import 'dart:async';
import 'package:flutter/foundation.dart';

/// Servicio para manejar el sistema de puntuación avanzado del crucigrama
class ScoringService {
  static const int basePointsPerWord = 10;
  static const int timeBonus = 5; // puntos por segundo restante
  static const int streakMultiplier = 2; // multiplicador por racha
  static const int perfectBonus = 100; // bonus por completar sin errores

  /// Calcula la puntuación basada en varios factores
  static int calculateScore({
    required int wordsFound,
    required int totalWords,
    required Duration timeElapsed,
    required Duration timeLimit,
    required int mistakes,
    required int streak,
  }) {
    // Puntos base por palabras encontradas
    int baseScore = wordsFound * basePointsPerWord;

    // Bonus por tiempo restante
    int timeRemainingSeconds = (timeLimit - timeElapsed).inSeconds;
    int timeBonusPoints = timeRemainingSeconds > 0
        ? timeRemainingSeconds * timeBonus
        : 0;

    // Multiplicador por racha de palabras consecutivas
    int streakBonus = (streak > 3)
        ? (streak - 3) * streakMultiplier * wordsFound
        : 0;

    // Bonus por completar sin errores
    int perfectBonusPoints = (mistakes == 0 && wordsFound == totalWords)
        ? perfectBonus
        : 0;

    // Penalización por errores
    int mistakePenalty = mistakes * 5;

    int totalScore =
        baseScore +
        timeBonusPoints +
        streakBonus +
        perfectBonusPoints -
        mistakePenalty;

    return totalScore.clamp(0, double.infinity).toInt();
  }

  /// Calcula el porcentaje de completado
  static double getCompletionPercentage(int wordsFound, int totalWords) {
    if (totalWords == 0) return 0.0;
    return (wordsFound / totalWords * 100).clamp(0.0, 100.0);
  }

  /// Determina la calificación basada en el porcentaje
  static String getGrade(double completionPercentage) {
    if (completionPercentage >= 95) return 'S+';
    if (completionPercentage >= 90) return 'S';
    if (completionPercentage >= 85) return 'A+';
    if (completionPercentage >= 80) return 'A';
    if (completionPercentage >= 75) return 'B+';
    if (completionPercentage >= 70) return 'B';
    if (completionPercentage >= 65) return 'C+';
    if (completionPercentage >= 60) return 'C';
    if (completionPercentage >= 50) return 'D';
    return 'F';
  }

  /// Obtiene el color asociado a la calificación
  static int getGradeColor(String grade) {
    switch (grade) {
      case 'S+':
        return 0xFFFFD700; // Oro
      case 'S':
        return 0xFFFFA500; // Naranja dorado
      case 'A+':
        return 0xFF32CD32; // Verde lima
      case 'A':
        return 0xFF00FF00; // Verde
      case 'B+':
        return 0xFF87CEEB; // Azul cielo
      case 'B':
        return 0xFF0000FF; // Azul
      case 'C+':
        return 0xFFFFFF00; // Amarillo
      case 'C':
        return 0xFFFFA500; // Naranja
      case 'D':
        return 0xFFFF4500; // Rojo naranja
      case 'F':
        return 0xFFFF0000; // Rojo
      default:
        return 0xFF808080; // Gris
    }
  }

  /// Genera un mensaje motivacional basado en el rendimiento
  static String getMotivationalMessage(
    String grade,
    int wordsFound,
    int totalWords,
  ) {
    double percentage = getCompletionPercentage(wordsFound, totalWords);

    if (grade == 'S+') {
      return '¡PERFECTO! 🌟 ¡Eres un maestro de crucigramas!';
    } else if (grade == 'S') {
      return '¡EXCELENTE! 🎯 ¡Casi perfecto!';
    } else if (grade.startsWith('A')) {
      return '¡MUY BIEN! 🎉 ¡Gran trabajo!';
    } else if (grade.startsWith('B')) {
      return '¡BIEN HECHO! 👍 ¡Buen esfuerzo!';
    } else if (grade.startsWith('C')) {
      return '¡NO ESTÁ MAL! 😊 ¡Sigue practicando!';
    } else if (grade == 'D') {
      return '¡PUEDES MEJORAR! 💪 ¡Inténtalo de nuevo!';
    } else {
      return '¡NO TE RINDAS! 🚀 ¡La práctica hace al maestro!';
    }
  }
}

/// Clase para manejar el temporizador del juego
class GameTimer {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration _timeLimit;
  bool _isRunning = false;

  final VoidCallback? onTick;
  final VoidCallback? onTimeUp;

  GameTimer({required Duration timeLimit, this.onTick, this.onTimeUp})
    : _timeLimit = timeLimit;

  Duration get elapsed => _elapsed;
  Duration get remaining => _timeLimit - _elapsed;
  bool get isRunning => _isRunning;
  bool get isTimeUp => _elapsed >= _timeLimit;

  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsed += Duration(seconds: 1);
      onTick?.call();

      if (_elapsed >= _timeLimit) {
        stop();
        onTimeUp?.call();
      }
    });
  }

  void pause() {
    _isRunning = false;
    _timer?.cancel();
  }

  void resume() {
    if (!_isRunning && !isTimeUp) {
      start();
    }
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
  }

  void reset() {
    stop();
    _elapsed = Duration.zero;
  }

  void dispose() {
    stop();
  }

  String get formattedTime {
    int minutes = remaining.inMinutes;
    int seconds = remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
