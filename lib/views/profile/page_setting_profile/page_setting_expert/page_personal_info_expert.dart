import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
// import '../../../child_profile/biodata_in_expert.dart';
import '../../../../components/expert_components/profile/child_data_cmp/biodata_cmp.dart';
import '../../../../core/services/expert/expert_service.dart';

class PagePersonalInfoExpert extends StatefulWidget {
  const PagePersonalInfoExpert({super.key});

  @override
  State<PagePersonalInfoExpert> createState() => _PagePersonalInfoExpertState();
}

class _PagePersonalInfoExpertState extends State<PagePersonalInfoExpert> {
  bool _isEditing = false;
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _placeOfBirthController =
      TextEditingController(text: 'Kota Bandung [Hdd]');
  final TextEditingController _dobController =
      TextEditingController(text: '14/06/1998 [Hdd]');
  final TextEditingController _genderController =
      TextEditingController(text: 'Laki - Laki [Hardcoded]');
  final TextEditingController _expertiseController =
      TextEditingController(text: 'Ahli Gizi [Hardcoded]');
  final TextEditingController _educationController =
      TextEditingController(text: 'Spesialis Gizi [Hardcoded]');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    debugPrint('[PagePersonalInfoExpert] Memulai pengambilan data...');
    try {
      final expertData = await ExpertService().getProfileMe();
      debugPrint('[PagePersonalInfoExpert] Data berhasil didapat: $expertData');
      setState(() {
        _nameController.text = expertData['name'] ?? '';
        _phoneController.text = expertData['phone_number'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[PagePersonalInfoExpert] Gagal memuat data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _placeOfBirthController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _expertiseController.dispose();
    _educationController.dispose();
    super.dispose();
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
                  _buildField('Nama Lengkap*', _nameController,
                      isEditable: _isEditing),
                  _buildField('No. Hp / WhatsApp*', _phoneController,
                      isEditable: _isEditing),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                            'Tempat Lahir*', _placeOfBirthController,
                            isEditable: _isEditing,
                            margin: const EdgeInsets.only(
                                left: 16, top: 8, right: 8, bottom: 8)),
                      ),
                      Expanded(
                        child: _buildField('Tanggal Lahir*', _dobController,
                            isEditable: _isEditing,
                            showIcon: true,
                            margin: const EdgeInsets.only(
                                left: 8, top: 8, right: 16, bottom: 8)),
                      ),
                    ],
                  ),
                  _buildField('Jenis Kelamin*', _genderController,
                      isEditable: _isEditing),
                  _buildField('Bidang Keahlian*', _expertiseController,
                      isEditable: _isEditing),
                  _buildField('Pendidikan Terakhir*', _educationController,
                      isEditable: _isEditing),
                ],
              ),
            ),
      bottomNavigationBar: _isLoading
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GlobalsButton(
                text: _isEditing ? 'Simpan Data' : 'Edit Data',
                color: _isEditing ? AppColors.primary1 : AppColors.secondary1,
                textColor: AppColors.base5,
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
              ),
            ),
    );
  }

  Widget _buildField(String title, TextEditingController controller,
      {bool isEditable = false,
      bool showIcon = false,
      EdgeInsetsGeometry? margin}) {
    if (!isEditable) {
      return CardComponents1(
        title: title,
        desc: controller.text,
        showIcon: showIcon,
        margin: margin ??
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
          Text(
            title,
            style: AppTextStyles.list3SemiBold(AppColors.base2),
          ),
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
