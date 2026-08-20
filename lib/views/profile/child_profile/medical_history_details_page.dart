import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:intl/intl.dart';
import '../../../core/services/child/screening_service.dart';
import '../../../core/utils/age_helper.dart';
import '../../../components/expert_components/profile/child_data_cmp/biodata_cmp.dart';

class MedicalHistoryDetailsPage extends StatefulWidget {
  final String childUuid;
  final String? roomUuid;
  final String parentName;

  const MedicalHistoryDetailsPage({
    super.key,
    required this.childUuid,
    this.roomUuid,
    this.parentName = 'Orang Tua',
  });

  @override
  State<MedicalHistoryDetailsPage> createState() =>
      _MedicalHistoryDetailsPageState();
}

class _MedicalHistoryDetailsPageState extends State<MedicalHistoryDetailsPage> {
  bool _isEditing = false;
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();

  String _childName = 'Memuat...';
  String _dob = '-';
  String _age = '-';
  String _weight = '-';
  String _height = '-';
  final String _complaint = 'Nafsu makan turun [Hardcoded]';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final screeningData = await ScreeningService().getLatestByChildUuid(widget.childUuid);
      
      final ageResult = calculateAge(screeningData.child.dob);
      final ageStr = "${ageResult['year']} tahun ${ageResult['month']} bulan";

      setState(() {
        _childName = screeningData.child.name;
        _dob = DateFormat('dd/MM/yyyy').format(screeningData.child.dob);
        _age = ageStr;
        _weight = screeningData.screening?.weight?.toStringAsFixed(1) ?? '-';
        _height = screeningData.screening?.height?.toString() ?? '-';
        
        // Default text for controllers if empty
        if (_diagnosisController.text.isEmpty || _diagnosisController.text.contains('Penurunan berat')) {
           _diagnosisController.text = 'Penurunan berat badan yang cepat... [Hardcoded]';
        }
        if (_treatmentController.text.isEmpty || _treatmentController.text.contains('Sebagai langkah')) {
           _treatmentController.text = 'Disarankan untuk memberikan makanan... [Hardcoded]';
        }
      });

      if (widget.roomUuid != null) {
        // Option to fetch more details if needed
      }
    } catch (e) {
      debugPrint('[MedicalHistoryDetailsPage] Gagal memuat data: $e');
    }
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _treatmentController.dispose();
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
          'Rekam Medis Konsultasi',
          style: AppTextStyles.heading2SemiBold(AppColors.base1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          children: [
            // Info Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/svg/ic_warn.svg',
                    height: 20,
                    width: 20,
                    colorFilter: const ColorFilter.mode(
                        AppColors.info1, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Rekam medis ini akan membantu orangtua memahami kondisi dan arahan lanjutan dari sesi konsultasi. Tuliskan dengan jelas dan ringkas.',
                      style: AppTextStyles.list1Regular(AppColors.base1),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: AppColors.info1, thickness: 1),
            ),
            const SizedBox(height: 16),

            // Read-only fields
            CardComponents1(
              title: 'Nama Orangtua',
              desc: widget.parentName,
            ),
            CardComponents1(
              title: 'Nama Anak',
              desc: _childName,
            ),
            Row(
              children: [
                Expanded(
                  child: CardComponents1(
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 8, bottom: 8),
                    title: 'Tanggal Lahir',
                    desc: _dob,
                    showIcon: true,
                  ),
                ),
                Expanded(
                  child: CardComponents1(
                    margin: const EdgeInsets.only(
                        left: 8, top: 8, right: 16, bottom: 8),
                    title: 'Umur',
                    desc: _age,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CardComponents1(
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 8, bottom: 8),
                    title: 'Berat Badan (Kg)',
                    desc: _weight,
                  ),
                ),
                Expanded(
                  child: CardComponents1(
                    margin: const EdgeInsets.only(
                        left: 8, top: 8, right: 16, bottom: 8),
                    title: 'Tinggi Badan (cm)',
                    desc: _height,
                  ),
                ),
              ],
            ),
            CardComponents1(
              title: 'Keluhan',
              desc: _complaint,
            ),

            // Editable fields
            _isEditing
                ? _buildEditableField('Hasil Diagnosis', _diagnosisController)
                : CardComponents1(
                    widthBox: 360,
                    title: 'Hasil Diagnosis',
                    desc: _diagnosisController.text,
                  ),
            
            _isEditing
                ? _buildEditableField('Saran/Tindakan', _treatmentController)
                : CardComponents1(
                    widthBox: 360,
                    title: 'Saran/Tindakan',
                    desc: _treatmentController.text,
                  ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
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

  Widget _buildEditableField(String title, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
          TextFormField(
            controller: controller,
            maxLines: null,
            style: AppTextStyles.headList1Regular(AppColors.base1),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
          ),
        ],
      ),
    );
  }
}
