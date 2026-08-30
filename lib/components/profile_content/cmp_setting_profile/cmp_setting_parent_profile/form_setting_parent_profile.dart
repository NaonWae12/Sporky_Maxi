import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/profile_content/cmp_setting_profile/cmp_changes_photo_profile.dart';
import 'package:sporky_maxi/components/profile_content/cmp_setting_profile/cmp_form_setting_profile.dart';
import 'package:sporky_maxi/core/services/auth/auth_service.dart';
import 'package:sporky_maxi/core/services/profile/profile_service.dart';
import 'package:sporky_maxi/models/components/profile/profile_models.dart';
import 'package:sporky_maxi/views/initial_display/login_page.dart';

class FormSettingParentProfile extends StatefulWidget {
  const FormSettingParentProfile({super.key});

  @override
  State<FormSettingParentProfile> createState() =>
      _FormSettingParentProfileState();
}

class _FormSettingParentProfileState extends State<FormSettingParentProfile> {
  static const ProfileService _profileService = ProfileService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  XFile? _selectedPhoto;
  ParentProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await _profileService.getParentProfile();
      if (!mounted) return;

      setState(() {
        _profile = profile;
        _nameController.text = profile.name;
        _emailController.text = profile.email;
        _phoneController.text = profile.phoneNumber;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showMessage('Gagal memuat profil: $error');
    }
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty) {
      _showMessage('Nama wajib diisi');
      return;
    }
    if (phone.isEmpty) {
      _showMessage('Nomor HP/WhatsApp wajib diisi');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final profile = await _profileService.updateParentProfile(
        name: name,
        gender: _profile?.gender,
        dob: _profile?.dob,
        phoneNumber: phone,
        photoPath: _selectedPhoto?.path,
      );

      if (!mounted) return;
      setState(() {
        _profile = profile;
        _nameController.text = profile.name;
        _phoneController.text = profile.phoneNumber;
        _selectedPhoto = null;
      });
      _showMessage('Profil berhasil disimpan');
    } catch (error) {
      _showMessage('Gagal menyimpan profil: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null || !mounted) return;
    setState(() {
      _selectedPhoto = picked;
    });
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
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
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          CmpChangesPhotoProfile(
            photoUrl: _profile?.avatar,
            localPhotoPath: _selectedPhoto?.path,
            onTap: _pickPhoto,
          ),
          CmpFormSettingProfile(
            controller: _nameController,
            lable: 'Nama Lengkap*',
            keyboardType: TextInputType.name,
          ),
          CmpFormSettingProfile(
            controller: _emailController,
            lable: 'Email*',
            keyboardType: TextInputType.emailAddress,
          ),
          CmpFormSettingProfile(
            controller: _phoneController,
            lable: 'No. Hp/Whatsapp*',
            keyboardType: TextInputType.phone,
          ),
          _SettingRow(
            label: 'Ganti Kata Sandi',
            onTap: () => _showMessage(
              'Ganti kata sandi melalui lupa password di halaman login',
            ),
          ),
          _SettingRow(label: 'Keluar', onTap: _logout),
          _SettingRow(
            label: 'Hapus Akun',
            onTap: () => _showMessage('Fitur hapus akun belum tersedia'),
          ),
          const SizedBox(height: 8),
          GlobalsButton(
            radius: 16,
            elevation: 0,
            onPressed: _isSaving ? null : _saveProfile,
            text: _isSaving ? 'Menyimpan...' : 'Simpan',
            color: AppColors.secondary1,
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SettingRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlobalsCard(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 4),
      hasShadow: false,
      backgroundColor: AppColors.base3,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.headList1Regular()),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
