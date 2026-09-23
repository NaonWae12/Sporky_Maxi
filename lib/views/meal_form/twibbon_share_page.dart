import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../components/globals/button/globals_button.dart';
import '../../components/globals/card/cmp_tag_attention.dart';
import '../../components/globals/colors/colors.dart';
import '../../components/globals/text/text_style.dart';

class TwibbonSharePage extends StatefulWidget {
  const TwibbonSharePage({super.key});

  @override
  State<TwibbonSharePage> createState() => _TwibbonSharePageState();
}

class _TwibbonSharePageState extends State<TwibbonSharePage> {
  static const MethodChannel _shareChannel = MethodChannel(
    'sporky_maxi/share_moment',
  );
  static const String _shareTitle = 'Momen Makan Si Kecil';
  static const String _shareText = 'Momen makan si kecil dari Sporky Maxi.';

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _isPickingImage = false;
  bool _isSharing = false;

  Future<void> _pickImage() async {
    if (_isPickingImage || _isSharing) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 2048,
        maxHeight: 2048,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;

      setState(() {
        _selectedImage = image;
        _selectedImageBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto belum dapat dibuka. Silakan coba lagi.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Future<void> _shareMoment() async {
    final image = _selectedImage;
    if (image == null || _isSharing) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) {
        void selectTarget(String target) {
          Navigator.pop(sheetContext);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _shareToTarget(image, target);
          });
        }

        return SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
            decoration: const BoxDecoration(
              color: AppColors.base5,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 82,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.primary2,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Bagikan Momen',
                  style: AppTextStyles.heading3SemiBold(AppColors.primary1),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _ShareDestinationButton(
                        label: 'WhatsApp',
                        icon: Icons.chat_bubble_outline,
                        iconColor: const Color(0xFF25D366),
                        onTap: () => selectTarget('whatsapp'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ShareDestinationButton(
                        label: 'Instagram',
                        icon: Icons.camera_alt_outlined,
                        iconColor: const Color(0xFFE1306C),
                        onTap: () => selectTarget('instagram'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ShareDestinationButton(
                        label: 'Simpan ke Galeri',
                        icon: Icons.file_download_outlined,
                        iconColor: AppColors.primary1,
                        onTap: () => selectTarget('save_gallery'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareToTarget(XFile image, String target) async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      if (target == 'save_gallery') {
        await _saveImageToGallery(image);
        if (!mounted) return;
        _showSnackBar('Foto berhasil disimpan ke galeri.');
        return;
      }

      await _shareChannel.invokeMethod<void>('shareImage', {
        'path': image.path,
        'target': target,
        'title': _shareTitle,
        'text': _shareText,
      });
    } on MissingPluginException {
      await _shareWithSystemFallback(image);
    } on PlatformException catch (error) {
      if (!mounted) return;
      _showSnackBar(_platformErrorMessage(error));
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Momen belum berhasil dibagikan. Silakan coba lagi.');
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _saveImageToGallery(XFile image) async {
    await _shareChannel.invokeMethod<void>('saveToGallery', {
      'path': image.path,
    });
  }

  Future<void> _shareWithSystemFallback(XFile image) async {
    final result = await SharePlus.instance.share(
      ShareParams(title: _shareTitle, text: _shareText, files: [image]),
    );
    if (result.status == ShareResultStatus.unavailable) {
      throw PlatformException(code: 'SHARE_UNAVAILABLE');
    }
  }

  String _platformErrorMessage(PlatformException error) {
    if (error.code == 'APP_NOT_FOUND') {
      return 'Aplikasi belum tersedia di perangkat ini.';
    }
    if (error.code == 'SAVE_FAILED') {
      return 'Foto belum berhasil disimpan. Silakan coba lagi.';
    }
    return 'Momen belum berhasil dibagikan. Silakan coba lagi.';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _selectedImageBytes != null;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.sizeOf(context).width,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Kembali',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text('Twibbon', style: AppTextStyles.heading2SemiBold()),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CmpTagAttention(
                    padding: EdgeInsets.zero,
                    imageAsset: 'assets/svg/ic_warn.svg',
                    imageColor: AppColors.info1,
                    lineColor: AppColors.info1,
                    maxLines: 4,
                    child: Text(
                      'Pilih foto momen makan si kecil untuk dibagikan ke keluarga atau media sosial.',
                      style: AppTextStyles.list1Regular(AppColors.base1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    button: true,
                    label: hasImage
                        ? 'Ganti foto momen makan'
                        : 'Pilih foto momen makan dari galeri',
                    child: Material(
                      color: AppColors.base4,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _isPickingImage ? null : _pickImage,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: hasImage
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.memory(
                                      _selectedImageBytes!,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      right: 12,
                                      bottom: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary1,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.photo_library_outlined,
                                              size: 18,
                                              color: AppColors.base5,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Ganti Foto',
                                              style:
                                                  AppTextStyles.list1SemiBold(
                                                    AppColors.base5,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: _isPickingImage
                                      ? const CircularProgressIndicator(
                                          color: AppColors.primary1,
                                        )
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.photo_camera_outlined,
                                              size: 38,
                                              color: AppColors.primary1,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Buka Galeri',
                                              style:
                                                  AppTextStyles.heading3SemiBold(
                                                    AppColors.secondary1,
                                                  ),
                                            ),
                                          ],
                                        ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: GlobalsButton(
          color: hasImage ? AppColors.primary1 : AppColors.base3,
          textColor: AppColors.secondary1,
          elevation: 0,
          onPressed: hasImage && !_isSharing ? _shareMoment : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSharing)
                const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.secondary1,
                  ),
                )
              else
                SvgPicture.asset(
                  'assets/svg/ic_share.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.secondary1,
                    BlendMode.srcIn,
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                _isSharing ? 'Memproses Momen' : 'Bagikan Momen',
                style: AppTextStyles.heading3SemiBold(AppColors.secondary1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareDestinationButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _ShareDestinationButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.base5,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 34, color: iconColor),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.list3Regular(AppColors.base1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
