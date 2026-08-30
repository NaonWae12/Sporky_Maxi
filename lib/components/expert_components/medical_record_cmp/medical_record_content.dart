import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/expert_components/medical_record_cmp/data_medical_record_cmp.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/services/expert_feature/expert_feature_service.dart';
import 'package:sporky_maxi/models/components/expert_feature/child_medical_model.dart';

class MedicalRecordContent extends StatefulWidget {
  final String roomUuid;

  const MedicalRecordContent({super.key, required this.roomUuid});

  @override
  State<MedicalRecordContent> createState() => _MedicalRecordContentState();
}

class _MedicalRecordContentState extends State<MedicalRecordContent> {
  final GlobalKey<DataMedicalRecordCmpState> _formKey =
      GlobalKey<DataMedicalRecordCmpState>();

  bool _isLoading = true;
  bool _isSaving = false;
  dynamic _record;

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  Future<void> _loadRecord() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final record = await _service.getChildMedicalRecord(widget.roomUuid);
      if (!mounted) return;

      setState(() {
        _record = record;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showMessage('Gagal memuat rekam medis: $error');
    }
  }

  ExpertFeatureService get _service => const ExpertFeatureService();

  Future<void> _saveRecord() async {
    if (_isSaving) return;

    final formState = _formKey.currentState;
    if (formState == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _service.saveConsultationNotes(
        roomUuid: widget.roomUuid,
        diagnosisResult: formState.diagnosisController.text,
        recommendation: formState.adviceController.text,
      );
      if (!mounted) return;
      _showMessage('Catatan konsultasi berhasil disimpan');
    } catch (error) {
      if (!mounted) return;
      _showMessage('Gagal menyimpan catatan: $error');
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
    if (_isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    final record = _record as ChildMedicalRecord?;
    if (record == null) {
      return Expanded(
        child: Center(
          child: TextButton(
            onPressed: _loadRecord,
            child: const Text('Gagal memuat rekam medis. Coba lagi'),
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: DataMedicalRecordCmp(
              key: _formKey,
              parentName: record.parentName,
              childName: record.childName,
              calendar: record.dateOfBirth,
              age: record.ageYears,
              weight: record.weightKg,
              height: record.heightCm,
              complaint: record.complaint,
              diagnosisResult: record.diagnosisResult,
              recommendation: record.recommendation,
            ),
          ),
          GlobalsButton(
            width: MediaQuery.of(context).size.width / 1.1,
            color: AppColors.secondary1,
            customTextStyle: AppTextStyles.headList1Bold(AppColors.base5),
            onPressed: _isSaving ? null : _saveRecord,
            text: _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
          ),
        ],
      ),
    );
  }
}
