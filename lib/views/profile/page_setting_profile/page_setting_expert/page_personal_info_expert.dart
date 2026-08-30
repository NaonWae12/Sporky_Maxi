import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/expert_components/profile/child_data_cmp/biodata_cmp.dart';
import 'package:sporky_maxi/core/services/profile/profile_service.dart';
import 'package:sporky_maxi/models/components/profile/profile_models.dart';

class PagePersonalInfoExpert extends StatefulWidget {
  const PagePersonalInfoExpert({super.key});

  @override
  State<PagePersonalInfoExpert> createState() => _PagePersonalInfoExpertState();
}

class _PagePersonalInfoExpertState extends State<PagePersonalInfoExpert> {
  static const ProfileService _profileService = ProfileService();

  bool _isEditing = false;
  bool _isLoading = true;
  bool _isSaving = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _educationController = TextEditingController();

  ExpertProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await _profileService.getExpertAccountProfile();
      if (!mounted) return;

      setState(() {
        _profile = profile;
        _nameController.text = profile.name;
        _phoneController.text = profile.phoneNumber;
        _specializationController.text = profile.specialization;
        _educationController.text = profile.education;
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
      _showMessage('Nama lengkap wajib diisi');
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
      await _profileService.updateExpertProfile(
        specialization: _specializationController.text,
        experienceYears: _profile?.experienceYears,
        availableDays: _profile?.availableDays,
        availableTimeStart: _profile?.availableTimeStart,
        availableTimeEnd: _profile?.availableTimeEnd,
      );
      final profile = await _profileService.updateExpertAccountProfile(
        name: name,
        phoneNumber: phone,
      );

      if (!mounted) return;
      setState(() {
        _profile = profile;
        _nameController.text = profile.name;
        _phoneController.text = profile.phoneNumber;
        _specializationController.text = profile.specialization;
        _educationController.text = profile.education;
        _isEditing = false;
      });
      _showMessage('Profil expert berhasil disimpan');
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Informasi Pribadi',
          style: AppTextStyles.heading2SemiBold(AppColors.base1),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  _buildField(
                    'Nama Lengkap*',
                    _nameController,
                    isEditable: _isEditing,
                  ),
                  _buildField(
                    'No. Hp / WhatsApp*',
                    _phoneController,
                    isEditable: _isEditing,
                  ),
                  _buildField(
                    'Bidang Keahlian*',
                    _specializationController,
                    isEditable: _isEditing,
                  ),
                  _buildField(
                    'Pendidikan Terakhir*',
                    _educationController,
                    isEditable: _isEditing,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _isLoading
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GlobalsButton(
                text: _isEditing
                    ? (_isSaving ? 'Menyimpan...' : 'Simpan Data')
                    : 'Edit Data',
                color: _isEditing ? AppColors.primary1 : AppColors.secondary1,
                textColor: AppColors.base5,
                onPressed: _isSaving
                    ? null
                    : () {
                        if (_isEditing) {
                          _saveProfile();
                        } else {
                          setState(() {
                            _isEditing = true;
                          });
                        }
                      },
              ),
            ),
    );
  }

  Widget _buildField(
    String title,
    TextEditingController controller, {
    bool isEditable = false,
    bool showIcon = false,
    EdgeInsetsGeometry? margin,
  }) {
    if (!isEditable) {
      return CardComponents1(
        title: title,
        desc: controller.text,
        showIcon: showIcon,
        margin:
            margin ??
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      );
    }

    return Container(
      margin:
          margin ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.base4,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.list3SemiBold(AppColors.base2)),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: AppTextStyles.headList1Regular(AppColors.base1),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
              if (showIcon)
                const Icon(
                  Icons.calendar_month,
                  color: AppColors.primary1,
                  size: 20,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
