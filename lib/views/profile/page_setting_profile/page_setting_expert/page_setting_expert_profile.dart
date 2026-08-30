import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sporky_maxi/components/expert_components/profile/edit_profile/edit_profile_cmp.dart'
    as expert_profile;
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/dialog/sporky_dialog.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

import '../../../../core/services/auth/auth_service.dart';
import '../../../../core/services/profile/profile_service.dart';
import '../../../../models/components/profile/profile_models.dart';
import '../../../initial_display/login_page.dart';
import 'page_personal_info_expert.dart';

class PageSettingExpertProfile extends StatefulWidget {
  const PageSettingExpertProfile({super.key});

  @override
  State<PageSettingExpertProfile> createState() =>
      _PageSettingExpertProfileState();
}

class _PageSettingExpertProfileState extends State<PageSettingExpertProfile> {
  static const ProfileService _profileService = ProfileService();

  ExpertProfile? _profile;
  XFile? _selectedPhoto;
  bool _isLoadingProfile = true;
  bool _isSavingPhoto = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoadingProfile = true;
    });

    try {
      final profile = await _profileService.getExpertAccountProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _selectedPhoto = null;
        _isLoadingProfile = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoadingProfile = false;
      });
      _showMessage('Gagal memuat profil expert: $error');
    }
  }

  Future<void> _pickAndSavePhoto() async {
    if (_isSavingPhoto) return;

    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null || !mounted) return;
    setState(() {
      _selectedPhoto = picked;
      _isSavingPhoto = true;
    });

    try {
      final profile = await _profileService.updateExpertAccountProfile(
        photoPath: picked.path,
      );
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _selectedPhoto = null;
      });
      _showMessage('Foto profil berhasil disimpan');
    } catch (error) {
      _showMessage('Gagal menyimpan foto: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSavingPhoto = false;
        });
      }
    }
  }

  void _showUnavailable(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Fitur ini belum tersedia')));
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => SporkyDialog(
        title: 'Keluar',
        message: 'Yakin ingin keluar dari akun ini?',
        actions: [
          SporkyDialogAction(
            label: 'Batal',
            onPressed: () => Navigator.pop(dialogContext),
          ),
          SporkyDialogAction(
            label: 'Keluar',
            onPressed: () async {
              Navigator.pop(dialogContext);
              await AuthService.logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            isPrimary: true,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
            Text('Pengaturan Akun', style: AppTextStyles.heading2SemiBold()),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                expert_profile.EditProfileCmp(
                  isAsset: false,
                  photoUrl: _profile?.photo,
                  localPhotoPath: _selectedPhoto?.path,
                  onTap: _pickAndSavePhoto,
                ),
                if (_isLoadingProfile || _isSavingPhoto)
                  const SizedBox(
                    height: 34,
                    width: 34,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
              ],
            ),
          ),
          Card(text: 'Keamanan Akun', onTap: () => _showUnavailable(context)),
          Card(
            text: 'Informasi Pribadi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PagePersonalInfoExpert(),
                ),
              ).then((_) => _loadProfile());
            },
          ),
          Card(
            text: 'Pengalaman Profesional',
            onTap: () => _showUnavailable(context),
          ),
          Card(
            text: 'Informasi Rekening Bank',
            onTap: () => _showUnavailable(context),
          ),
          Card(
            onTap: () => _confirmLogout(context),
            child: Row(
              children: [
                SvgPicture.asset('assets/svg/logout.svg'),
                Text('Keluar', style: AppTextStyles.list1Regular()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Card extends StatelessWidget {
  final String? text;
  final VoidCallback onTap;
  final Widget? child;

  const Card({super.key, this.text, required this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      backgroundColor: AppColors.base4,
      hasShadow: false,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      child:
          child ??
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text ?? '', style: AppTextStyles.headList1Regular()),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
    );
  }
}
