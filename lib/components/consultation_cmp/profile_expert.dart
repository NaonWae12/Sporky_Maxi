import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/consultation_cmp/cmp_profile_expert.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../globals/bar/full_width_tab_bar.dart';
import '../globals/dialog/dialog_content_cmp/chat_consultation.dart';
import '../globals/dialog/dialog_content_cmp/zoom_consultation.dart';
import '../globals/dialog/globals_bottom_sheet.dart';
import 'cmp_tab_profile_expert.dart';
import 'cmp_tab_ticket_expert.dart';

class ProfileExpert extends StatefulWidget {
  final String expertId;
  final String expertUuid;
  final String doctorName;
  final String starCount;

  const ProfileExpert({
    super.key,
    this.expertId = '',
    this.expertUuid = '',
    this.doctorName = 'dr.Palomina',
    this.starCount = '0.0',
  });

  @override
  State<ProfileExpert> createState() => _ProfileExpertState();
}

class _ProfileExpertState extends State<ProfileExpert> {
  static const String _fallbackExperience = '';
  static const String _fallbackSpecialization = '';
  static const String _fallbackWorkingDays = '';
  static const String _fallbackWorkingHours = '';
  static const String _fallbackPrice = '';

  late Future<_ExpertProfileData?> _expertProfileFuture;

  @override
  void initState() {
    super.initState();
    _expertProfileFuture = _fetchExpertProfile();
  }

  String get _profileUuid {
    final expertId = widget.expertId.trim();
    if (expertId.isNotEmpty) return expertId;
    return widget.expertUuid.trim();
  }

  Future<_ExpertProfileData?> _fetchExpertProfile() async {
    final profileUuid = _profileUuid;
    if (profileUuid.isEmpty) return null;

    try {
      final token = await SecureStorageService.getToken();
      if (token == null || token.isEmpty) return null;

      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      final response = await http.get(
        Uri.parse(ApiEndpoints.expertProfile(profileUuid)),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
          '[ProfileExpert] Failed to load profile '
          '(${response.statusCode}): ${response.body}',
        );
        return null;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final dataNode = decoded['data'];
      if (dataNode is! Map<String, dynamic>) return null;

      return _ExpertProfileData(
        name: _nonEmptyString(dataNode['name']),
        specialization: _nonEmptyString(dataNode['specialization']),
        experienceYears: _experienceToString(dataNode['experience_years']),
        availableDays: _availableDaysToString(dataNode['available_days']),
        availableHours: _availableHoursToString(dataNode),
        profileSections: _buildProfileSections(dataNode),
      );
    } catch (e) {
      debugPrint('[ProfileExpert] Error loading profile: $e');
      return null;
    }
  }

  String? _nonEmptyString(dynamic value) {
    final text = (value?.toString() ?? '').trim();
    return text.isEmpty ? null : text;
  }

  String? _experienceToString(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toString();
    if (value is double) return value.toStringAsFixed(0);
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  String? _availableDaysToString(dynamic value) {
    if (value is! List) return null;
    final days = value
        .map((e) => (e?.toString() ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (days.isEmpty) return null;
    return days.join(', ');
  }

  String? _availableHoursToString(Map<String, dynamic> data) {
    final direct = _nonEmptyString(data['available_hours']);
    if (direct != null) return direct;

    final start = _nonEmptyString(data['available_time_start']);
    final end = _nonEmptyString(data['available_time_end']);

    if (start != null && end != null) return '$start - $end';
    return start ?? end;
  }

  List<ProfileSection> _buildProfileSections(Map<String, dynamic> data) {
    final experienceItems = _mapProfileItems(
      data['experiences'] ??
          data['experience'] ??
          data['professional_experiences'] ??
          data['work_experiences'],
    );
    final educationItems = _mapProfileItems(data['education']);

    final sections = <ProfileSection>[];
    if (experienceItems.isNotEmpty) {
      sections.add(
        ProfileSection(
          title: 'Pengalaman Profesional',
          icon: Icons.work,
          items: experienceItems,
        ),
      );
    }

    if (educationItems.isNotEmpty) {
      sections.add(
        ProfileSection(
          title: 'Pendidikan',
          icon: Icons.school,
          items: educationItems,
        ),
      );
    }

    return sections;
  }

  List<ProfileItem> _mapProfileItems(dynamic raw) {
    if (raw is! List) return const <ProfileItem>[];

    final items = <ProfileItem>[];
    for (final entry in raw.whereType<Map<String, dynamic>>()) {
      final year = _resolveYear(entry);
      final location = _pickFirstNonEmpty(entry, const [
        'location',
        'institution',
        'organization',
        'company',
        'campus',
      ]);
      final place = _pickFirstNonEmpty(entry, const ['place', 'city']);
      final position = _pickFirstNonEmpty(entry, const [
        'position',
        'title',
        'degree',
        'major',
        'description',
      ]);

      if (year.isEmpty &&
          location.isEmpty &&
          place.isEmpty &&
          position.isEmpty) {
        continue;
      }

      items.add(
        ProfileItem(
          year: year,
          location: location,
          place: place,
          position: position,
        ),
      );
    }

    return items;
  }

  String _resolveYear(Map<String, dynamic> entry) {
    final direct = _pickFirstNonEmpty(
      entry,
      const ['year', 'period', 'date', 'duration'],
    );
    if (direct.isNotEmpty) return direct;

    final start = _pickFirstNonEmpty(
      entry,
      const ['start_year', 'startYear', 'start_date', 'from'],
    );
    final end = _pickFirstNonEmpty(
      entry,
      const ['end_year', 'endYear', 'end_date', 'to'],
    );
    if (start.isNotEmpty && end.isNotEmpty) return '$start - $end';
    if (start.isNotEmpty) return start;
    return end;
  }

  String _pickFirstNonEmpty(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = (source[key]?.toString() ?? '').trim();
      if (value.isNotEmpty && value.toLowerCase() != 'null') {
        return value;
      }
    }
    return '';
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
                icon: const Icon(Icons.arrow_back_ios)),
            Text('Profil Expert', style: AppTextStyles.heading2SemiBold()),
          ],
        ),
      ),
      body: FutureBuilder<_ExpertProfileData?>(
        future: _expertProfileFuture,
        builder: (context, snapshot) {
          final profile = snapshot.data;

          return Column(
            children: [
              CmpProfileExpert(
                doctorName: profile?.name ?? widget.doctorName,
                starCount: widget.starCount,
                experience: profile?.experienceYears ?? _fallbackExperience,
                specialization:
                    profile?.specialization ?? _fallbackSpecialization,
                workingDays: profile?.availableDays ?? _fallbackWorkingDays,
                workingHours: profile?.availableHours ?? _fallbackWorkingHours,
                price: _fallbackPrice,
              ),
              Expanded(
                child: FullWidthTabBar(tabs: const [
                  'Profil',
                  'Tiket Konsultasi'
                ], tabViews: [
                  CmpTabProfileExpert(
                    sections: profile?.profileSections ?? const <ProfileSection>[],
                  ),
                  CmpTabTicketExpert(
                    buyTicketCall: () {
                      GlobalsBottomSheet.show(
                        context: context,
                        height: 350,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13.0, vertical: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ZoomConsultation(
                                imageAsset: 'assets/temp_img/dr.palomina1.jpg',
                                doctorName: widget.doctorName,
                                price: 50000,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    buyTicketChat: () {
                      GlobalsBottomSheet.show(
                        context: context,
                        height: 350,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13.0, vertical: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ChatConsultation(
                                imageAsset: 'assets/temp_img/dr.palomina1.jpg',
                                expertId: widget.expertId,
                                expertUuid: widget.expertUuid,
                                doctorName: widget.doctorName,
                                price: 50000,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    callPrice: '100.000',
                    chatPrice: '50.000',
                    duration: '30',
                    session: '1',
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ExpertProfileData {
  final String? name;
  final String? specialization;
  final String? experienceYears;
  final String? availableDays;
  final String? availableHours;
  final List<ProfileSection> profileSections;

  const _ExpertProfileData({
    this.name,
    this.specialization,
    this.experienceYears,
    this.availableDays,
    this.availableHours,
    this.profileSections = const <ProfileSection>[],
  });
}
