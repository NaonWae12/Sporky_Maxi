import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/components/profile_content/cmp_setting_profile/cmp_form_setting_profile.dart';
import 'package:sporky_maxi/core/services/profile/profile_service.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';
import 'package:sporky_maxi/models/components/profile/profile_models.dart';

class FormSettingChildProfile extends StatefulWidget {
  const FormSettingChildProfile({super.key});

  @override
  State<FormSettingChildProfile> createState() =>
      _FormSettingChildProfileState();
}

class _FormSettingChildProfileState extends State<FormSettingChildProfile> {
  static const ProfileService _profileService = ProfileService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _medicalHistoryController =
      TextEditingController();
  final TextEditingController _allergyController = TextEditingController();
  final TextEditingController _favoriteFoodController = TextEditingController();
  final TextEditingController _avoidedFoodController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  ChildProfile? _child;

  @override
  void initState() {
    super.initState();
    _loadChild();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _medicalHistoryController.dispose();
    _allergyController.dispose();
    _favoriteFoodController.dispose();
    _avoidedFoodController.dispose();
    super.dispose();
  }

  Future<void> _loadChild() async {
    final childUuid = (await SecureStorageService.getSelectedChildUuid() ?? '')
        .trim();

    if (childUuid.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _showMessage('Profil anak belum dipilih');
      return;
    }

    try {
      final child = await _profileService.getChildProfile(childUuid);
      if (!mounted) return;

      setState(() {
        _child = child;
        _nameController.text = child.name;
        _dobController.text = _formatDob(child.dob);
        _medicalHistoryController.text = child.medicalHistories.join(', ');
        _allergyController.text = child.allergies.join(', ');
        _favoriteFoodController.text = child.favoriteFoods.join(', ');
        _avoidedFoodController.text = child.foodsAvoided.join(', ');
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showMessage('Gagal memuat profil anak: $error');
    }
  }

  Future<void> _saveChild() async {
    if (_isSaving) return;

    final childUuid = _child?.uuid.trim() ?? '';
    if (childUuid.isEmpty) {
      _showMessage('Profil anak belum dipilih');
      return;
    }

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Nama anak wajib diisi');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final child = await _profileService.updateChildProfile(
        childUuid,
        name: name,
        gender: _child?.gender ?? 'P',
        dob: _child?.dob ?? '',
        medicalHistories: _splitList(_medicalHistoryController.text),
        allergies: _splitList(_allergyController.text),
        favoriteFoods: _splitList(_favoriteFoodController.text),
        foodsAvoided: _splitList(_avoidedFoodController.text),
      );

      if (!mounted) return;
      setState(() {
        _child = child;
        _dobController.text = _formatDob(child.dob);
      });
      _showMessage('Profil anak berhasil disimpan');
    } catch (error) {
      _showMessage('Gagal menyimpan profil anak: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  List<String> _splitList(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  String _formatDob(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
          CmpFormSettingProfile(
            controller: _nameController,
            lable: 'Nama Anak*',
            keyboardType: TextInputType.text,
          ),
          CmpFormSettingProfile(
            controller: _dobController,
            lable: 'Tanggal Lahir*',
            keyboardType: TextInputType.datetime,
          ),
          CmpFormSettingProfile(
            controller: _medicalHistoryController,
            lable: 'Riwayat Penyakit',
            keyboardType: TextInputType.text,
          ),
          CmpFormSettingProfile(
            controller: _allergyController,
            lable: 'Alergi',
            keyboardType: TextInputType.text,
          ),
          CmpFormSettingProfile(
            controller: _favoriteFoodController,
            lable: 'Makanan Favorit',
            keyboardType: TextInputType.text,
          ),
          CmpFormSettingProfile(
            controller: _avoidedFoodController,
            lable: 'Makanan yang Dihindari',
            keyboardType: TextInputType.text,
          ),
          GlobalsCard(
            height: 44,
            margin: const EdgeInsets.symmetric(vertical: 4),
            hasShadow: false,
            backgroundColor: AppColors.base3,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            onTap: () =>
                _showMessage('Referral: ${_child?.referralCode ?? '-'}'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kode Referal', style: AppTextStyles.headList1Regular()),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 9.0, bottom: 15),
            child: GlobalsButton(
              radius: 16,
              elevation: 0,
              onPressed: _isSaving ? null : _saveChild,
              text: _isSaving ? 'Menyimpan...' : 'Simpan',
              color: AppColors.secondary1,
            ),
          ),
        ],
      ),
    );
  }
}
