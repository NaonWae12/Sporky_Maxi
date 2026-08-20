import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../colors/colors.dart';

/// A centralized YouTube player component that ensures consistent styling
/// and behavior across the application.
class GlobalYoutubePlayer extends StatelessWidget {
  final YoutubePlayerController controller;
  final double aspectRatio;

  const GlobalYoutubePlayer({
    super.key,
    required this.controller,
    this.aspectRatio = 16 / 9,
  });

  /// The standard progress bar colors used across the app.
  static const ProgressBarColors defaultProgressColors = ProgressBarColors(
    playedColor: AppColors.warn4,
    handleColor: AppColors.warn4,
    bufferedColor: Color(0x66FFFFFF),
    backgroundColor: Color(0x33FFFFFF),
  );

  @override
  Widget build(BuildContext context) {
    return buildPlayer(controller: controller, aspectRatio: aspectRatio);
  }

  /// Builds a [YoutubePlayer] with the standard global styling.
  /// [isPortrait] menentukan apakah tombol fullscreen default digunakan
  /// atau diganti dengan custom portrait fullscreen button.
  static YoutubePlayer buildPlayer({
    required YoutubePlayerController controller,
    double aspectRatio = 16 / 9,
    bool isPortrait = false,
    VoidCallback? onPortraitFullScreenToggle,
  }) {
    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      progressColors: defaultProgressColors,
      aspectRatio: aspectRatio,
      bottomActions: [
        const SizedBox(width: 8),
        const CurrentPosition(),
        const SizedBox(width: 8),
        Expanded(
          child: ProgressBar(
            isExpanded: true,
            colors: defaultProgressColors,
          ),
        ),
        const RemainingDuration(),
        const SizedBox(width: 8),
        if (isPortrait && onPortraitFullScreenToggle != null)
          _PortraitFullScreenButton(onPressed: onPortraitFullScreenToggle)
        else
          const FullScreenButton(),
      ],
    );
  }

  // === Static Utilities ===

  /// Extracts the YouTube video ID from various URL formats.
  static String? extractId(String? url) {
    final normalizedUrl = normalizeInput(url);
    if (normalizedUrl == null || normalizedUrl.isEmpty) return null;

    // Direct ID check
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(normalizedUrl)) {
      return normalizedUrl;
    }

    // Try YouTube package conversion
    final converted = sanitizeId(YoutubePlayer.convertUrlToId(
      normalizedUrl,
      trimWhitespaces: true,
    ));
    if (converted != null) return converted;

    // Try manual URI parsing
    final fromUri = extractFromUri(normalizedUrl);
    if (fromUri != null) return fromUri;

    // Regex fallback for complex URLs
    final knownMatch = RegExp(
      r'(?:youtube(?:-nocookie)?\\.com/(?:embed/|shorts/|live/|v/|watch\\?.*v=)|youtu\\.be/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    ).firstMatch(normalizedUrl);
    
    return sanitizeId(knownMatch?.group(1));
  }

  /// Normalizes a raw URL input by removing common artifacts.
  static String? normalizeInput(String? rawUrl) {
    var normalizedUrl = rawUrl?.trim();
    if (normalizedUrl == null || normalizedUrl.isEmpty) return null;

    normalizedUrl = normalizedUrl
        .replaceAll('\\/', '/')
        .replaceAll('\\u0026', '&')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'''^["']|["']$'''), '');

    final iframeSrcMatch =
        RegExp(r'''src=['"]([^'"]+)['"]''', caseSensitive: false)
            .firstMatch(normalizedUrl);
    if (iframeSrcMatch != null) {
      normalizedUrl = iframeSrcMatch.group(1)?.trim();
    }

    if (normalizedUrl == null || normalizedUrl.isEmpty) return null;

    return normalizedUrl.replaceAll('&amp;', '&');
  }

  /// Extracts video ID from a parsed URI.
  static String? extractFromUri(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();

      if (host.contains('youtu.be')) {
        if (uri.pathSegments.isNotEmpty) {
          return sanitizeId(uri.pathSegments.first);
        }
      }

      if (host.contains('youtube.com') || host.contains('youtube-nocookie.com')) {
        final queryId = sanitizeId(uri.queryParameters['v']);
        if (queryId != null) return queryId;

        if (uri.pathSegments.length >= 2) {
          final firstSegment = uri.pathSegments.first.toLowerCase();
          if (['embed', 'shorts', 'live', 'v'].contains(firstSegment)) {
            return sanitizeId(uri.pathSegments[1]);
          }
        }
      }
    } catch (_) {}
    return null;
  }

  /// Validates and cleans a potential video ID string.
  static String? sanitizeId(String? candidate) {
    final cleaned = candidate?.trim();
    if (cleaned == null || cleaned.isEmpty) return null;
    return RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(cleaned) ? cleaned : null;
  }
}

/// Custom fullscreen button untuk video portrait.
/// Ini TIDAK memanggil controller.toggleFullScreenMode() yang hardcode landscape.
class _PortraitFullScreenButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PortraitFullScreenButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.fullscreen, color: Colors.white),
      onPressed: onPressed,
    );
  }
}

/// A wrapper that handles the [YoutubePlayerBuilder] + [Scaffold] pattern.
/// Use this in your page's build method to enable proper full-screen support.
///
/// Untuk video portrait (aspectRatio < 1.0), widget ini BYPASS YoutubePlayerBuilder
/// karena paket tersebut hardcode fullscreen = landscape dan akan selalu gagal
/// jika orientasi dibiarkan portrait.
class GlobalYoutubeScaffold extends StatefulWidget {
  final YoutubePlayerController? controller;
  final double aspectRatio;
  final Widget Function(BuildContext context, Widget playerWidget) builder;

  const GlobalYoutubeScaffold({
    super.key,
    this.controller,
    this.aspectRatio = 16 / 9,
    required this.builder,
  });

  @override
  State<GlobalYoutubeScaffold> createState() => _GlobalYoutubeScaffoldState();
}

class _GlobalYoutubeScaffoldState extends State<GlobalYoutubeScaffold> {
  bool _isPortraitFullScreen = false;

  bool get _isPortraitVideo => widget.aspectRatio < 1.0;

  void _togglePortraitFullScreen() {
    setState(() {
      _isPortraitFullScreen = !_isPortraitFullScreen;
    });

    if (_isPortraitFullScreen) {
      // Sembunyikan system UI saja, JANGAN ganti orientasi
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // Tampilkan kembali system UI
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null) {
      return widget.builder(context, const SizedBox.shrink());
    }

    // === VIDEO PORTRAIT: Bypass YoutubePlayerBuilder ===
    if (_isPortraitVideo) {
      return _buildPortraitLayout();
    }

    // === VIDEO LANDSCAPE: Gunakan YoutubePlayerBuilder bawaan ===
    return YoutubePlayerBuilder(
      player: GlobalYoutubePlayer.buildPlayer(
        controller: widget.controller!,
        aspectRatio: widget.aspectRatio,
      ),
      builder: widget.builder,
    );
  }

  Widget _buildPortraitLayout() {
    final player = YoutubePlayer(
      controller: widget.controller!,
      showVideoProgressIndicator: true,
      progressColors: GlobalYoutubePlayer.defaultProgressColors,
      aspectRatio: widget.aspectRatio,
      bottomActions: [
        const SizedBox(width: 8),
        const CurrentPosition(),
        const SizedBox(width: 8),
        Expanded(
          child: ProgressBar(
            isExpanded: true,
            colors: GlobalYoutubePlayer.defaultProgressColors,
          ),
        ),
        const RemainingDuration(),
        const SizedBox(width: 8),
        _PortraitFullScreenButton(onPressed: _togglePortraitFullScreen),
      ],
    );

    // Saat fullscreen portrait: tampilkan player saja tanpa konten lain
    if (_isPortraitFullScreen) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            _togglePortraitFullScreen();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: player,
          ),
        ),
      );
    }

    // Saat normal: bungkus dalam builder biasa
    return widget.builder(context, player);
  }
}
