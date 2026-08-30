import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/config/auth_provider_config.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/core/utils/auth_session_manager.dart';
import 'package:sporky_maxi/core/utils/profile_photo_resolver.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

class AuthService {
  static const ApiClient _apiClient = ApiClient();
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: AuthProviderConfig.googleIosClientId.isEmpty
        ? null
        : AuthProviderConfig.googleIosClientId,
    serverClientId: AuthProviderConfig.googleServerClientId.isEmpty
        ? null
        : AuthProviderConfig.googleServerClientId,
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>> loginEmailPassword({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'remember_me': rememberMe,
      }),
    );
    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );
    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> loginGoogle({
    required String idToken,
  }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.googleLogin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_token': idToken}),
    );
    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> linkGoogle({
    required String idToken,
  }) async {
    final token = await SecureStorageService.getToken();
    final response = await http.post(
      Uri.parse(ApiEndpoints.googleLink),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': token,
      },
      body: jsonEncode({'id_token': idToken}),
    );
    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw AuthCancelledException();
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null || idToken.isEmpty) {
      throw ApiException(
        message: 'Google ID token tidak tersedia',
        statusCode: 0,
        body: const {},
      );
    }

    return loginGoogle(idToken: idToken);
  }

  static Future<Map<String, dynamic>> loginApple({
    required String identityToken,
    String? fullName,
    String? email,
  }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.appleLogin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identity_token': identityToken,
        'full_name': fullName,
        'email': email,
      }),
    );
    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> linkApple({
    required String identityToken,
    String? fullName,
    String? email,
  }) async {
    final token = await SecureStorageService.getToken();
    final response = await http.post(
      Uri.parse(ApiEndpoints.appleLink),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': token,
      },
      body: jsonEncode({
        'identity_token': identityToken,
        'full_name': fullName,
        'email': email,
      }),
    );
    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.forgotPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String otp,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.resetPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'otp': otp,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );
    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> signInWithApple() async {
    if (!await SignInWithApple.isAvailable()) {
      throw ApiException(
        message: 'Sign in with Apple tidak tersedia di perangkat ini',
        statusCode: 0,
        body: const {},
      );
    }

    final AuthorizationCredentialAppleID credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: _appleWebAuthenticationOptions(),
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw AuthCancelledException();
      }

      rethrow;
    }

    final identityToken = credential.identityToken;
    if (identityToken == null || identityToken.isEmpty) {
      throw ApiException(
        message: 'Apple identity token tidak tersedia',
        statusCode: 0,
        body: const {},
      );
    }

    final fullName = [credential.givenName, credential.familyName]
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .join(' ');

    return loginApple(
      identityToken: identityToken,
      fullName: fullName.isEmpty ? null : fullName,
      email: credential.email,
    );
  }

  static WebAuthenticationOptions? _appleWebAuthenticationOptions() {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }

    final serviceId = AuthProviderConfig.appleServiceId.trim();
    final redirectUriValue = AuthProviderConfig.appleRedirectUri.trim();

    if (serviceId.isEmpty || redirectUriValue.isEmpty) {
      throw ApiException(
        message:
            'Konfigurasi Apple Login Android belum lengkap. Isi APPLE_SERVICE_ID dan APPLE_REDIRECT_URI saat menjalankan Flutter.',
        statusCode: 0,
        body: const {},
      );
    }

    final redirectUri = Uri.tryParse(redirectUriValue);
    if (redirectUri == null ||
        redirectUri.scheme != 'https' ||
        redirectUri.host.isEmpty) {
      throw ApiException(
        message: 'APPLE_REDIRECT_URI harus berupa URL HTTPS publik.',
        statusCode: 0,
        body: const {},
      );
    }

    return WebAuthenticationOptions(
      clientId: serviceId,
      redirectUri: redirectUri,
    );
  }

  static Future<void> persistSession(Map<String, dynamic> body) async {
    final data = body['data'] as Map<String, dynamic>?;
    final user = data?['user'] as Map<String, dynamic>?;
    final token = data?['token']?.toString();
    final tokenType = data?['token_type']?.toString() ?? 'Bearer';
    final userUuid = user?['uuid']?.toString();
    final userName = user?['name']?.toString();
    final userRole = user?['role']?.toString().trim().toLowerCase();
    final userPhoto = _resolveProfilePhoto(user);

    if (token == null ||
        token.isEmpty ||
        userUuid == null ||
        userRole == null ||
        userRole.isEmpty) {
      throw ApiException(
        message: 'Login berhasil tapi data tidak lengkap',
        statusCode: 0,
        body: body,
      );
    }

    await AuthSessionManager.saveAuthData(
      token: '$tokenType $token',
      userUuid: userUuid,
      userRole: userRole,
      userName: userName,
      userPhoto: userPhoto,
    );
  }

  static Future<void> logout() async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      await SecureStorageService.clearAll();
      return;
    }

    try {
      await http.post(
        Uri.parse(ApiEndpoints.logout),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
    } finally {
      try {
        await _googleSignIn.signOut();
      } catch (error) {
        debugPrint('Google sign-out failed: $error');
      }
      await SecureStorageService.clearAll();
    }
  }

  static Future<bool> hasValidCachedSession() async {
    final token = await SecureStorageService.getToken();
    final role = await SecureStorageService.getUserRole();
    final uuid = await SecureStorageService.getUserUuid();

    final hasCachedSession =
        token != null &&
        token.isNotEmpty &&
        role != null &&
        role.trim().isNotEmpty &&
        uuid != null &&
        uuid.trim().isNotEmpty;

    if (!hasCachedSession) return false;

    try {
      await refreshCachedUser();
      return true;
    } catch (_) {
      await SecureStorageService.clearAll();
      return false;
    }
  }

  static Future<Map<String, dynamic>> me() async {
    return _apiClient.get(ApiEndpoints.me);
  }

  static Future<void> refreshCachedUser() async {
    final response = await me();
    final user = response['data'] as Map<String, dynamic>?;
    final uuid = user?['uuid']?.toString();
    final role = user?['role']?.toString().trim().toLowerCase();
    final name = user?['name']?.toString();
    final photo = _resolveProfilePhoto(user);

    if (uuid != null && uuid.isNotEmpty) {
      await SecureStorageService.saveUserUuid(uuid);
    }

    if (role != null && role.isNotEmpty) {
      await SecureStorageService.saveUserRole(role);
    }

    if (name != null && name.isNotEmpty) {
      await SecureStorageService.saveUserName(name);
    }

    if (photo != null && photo.isNotEmpty) {
      await SecureStorageService.saveUserPhoto(photo);
    }
  }

  static String? _resolveProfilePhoto(Map<String, dynamic>? user) {
    if (user == null) return null;

    for (final key in const ['photo', 'avatar', 'photo_url', 'avatar_url']) {
      final photo = ProfilePhotoResolver.resolve(user[key]);
      if (photo != null && photo.isNotEmpty) return photo;
    }

    return null;
  }

  static Future<Map<String, dynamic>> _decodeResponse(
    http.Response response,
  ) async {
    final dynamic body = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : {};

    if (response.statusCode == 401) {
      await SecureStorageService.clearAll();
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Map<String, dynamic>.from(body as Map);
    }

    if (body is Map<String, dynamic>) {
      throw ApiException(
        message: body['message']?.toString() ?? 'Request failed',
        statusCode: response.statusCode,
        body: body,
      );
    }

    throw ApiException(
      message: 'Request failed',
      statusCode: response.statusCode,
      body: const {},
    );
  }
}

class AuthCancelledException implements Exception {}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic> body;

  ApiException({
    required this.message,
    required this.statusCode,
    required this.body,
  });
}
