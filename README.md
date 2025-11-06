# 🎮 Flutter Crucigrama - Juego de Crucigramas Completo

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

**Una aplicación de crucigramas moderna con música mariachi, diseño profesional y sistema de puntuaciones en línea**

[🎯 Características](#-características) • [🚀 Instalación](#-instalación) • [🎵 Audio](#-experiencia-de-audio) • [🏆 Puntuaciones](#-sistema-de-puntuaciones) • [📱 Capturas](#-capturas)

</div>

## ✨ Características

### 🎮 **Juego Completo**
- 🧩 **Generación automática** de crucigramas con algoritmo de backtracking
- 🎯 **9 categorías** incluidas: Frutas, Animales, Ciudades, Autos, Colores, Países, Deportes, Profesiones, Dark Rippers
- 📱 **Multiplataforma**: Android, iOS, Web, Windows, macOS, Linux
- 🎨 **Diseño moderno** con Material Design 3

### 🎵 **Experiencia de Audio**
- 🎺 **Música mariachi** de fondo durante el juego
- 🎻 **Sonido de violín** al completar puzzles
- ❌ **Sonido de game over** para futuras mecánicas
- 🔊 **Control de audio** integrado

### 🏆 **Sistema de Puntuaciones**
- 📊 **Tabla de posiciones** con diseño espectacular
- 🥇 **Medallas animadas** (oro, plata, bronce)
- 💾 **Almacenamiento en Supabase** (base de datos en la nube)
- 📈 **Sistema avanzado** con bonus de tiempo y rachas

### 🎨 **Diseño Visual**
- 🌈 **Gradientes y animaciones** modernas
- 🏆 **Cards rediseñadas** para completado y leaderboard
- 📱 **Icono personalizado** de la aplicación
- 🖼️ **Splash screen** personalizado
- 🎉 **Efectos visuales** y transiciones suaves

## 🚀 Instalación

### Prerrequisitos
- Flutter SDK 3.9+
- Dart SDK
- Android Studio / VS Code
- Cuenta en [Supabase](https://supabase.com) (opcional)

### Pasos de Instalación

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/pablini31/flutter_crucigrama.git
   cd flutter_crucigrama
   ```

2. **Instala dependencias**
   ```bash
   flutter pub get
   ```

3. **Configura Supabase** (opcional - ver [SUPABASE_SETUP.md](SUPABASE_SETUP.md))
   ```bash
   # Ejecuta los scripts SQL incluidos en tu proyecto Supabase
   # Actualiza las credenciales en lib/services/supabase_service.dart
   ```

4. **Ejecuta la aplicación**
   ```bash
   flutter run
   ```

## 🎵 Experiencia de Audio

| Momento | Sonido | Descripción |
|---------|--------|-------------|
| 🎮 **Durante el juego** | Música mariachi | Loop continuo de música mexicana |
| 🎯 **Al completar** | Violín elegante | Melodía de victoria al terminar |
| ❌ **Game over** | Sonido dramático | Para futuras mecánicas de pérdida |

## 🏆 Sistema de Puntuaciones

### 📊 **Puntuación Básica**
- **1 punto** por cada palabra encontrada
- **Sin límite de tiempo** (juego relajado)
- **Guardado automático** en Supabase

### 🚀 **Sistema Avanzado Disponible**
- **Puntos base**: 10 por palabra
- **Bonus de tiempo**: +5 por segundo restante
- **Multiplicador de racha**: +2 por palabra en rachas de 3+
- **Bonus perfecto**: +100 por completar sin errores
- **Calificaciones**: S+, S, A+, A, B+, B, C+, C, D, F

## 🛠️ Tecnologías

- **🎯 Framework**: Flutter 3.9+
- **💻 Lenguaje**: Dart
- **🗄️ Base de datos**: Supabase
- **🔄 Estado**: Riverpod
- **🎵 Audio**: AudioPlayers
- **🎨 UI**: Material Design 3

## 📁 Estructura del Proyecto

```
lib/
├── 🎯 main.dart                    # Punto de entrada
├── 📊 model.dart                   # Modelos principales
├── 🔄 providers.dart               # Gestión de estado
├── ⚡ isolates.dart                # Generación en paralelo
├── 📁 models/
│   └── 📂 category.dart           # Modelo de categorías
├── 🛠️ services/
│   ├── 🗄️ supabase_service.dart    # Integración BD
│   ├── 🎵 audio_service.dart       # Manejo de audio
│   ├── 📊 scoring_service.dart     # Sistema puntuación
│   └── 🌐 connectivity_service.dart # Conectividad
└── 🎨 widgets/
    ├── 🎮 crossword_puzzle_app.dart      # App principal
    ├── ⚙️ crossword_generator_widget.dart # Generador
    ├── 🧩 crossword_puzzle_widget.dart   # Interfaz juego
    ├── 🎉 puzzle_completed_widget.dart   # Pantalla victoria
    └── 🏆 leaderboard_dialog.dart        # Tabla posiciones
```

## 🎮 Cómo Jugar

1. **🚀 Inicia la app** - Escucha la música mariachi
2. **🎯 Selecciona categoría** - Toca el ícono de categorías
3. **🧩 Encuentra palabras** - Haz clic en las palabras del crucigrama
4. **🎉 Completa el puzzle** - Encuentra todas las palabras
5. **💾 Guarda tu puntuación** - Ingresa tu nombre
6. **🏆 Ve el leaderboard** - Compite con otros jugadores

## 📱 Capturas

> *Próximamente: Capturas de pantalla de la aplicación*

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! 

1. Fork el proyecto
2. Crea tu rama (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Documentación Adicional

- 📋 [SUPABASE_SETUP.md](SUPABASE_SETUP.md) - Configuración de base de datos
- 🎵 [AUDIO_SPLASH_UPDATED.md](AUDIO_SPLASH_UPDATED.md) - Configuración de audio
- 📊 [SISTEMA_PUNTUACION_Y_DISEÑO.md](SISTEMA_PUNTUACION_Y_DISEÑO.md) - Sistema de puntuación
- 👤 [USER_GUIDE.md](USER_GUIDE.md) - Guía de usuario

## 📞 Soporte

¿Problemas o sugerencias?
- 📖 Revisa la documentación incluida
- 🐛 Abre un issue en GitHub
- 📧 Contacta al desarrollador

## 📜 Licencia

Este proyecto está bajo la Licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

---

<div align="center">

**Desarrollado con ❤️ usando Flutter**

🎮 **¡Disfruta jugando crucigramas con música mariachi!** 🇲🇽

</div>