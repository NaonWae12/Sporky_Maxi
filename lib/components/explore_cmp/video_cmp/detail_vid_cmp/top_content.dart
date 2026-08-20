import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../globals/video/global_youtube_player.dart';

import '../../../globals/card/globals_card.dart';
import '../../../globals/card/globals_card_outlined.dart';

class TopContent extends StatefulWidget {
  final String? imageAsset;
  final String? youtubeLink;
  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final VoidCallback? onTap;
  final int views;
  final int likes;
  final List<String> categories;
  final YoutubePlayerController? externalController;
  final Widget? externalPlayer;
  final double? aspectRatio;

  const TopContent({
    super.key,
    this.imageAsset,
    this.youtubeLink,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
    this.onTap,
    required this.views,
    required this.likes,
    required this.categories,
    this.externalController,
    this.externalPlayer,
    this.aspectRatio,
    this.onPlay,
  });

  final VoidCallback? onPlay;

  @override
  State<TopContent> createState() => _TopContentState();
}

class _TopContentState extends State<TopContent> {
  YoutubePlayerController? _youtubeController;
  String? _currentVideoId;
  bool _showPlayer = false;

  @override
  void initState() {
    super.initState();
    _extractVideoId();
  }

  @override
  void didUpdateWidget(covariant TopContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.youtubeLink != widget.youtubeLink) {
      _youtubeController?.dispose();
      _youtubeController = null;
      _showPlayer = false;
      _extractVideoId();
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  /// Hanya extract video ID, TIDAK buat controller.
  /// Controller dibuat lazy saat user tap play.
  void _extractVideoId() {
    final videoId = GlobalYoutubePlayer.extractId(widget.youtubeLink);
    if (kDebugMode) {
      debugPrint(
          '[TopContent] youtubeLink="${widget.youtubeLink}" videoId="$videoId"');
    }
    _currentVideoId = videoId;
  }

  /// Buat controller dan mulai play — dipanggil saat user tap thumbnail.
  void _startPlayer() {
    if (widget.onPlay != null) {
      widget.onPlay!();
      return;
    }
    if (_currentVideoId == null) return;
    _youtubeController = YoutubePlayerController(
      initialVideoId: _currentVideoId!,
      flags: const YoutubePlayerFlags(
        controlsVisibleAtStart: true,
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        useHybridComposition: true,
      ),
    );
    setState(() {
      _showPlayer = true;
    });
  }

  Future<void> _launchYouTube(String? url) async {
    final webUrl = _buildPlayableYoutubeUrl(url);
    if (webUrl == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link video YouTube tidak valid')),
        );
      }
      return;
    }

    try {
      if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(
          Uri.parse(webUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (await canLaunchUrl(Uri.parse(webUrl))) {
          await launchUrl(Uri.parse(webUrl));
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tidak bisa membuka YouTube')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error membuka video')),
        );
      }
    }
  }

  String? _extractYoutubeVideoId(String? url) =>
      GlobalYoutubePlayer.extractId(url);

  String? _normalizeYoutubeInput(String? rawUrl) =>
      GlobalYoutubePlayer.normalizeInput(rawUrl);

  String? _buildPlayableYoutubeUrl(String? url) {
    final videoId = _extractYoutubeVideoId(url);
    if (videoId != null && videoId.isNotEmpty) {
      return 'https://www.youtube.com/watch?v=$videoId';
    }

    final normalized = _normalizeYoutubeInput(url);
    if (normalized == null) {
      return null;
    }

    final uri = Uri.tryParse(normalized);
    final host = uri?.host.toLowerCase() ?? '';
    if (host.contains('youtube.com') ||
        host.contains('youtu.be') ||
        host.contains('youtube-nocookie.com')) {
      return normalized;
    }

    return null;
  }

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  Widget _buildVideoThumbnail() {
    return GestureDetector(
      onTap: () => _launchYouTube(widget.youtubeLink),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.warn1.withValues(alpha: 0.8),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Thumbnail lazy-load: tampil sebelum player di-init.
  /// Pakai YouTube thumbnail dari video ID supaya preview akurat.
  Widget _buildLazyThumbnail() {
    final effectiveAspectRatio = widget.aspectRatio ??
        (widget.youtubeLink?.contains('/shorts/') == true ? 9 / 16 : 16 / 9);

    final thumbnailUrl = _currentVideoId != null
        ? 'https://img.youtube.com/vi/$_currentVideoId/hqdefault.jpg'
        : null;

    return GestureDetector(
      onTap: _startPlayer,
      child: AspectRatio(
        aspectRatio: effectiveAspectRatio,
        child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (thumbnailUrl != null)
                Positioned.fill(
                  child: Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.black),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warn1.withValues(alpha: 0.8),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoWrapper(Widget playerWidget) {
    // Inline wrapper selalu 16:9 (Landscape frame) sesuai request
    const inlineAspectRatio = 16 / 9;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: inlineAspectRatio,
            child: playerWidget,
          ),
          // "Topeng" pojokan buat simulasi rounded corners tanpa clipping
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _CornerMaskPainter(
                  color: AppColors.base4, // Samakan dengan background halaman
                  radius: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final imagePath = widget.imageAsset?.trim();

    if (imagePath == null || imagePath.isEmpty) {
      return _placeholderCover();
    }

    if (_isNetworkImage(imagePath)) {
      return Image.network(
        imagePath,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (_, __, ___) => _placeholderCover(),
      );
    }

    return Image.asset(
      imagePath,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholderCover(),
    );
  }

  Widget _placeholderCover() {
    return Container(
      height: 180,
      width: double.infinity,
      color: AppColors.base3,
      child: const Icon(Icons.broken_image, size: 48, color: AppColors.base2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveAspectRatio = widget.aspectRatio ??
        (widget.youtubeLink?.contains('/shorts/') == true ? 9 / 16 : 16 / 9);

    Widget videoWidget;

    if (widget.externalPlayer != null) {
      // Case 1: External player widget Provided by parent (GlobalYoutubeScaffold)
      videoWidget = widget.externalPlayer!;
    } else if (widget.externalController != null) {
      // Case 2: External controller provided by parent
      videoWidget = GlobalYoutubePlayer(
        controller: widget.externalController!,
        aspectRatio: effectiveAspectRatio,
      );
    } else if (_currentVideoId == null) {
      // Case 3: No valid video ID
      videoWidget = _buildVideoThumbnail();
    } else if (!_showPlayer || _youtubeController == null) {
      // Case 4: Lazy loading (Thumbnail first)
      videoWidget = _buildLazyThumbnail();
    } else {
      // Case 5: Lazy loading (Player active)
      videoWidget = GlobalYoutubePlayer(
        controller: _youtubeController!,
        aspectRatio: effectiveAspectRatio,
      );
    }

    return _buildMainLayout(context, videoWidget);
  }

  Widget _buildMainLayout(BuildContext context, Widget videoWidget) {
    final categories =
        widget.categories.isNotEmpty ? widget.categories : ['Video'];

    final subtitle = widget.subtitle.trim().isEmpty
        ? 'Sporky & Maxi'
        : widget.subtitle.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildVideoWrapper(videoWidget),
        ),
        GlobalsCard(
          backgroundColor: AppColors.base4,
          hasShadow: false,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: categories
                          .map((cat) => GlobalsCardOutlined(
                                text: cat,
                                textStyle: AppTextStyles.lable4SemiRegular(
                                    AppColors.primary1),
                                backgroundColor: AppColors.base5,
                                borderColor: AppColors.primary1,
                                textColor: AppColors.primary1,
                                height: 16,
                              ))
                          .toList(),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.remove_red_eye_outlined,
                            size: 13, color: AppColors.base1),
                        const SizedBox(width: 4),
                        Text('${widget.views} views',
                            style: AppTextStyles.list3Regular(AppColors.base1)),
                        const SizedBox(width: 5),
                        const Icon(Icons.favorite,
                            size: 13, color: AppColors.warn1),
                        const SizedBox(width: 4),
                        Text('${widget.likes} likes',
                            style: AppTextStyles.list3Regular(AppColors.base1)),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTextStyles.headList1Bold(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const _FavoriteButton()
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.base5,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.base2),
                        image: const DecorationImage(
                          image: AssetImage('assets/logo_dummy.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      subtitle,
                      style: AppTextStyles.list1SemiBold(),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  widget.description,
                  style: AppTextStyles.list1Regular(),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Favorite button yang di-isolasi ke widget sendiri.
/// setState di sini TIDAK akan rebuild TopContent (dan YoutubePlayer-nya).
class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton();

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isFavorited = !_isFavorited;
        });
      },
      icon: Icon(
        _isFavorited ? Icons.favorite : Icons.favorite_border,
        color: AppColors.warn1,
      ),
    );
  }
}

/// Painter khusus buat bikin topeng di pojokan video
/// Ini jauh lebih enteng daripada ClipRRect buat native PlatformView
class _CornerMaskPainter extends CustomPainter {
  final Color color;
  final double radius;

  _CornerMaskPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(radius, 0)
        ..arcToPoint(Offset(0, radius),
            radius: Radius.circular(radius), clockwise: false)
        ..close(),
      paint,
    );

    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width, 0)
        ..lineTo(size.width - radius, 0)
        ..arcToPoint(Offset(size.width, radius),
            radius: Radius.circular(radius), clockwise: true)
        ..close(),
      paint,
    );

    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height)
        ..lineTo(radius, size.height)
        ..arcToPoint(Offset(0, size.height - radius),
            radius: Radius.circular(radius), clockwise: true)
        ..close(),
      paint,
    );

    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width, size.height)
        ..lineTo(size.width - radius, size.height)
        ..arcToPoint(Offset(size.width, size.height - radius),
            radius: Radius.circular(radius), clockwise: false)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerMaskPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
