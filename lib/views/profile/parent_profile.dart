import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/profile_content/cmp_parent_profile.dart';
import 'package:sporky_maxi/core/services/profile/profile_service.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../../components/globals/text/text_style.dart';
import 'page_setting_profile/page_setting_parent_profile.dart';

class ParentProfile extends StatefulWidget {
  const ParentProfile({super.key});

  @override
  State<ParentProfile> createState() => _ParentProfileState();
}

class _ParentProfileState extends State<ParentProfile> {
  static const ProfileService _profileService = ProfileService();

  String _name = 'Orangtua Sporky';
  String? _avatar;
  String _childName = 'Anak Sporky';
  int _ageYear = 0;
  int _ageMonth = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getParentProfile();
      final childUuid =
          (await SecureStorageService.getSelectedChildUuid() ?? '').trim();
      var childName = _childName;
      var ageYear = 0;
      var ageMonth = 0;

      if (childUuid.isNotEmpty) {
        final child = await _profileService.getChildProfile(childUuid);
        childName = child.name;
        final parsedDate = DateTime.tryParse(child.dob);
        if (parsedDate != null) {
          final now = DateTime.now();
          ageYear = now.year - parsedDate.year;
          ageMonth = now.month - parsedDate.month;
          if (ageMonth < 0) {
            ageYear--;
            ageMonth += 12;
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _name = profile.name;
        _avatar = profile.avatar;
        _childName = childName;
        _ageYear = ageYear;
        _ageMonth = ageMonth;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text('Profil Orangtua', style: AppTextStyles.heading2SemiBold()),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  CmpParentProfile(
                    directToEditPage: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PageSettingParentProfile(),
                        ),
                      ).then((_) => _loadProfile());
                    },
                    name: _name,
                    photoUrl: _avatar,
                    countNotif: 5,
                    badgeImg: 'assets/health_badge.png',
                    childName: _childName,
                    childAgeYear: _ageYear,
                    childAgeMonth: _ageMonth,
                  ),
                ],
              ),
            ),
    );
  }
}
