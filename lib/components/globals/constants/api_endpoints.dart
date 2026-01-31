import 'api_base_url.dart';

class ApiEndpoints {
  static String get register => "${ApiBaseUrl.baseUrl}/api/v1/auth/register";
  static String get login => "${ApiBaseUrl.baseUrl}/api/v1/auth/login";
  // Screening
  static String get medicalHistory =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/medical-histories";
  static String get allergies =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/allergies";
  static String get favoriteFoods =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/favorite-foods";
  static String get avoidedFoods =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/food-avoided";
  static String get childActivity =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/child-activity";
  static String get screeningChildProfile =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/create";
  static String get mealPlan => "${ApiBaseUrl.baseUrl}/api/v1/meal-plans";
  // static String get profile => "${ApiBaseUrl.baseUrl}/api/v1/user/profile";
  // Screening
  static String screeningLatestChild(String childUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/children/$childUuid/latest";

  // update data anak
  static String get updateGrowthData =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/updatedata";

  static String get children => "${ApiBaseUrl.baseUrl}/api/v1/children";

  static String zScoreChartByChild(String childUuid, {int limit = 30}) =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/children/$childUuid/zscore-chart?limit=$limit";
}
