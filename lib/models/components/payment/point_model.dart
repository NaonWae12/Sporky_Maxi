import 'package:sporky_maxi/models/api/api_parser.dart';

class PointWallet {
  final String uuid;
  final int currentBalance;
  final int totalEarned;
  final DateTime? updatedAt;

  const PointWallet({
    required this.uuid,
    required this.currentBalance,
    required this.totalEarned,
    required this.updatedAt,
  });

  factory PointWallet.fromJson(JsonMap json) {
    final data = ApiParser.map(json['data']);
    return PointWallet(
      uuid: ApiParser.string(data['uuid']),
      currentBalance: ApiParser.integer(data['current_balance']),
      totalEarned: ApiParser.integer(data['total_earned']),
      updatedAt: ApiParser.dateTime(data['updated_at']),
    );
  }
}

class PointHistoryItem {
  final String uuid;
  final String type;
  final int points;
  final String description;
  final String? taskTitle;
  final String? productName;
  final DateTime? createdAt;

  const PointHistoryItem({
    required this.uuid,
    required this.type,
    required this.points,
    required this.description,
    required this.taskTitle,
    required this.productName,
    required this.createdAt,
  });

  factory PointHistoryItem.fromJson(JsonMap json) {
    return PointHistoryItem(
      uuid: ApiParser.string(json['uuid']),
      type: ApiParser.string(json['type']),
      points: ApiParser.integer(json['points']),
      description: ApiParser.string(json['description']),
      taskTitle: ApiParser.nullableString(json['task_title']),
      productName: ApiParser.nullableString(json['product_name']),
      createdAt: ApiParser.dateTime(json['created_at']),
    );
  }
}

class PointHistoryResponse {
  final List<PointHistoryItem> histories;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PointHistoryResponse({
    required this.histories,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PointHistoryResponse.fromJson(JsonMap json) {
    final data = ApiParser.map(json['data']);
    return PointHistoryResponse(
      histories: ApiParser.mapList(
        data['data'],
      ).map(PointHistoryItem.fromJson).toList(),
      currentPage: ApiParser.integer(data['current_page'], 1),
      lastPage: ApiParser.integer(data['last_page'], 1),
      perPage: ApiParser.integer(data['per_page']),
      total: ApiParser.integer(data['total']),
    );
  }
}

class PointStats {
  final int totalEarned;
  final int totalRedeemed;
  final int currentBalance;
  final int tasksCompleted;
  final int milestoneBonuses;

  const PointStats({
    required this.totalEarned,
    required this.totalRedeemed,
    required this.currentBalance,
    required this.tasksCompleted,
    required this.milestoneBonuses,
  });

  factory PointStats.fromJson(JsonMap json) {
    final data = ApiParser.map(json['data']);
    return PointStats(
      totalEarned: ApiParser.integer(data['total_earned']),
      totalRedeemed: ApiParser.integer(data['total_redeemed']),
      currentBalance: ApiParser.integer(data['current_balance']),
      tasksCompleted: ApiParser.integer(data['tasks_completed']),
      milestoneBonuses: ApiParser.integer(data['milestone_bonuses']),
    );
  }
}

class PointRedeemResponse {
  final String message;
  final int currentBalance;

  const PointRedeemResponse({
    required this.message,
    required this.currentBalance,
  });

  factory PointRedeemResponse.fromJson(JsonMap json) {
    final data = ApiParser.map(json['data']);
    return PointRedeemResponse(
      message: ApiParser.string(json['message']),
      currentBalance: ApiParser.integer(data['current_balance']),
    );
  }
}
