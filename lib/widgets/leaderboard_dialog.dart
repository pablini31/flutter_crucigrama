import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

/// Muestra un diálogo estilizado con el Top N scores (por defecto 5).
/// Puedes pasar categoryId para filtrar por categoría.
Future<void> showLeaderboardDialog(
  BuildContext context, {
  String? categoryId,
  int limit = 5,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 16,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade50, Colors.purple.shade50],
            ),
          ),
          child: Column(
            children: [
              // Header con gradiente
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.purple.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.white, size: 32),
                    SizedBox(height: 8),
                    Text(
                      '🏆 TOP $limit JUGADORES 🏆',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Contenido del leaderboard
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: SupabaseService.getTopScores(
                    categoryId: categoryId,
                    limit: limit,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade600,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Cargando puntuaciones...',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red.shade400,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Error al cargar scores',
                              style: TextStyle(color: Colors.red.shade600),
                            ),
                          ],
                        ),
                      );
                    }

                    final items = snapshot.data ?? [];
                    if (items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sports_esports,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '¡Sé el primero en jugar!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Aún no hay puntuaciones.',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final row = items[index];
                        final name = (row['player_name'] ?? 'Anónimo')
                            .toString();
                        final score = row['score']?.toString() ?? '0';
                        final created = row['created_at'];

                        String dateText = '';
                        try {
                          if (created != null) {
                            final dt = DateTime.parse(
                              created.toString(),
                            ).toLocal();
                            final now = DateTime.now();
                            final difference = now.difference(dt);

                            if (difference.inDays > 0) {
                              dateText =
                                  'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
                            } else if (difference.inHours > 0) {
                              dateText =
                                  'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
                            } else if (difference.inMinutes > 0) {
                              dateText = 'hace ${difference.inMinutes} min';
                            } else {
                              dateText = 'ahora mismo';
                            }
                          }
                        } catch (_) {}

                        // Colores y iconos para las posiciones
                        Color cardColor;
                        Color accentColor;
                        IconData positionIcon;
                        String positionText;

                        switch (index) {
                          case 0:
                            cardColor = Color(
                              0xFFFFD700,
                            ).withValues(alpha: 0.2);
                            accentColor = Color(0xFFFFD700);
                            positionIcon = Icons.emoji_events;
                            positionText = '1°';
                            break;
                          case 1:
                            cardColor = Color(
                              0xFFC0C0C0,
                            ).withValues(alpha: 0.2);
                            accentColor = Color(0xFFC0C0C0);
                            positionIcon = Icons.workspace_premium;
                            positionText = '2°';
                            break;
                          case 2:
                            cardColor = Color(
                              0xFFCD7F32,
                            ).withValues(alpha: 0.2);
                            accentColor = Color(0xFFCD7F32);
                            positionIcon = Icons.military_tech;
                            positionText = '3°';
                            break;
                          default:
                            cardColor = Colors.white.withValues(alpha: 0.8);
                            accentColor = Colors.blue.shade600;
                            positionIcon = Icons.person;
                            positionText = '${index + 1}°';
                        }

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          child: Card(
                            elevation: index < 3 ? 8 : 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: index < 3
                                  ? BorderSide(color: accentColor, width: 2)
                                  : BorderSide.none,
                            ),
                            color: cardColor,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Posición con icono
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          accentColor,
                                          accentColor.withValues(alpha: 0.7),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: accentColor.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          positionIcon,
                                          color: index < 3
                                              ? Colors.white
                                              : Colors.white,
                                          size: 20,
                                        ),
                                        Text(
                                          positionText,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 16),

                                  // Información del jugador
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        if (dateText.isNotEmpty)
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 14,
                                                color: Colors.grey.shade500,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                dateText,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Puntuación
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          accentColor.withValues(alpha: 0.2),
                                          accentColor.withValues(alpha: 0.1),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: accentColor.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: accentColor,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          score,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: accentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Botón de cerrar
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                  label: Text('Cerrar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
