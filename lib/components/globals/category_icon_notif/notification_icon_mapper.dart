class NotificationIconMapper {
  static const Map<String, String> _iconMap = {
    "promo": "assets/icons/promo.svg",
    "order": "assets/icons/order.svg",
    "chat": "assets/svg/chat-rounded.svg",
    "video": "assets/svg/video-fill.svg",
    "consultations": "assets/svg/user-doctor.svg"
  };

  static String getIcon(String category) {
    return _iconMap[category] ?? "assets/svg/ic_coin.svg";
  }
}
