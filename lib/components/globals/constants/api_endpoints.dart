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
  static String get mealPlanIngredients =>
      "${ApiBaseUrl.baseUrl}/api/v1/meal-plan-ingredients";
  static String mealPlanDaily(String childUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/meal-plans/daily/$childUuid";
  static String get mealPlanFavorites =>
      "${ApiBaseUrl.baseUrl}/api/v1/meal-plans/favorites";
  static String get subscriptions =>
      "${ApiBaseUrl.baseUrl}/api/v1/subscriptions";
  static String get activeSubscription =>
      "${ApiBaseUrl.baseUrl}/api/v1/subscriptions/active";
  static String get expertMyBalance =>
      "${ApiBaseUrl.baseUrl}/api/v1/experts/me/balance";
  static String videos({int? topicId}) => topicId != null
      ? "${ApiBaseUrl.baseUrl}/api/v1/videos?topic_id=$topicId"
      : "${ApiBaseUrl.baseUrl}/api/v1/videos";
  static String videoDetail(String videoUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/videos/$videoUuid";
  static String get articles => "${ApiBaseUrl.baseUrl}/api/v1/articles";
  static String articleDetail(String articleUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/articles/$articleUuid";
  // static String get profile => "${ApiBaseUrl.baseUrl}/api/v1/user/profile";
  // Screening
  static String screeningLatestChild(String childUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/children/$childUuid/latest";

  // update data anak
  static String get updateGrowthData =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/updatedata";

  static String get children => "${ApiBaseUrl.baseUrl}/api/v1/children";
  static String get experts => "${ApiBaseUrl.baseUrl}/api/v1/experts";
  static String expertProfile(String expertUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/experts/$expertUuid/profile";
  static String mealPlanDetail(String mealPlanUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/meal-plans/$mealPlanUuid";
  static String mealPlanGlobalFavoriteCount(String mealPlanUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/meal-plans/$mealPlanUuid/global-favorite-count";
  static String mealPlanFavorite(String mealPlanUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/meal-plans/$mealPlanUuid/favorite";
  static String get chatRooms => "${ApiBaseUrl.baseUrl}/api/v1/chat/rooms";
  static String get chatRoomGetOrCreate =>
      "${ApiBaseUrl.baseUrl}/api/v1/chat/rooms/get-or-create";
  static String chatRoomMessages(String roomUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/chat/rooms/$roomUuid/messages";
  static String chatRoomMessageRead(String roomUuid, String messageUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/chat/rooms/$roomUuid/messages/$messageUuid/read";
  static String chatRoomChildProfile(String roomUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/chat/rooms/$roomUuid/child-profile";

  static String get createManualFoodIntake =>
      "${ApiBaseUrl.baseUrl}/api/v1/food-intakes/create-manual";
  static String get createFoodIntakeFromMealPlan =>
      "${ApiBaseUrl.baseUrl}/api/v1/food-intakes/create-from-mealplan";
  static String get foodIntakes => "${ApiBaseUrl.baseUrl}/api/v1/food-intakes";
  static String get totalCalories =>
      "${ApiBaseUrl.baseUrl}/api/v1/food-intakes/total-calories";
  static String get foodWaste => "${ApiBaseUrl.baseUrl}/api/v1/food-waste";

  static String zScoreChartByChild(String childUuid, {int limit = 30}) =>
      "${ApiBaseUrl.baseUrl}/api/v1/screening/children/$childUuid/zscore-chart?limit=$limit";
  static String get subscriptionsCheckout =>
      "${ApiBaseUrl.baseUrl}/api/v1/subscriptions/checkout";
  static String get expertProfileMe =>
      "${ApiBaseUrl.baseUrl}/api/v1/experts/me";
  static String childFoodHistory(String childUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/dashboard/children/$childUuid/food-history";
  static String mealPlanRecommendation(String childUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/dashboard/children/$childUuid/meal-plan-recommendation";
  static String mealPlanByCalorie(String childUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/dashboard/children/$childUuid/meal-plan-by-calorie";
  static String childProfileDashboard(String childUuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/dashboard/children/$childUuid/profile";
  static String foodWasteMonthlySummary(String childUuid, {String? month}) {
    final base = '${ApiBaseUrl.baseUrl}/api/v1/food-waste/monthly-summary?child_uuid=$childUuid';
    return month != null && month.isNotEmpty ? '$base&month=$month' : base;
  }
  static String videoRecommendations({
    String? zscoreStatus,
    String? medicalHistory,
    String? allergy,
    int limit = 20,
  }) {
    final params = <String, String>{'limit': limit.toString()};
    if (zscoreStatus != null && zscoreStatus.isNotEmpty) {
      params['zscore_status'] = zscoreStatus;
    }
    if (medicalHistory != null && medicalHistory.isNotEmpty) {
      params['medical_history'] = medicalHistory;
    }
    if (allergy != null && allergy.isNotEmpty) {
      params['allergy'] = allergy;
    }
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '${ApiBaseUrl.baseUrl}/api/v1/videos/recommendations?$query';
  }
  static String articleRecommendations({
    String? zscoreStatus,
    String? medicalHistory,
    String? allergy,
    int limit = 20,
  }) {
    final params = <String, String>{'limit': limit.toString()};
    if (zscoreStatus != null && zscoreStatus.isNotEmpty) {
      params['zscore_status'] = zscoreStatus;
    }
    if (medicalHistory != null && medicalHistory.isNotEmpty) {
      params['medical_history'] = medicalHistory;
    }
    if (allergy != null && allergy.isNotEmpty) {
      params['allergy'] = allergy;
    }
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '${ApiBaseUrl.baseUrl}/api/v1/articles/recommendations?$query';
  }
  static String get topics => "${ApiBaseUrl.baseUrl}/api/v1/topics";
  static String get guidelines => "${ApiBaseUrl.baseUrl}/api/v1/guidelines";
  static String get dailyTasks => "${ApiBaseUrl.baseUrl}/api/v1/daily-tasks";
  static String get dailyTasksProgress =>
      "${ApiBaseUrl.baseUrl}/api/v1/daily-tasks/progress";
  static String completeTask(String uuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/daily-tasks/$uuid/complete";
  static String claimTask(String uuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/daily-tasks/$uuid/claim";

  // === Ads ===
  static String get ads => "${ApiBaseUrl.baseUrl}/api/v1/ads";
  static String adDetail(int id) => "${ApiBaseUrl.baseUrl}/api/v1/ads/$id";

  // === Carousels ===
  static String get carousels => "${ApiBaseUrl.baseUrl}/api/v1/carousels";
  static String carouselDetail(String uuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/carousels/$uuid";

  // === Vouchers ===
  static String get vouchers => "${ApiBaseUrl.baseUrl}/api/v1/vouchers";
  static String voucherDetail(String uuid) =>
      "${ApiBaseUrl.baseUrl}/api/v1/vouchers/$uuid";
  static String get redeemVoucher =>
      "${ApiBaseUrl.baseUrl}/api/v1/vouchers/redeem";
}

