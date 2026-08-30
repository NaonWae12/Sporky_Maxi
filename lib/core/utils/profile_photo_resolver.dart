import 'package:sporky_maxi/components/globals/constants/api_base_url.dart';

class ProfilePhotoResolver {
  const ProfilePhotoResolver._();

  static String? resolve(dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) return null;

    if (text.startsWith('http://') ||
        text.startsWith('https://') ||
        text.startsWith('assets/')) {
      return text;
    }

    if (text.startsWith('/')) {
      return '${ApiBaseUrl.baseUrl}$text';
    }

    if (text.startsWith('storage/')) {
      return '${ApiBaseUrl.baseUrl}/$text';
    }

    return '${ApiBaseUrl.baseUrl}/storage/$text';
  }
}
