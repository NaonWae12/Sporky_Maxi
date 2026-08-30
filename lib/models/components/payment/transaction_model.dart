import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/api/pagination_meta.dart';

class AppTransactionProduct {
  final String uuid;
  final String name;
  final String type;
  final double price;

  const AppTransactionProduct({
    required this.uuid,
    required this.name,
    required this.type,
    required this.price,
  });

  factory AppTransactionProduct.fromJson(JsonMap json) {
    return AppTransactionProduct(
      uuid: ApiParser.string(json['uuid']),
      name: ApiParser.string(json['name']),
      type: ApiParser.string(json['type']),
      price: ApiParser.decimal(json['price']),
    );
  }
}

class AppTransactionExpert {
  final String uuid;
  final String userUuid;
  final String name;
  final String role;
  final double rating;
  final String? photo;
  final String? specialization;
  final List<String> availableDays;
  final String? availableHours;
  final String? availableTimeStart;
  final String? availableTimeEnd;

  const AppTransactionExpert({
    required this.uuid,
    required this.userUuid,
    required this.name,
    required this.role,
    required this.rating,
    required this.photo,
    required this.specialization,
    required this.availableDays,
    required this.availableHours,
    required this.availableTimeStart,
    required this.availableTimeEnd,
  });

  factory AppTransactionExpert.fromJson(JsonMap json) {
    return AppTransactionExpert(
      uuid: ApiParser.string(json['uuid']),
      userUuid: ApiParser.string(json['user_uuid']),
      name: ApiParser.string(json['name'], 'Dokter Sporky'),
      role: ApiParser.string(json['role'], 'dokter'),
      rating: ApiParser.decimal(json['rating']),
      photo: ApiParser.nullableString(json['photo']),
      specialization: ApiParser.nullableString(json['specialization']),
      availableDays: _stringList(json['available_days']),
      availableHours: ApiParser.nullableString(json['available_hours']),
      availableTimeStart: ApiParser.nullableString(
        json['available_time_start'],
      ),
      availableTimeEnd: ApiParser.nullableString(json['available_time_end']),
    );
  }

  String get displayRole {
    switch (role.toLowerCase()) {
      case 'doctor':
      case 'dokter':
        return 'Dokter';
      case 'nutritionist':
      case 'ahli gizi':
        return 'Ahli Gizi';
      default:
        return role.isEmpty ? 'Expert' : role;
    }
  }
}

class AppTransactionConsultationProduct {
  final String uuid;
  final String type;
  final int duration;
  final double price;
  final AppTransactionExpert? expert;

  const AppTransactionConsultationProduct({
    required this.uuid,
    required this.type,
    required this.duration,
    required this.price,
    required this.expert,
  });

  factory AppTransactionConsultationProduct.fromJson(JsonMap json) {
    final expertJson = ApiParser.map(json['expert']);
    return AppTransactionConsultationProduct(
      uuid: ApiParser.string(json['uuid']),
      type: ApiParser.string(json['type']),
      duration: ApiParser.integer(json['duration']),
      price: ApiParser.decimal(json['price']),
      expert: expertJson.isEmpty
          ? null
          : AppTransactionExpert.fromJson(expertJson),
    );
  }
}

class AppTransactionChatRoom {
  final String uuid;
  final String status;
  final DateTime? expiredAt;

  const AppTransactionChatRoom({
    required this.uuid,
    required this.status,
    required this.expiredAt,
  });

  factory AppTransactionChatRoom.fromJson(JsonMap json) {
    return AppTransactionChatRoom(
      uuid: ApiParser.string(json['uuid']),
      status: ApiParser.string(json['status']),
      expiredAt: ApiParser.dateTime(json['expired_at']),
    );
  }
}

class AppTransactionConsultation {
  final String uuid;
  final String type;
  final String status;
  final DateTime? date;
  final String? zoomLink;
  final String? chatRoomUuid;
  final AppTransactionChatRoom? chatRoom;
  final AppTransactionConsultationProduct? product;
  final AppTransactionExpert? expert;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppTransactionConsultation({
    required this.uuid,
    required this.type,
    required this.status,
    required this.date,
    required this.zoomLink,
    required this.chatRoomUuid,
    required this.chatRoom,
    required this.product,
    required this.expert,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppTransactionConsultation.fromJson(JsonMap json) {
    final chatRoomJson = ApiParser.map(json['chat_room']);
    final productJson = ApiParser.map(json['product']);
    final expertJson = ApiParser.map(json['expert']);

    return AppTransactionConsultation(
      uuid: ApiParser.string(json['uuid']),
      type: ApiParser.string(json['type']),
      status: ApiParser.string(json['status']),
      date: ApiParser.dateTime(json['date']),
      zoomLink: ApiParser.nullableString(json['zoom_link']),
      chatRoomUuid: ApiParser.nullableString(json['chat_room_uuid']),
      chatRoom: chatRoomJson.isEmpty
          ? null
          : AppTransactionChatRoom.fromJson(chatRoomJson),
      product: productJson.isEmpty
          ? null
          : AppTransactionConsultationProduct.fromJson(productJson),
      expert: expertJson.isEmpty
          ? null
          : AppTransactionExpert.fromJson(expertJson),
      createdAt: ApiParser.dateTime(json['created_at']),
      updatedAt: ApiParser.dateTime(json['updated_at']),
    );
  }
}

class AppTransactionChild {
  final String uuid;
  final String name;

  const AppTransactionChild({required this.uuid, required this.name});

  factory AppTransactionChild.fromJson(JsonMap json) {
    return AppTransactionChild(
      uuid: ApiParser.string(json['uuid']),
      name: ApiParser.string(json['name'], 'Anak'),
    );
  }
}

class AppTransaction {
  final String uuid;
  final String orderId;
  final String paymentMethod;
  final String status;
  final double totalAmount;
  final DateTime? date;
  final AppTransactionProduct? product;
  final AppTransactionConsultationProduct? consultationProduct;
  final AppTransactionConsultation? consultation;
  final AppTransactionChild? child;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppTransaction({
    required this.uuid,
    required this.orderId,
    required this.paymentMethod,
    required this.status,
    required this.totalAmount,
    required this.date,
    required this.product,
    required this.consultationProduct,
    required this.consultation,
    required this.child,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppTransaction.fromJson(JsonMap json) {
    final productJson = ApiParser.map(json['product']);
    final consultationProductJson = ApiParser.map(json['consultation_product']);
    final consultationJson = ApiParser.map(json['consultation']);
    final childJson = ApiParser.map(json['child']);

    return AppTransaction(
      uuid: ApiParser.string(json['uuid']),
      orderId: ApiParser.string(json['order_id']),
      paymentMethod: ApiParser.string(json['payment_method']),
      status: ApiParser.string(json['status']),
      totalAmount: ApiParser.decimal(json['total_amount']),
      date: ApiParser.dateTime(json['date']),
      product: productJson.isEmpty
          ? null
          : AppTransactionProduct.fromJson(productJson),
      consultationProduct: consultationProductJson.isEmpty
          ? null
          : AppTransactionConsultationProduct.fromJson(consultationProductJson),
      consultation: consultationJson.isEmpty
          ? null
          : AppTransactionConsultation.fromJson(consultationJson),
      child: childJson.isEmpty ? null : AppTransactionChild.fromJson(childJson),
      createdAt: ApiParser.dateTime(json['created_at']),
      updatedAt: ApiParser.dateTime(json['updated_at']),
    );
  }

  bool get isConsultation {
    final productType = product?.type.toLowerCase().trim() ?? '';
    return consultationProduct != null ||
        consultation != null ||
        productType == 'consultation';
  }

  bool get isPending => status.toLowerCase().trim() == 'pending';

  bool get isCompleted => status.toLowerCase().trim() == 'completed';

  String get consultationType {
    final fromConsultation = consultation?.type.trim() ?? '';
    if (fromConsultation.isNotEmpty) return fromConsultation;

    final fromProduct = consultationProduct?.type.trim() ?? '';
    if (fromProduct.isNotEmpty) return fromProduct;

    final fromConsultationProduct = consultation?.product?.type.trim() ?? '';
    if (fromConsultationProduct.isNotEmpty) return fromConsultationProduct;

    return product?.type.trim() ?? '';
  }

  DateTime? get consultationDate => consultation?.date;

  String? get zoomLink => consultation?.zoomLink;

  String? get chatRoomUuid {
    final direct = consultation?.chatRoomUuid?.trim() ?? '';
    if (direct.isNotEmpty) return direct;

    final nested = consultation?.chatRoom?.uuid.trim() ?? '';
    return nested.isEmpty ? null : nested;
  }

  AppTransactionExpert? get expert {
    return consultation?.expert ??
        consultationProduct?.expert ??
        consultation?.product?.expert;
  }

  AppTransactionConsultationProduct? get resolvedConsultationProduct {
    return consultationProduct ?? consultation?.product;
  }

  DateTime? get expiresAt {
    final baseDate = createdAt ?? date;
    return baseDate?.add(const Duration(days: 30));
  }
}

class AppTransactionListResponse {
  final List<AppTransaction> transactions;
  final PaginationMeta pagination;

  const AppTransactionListResponse({
    required this.transactions,
    required this.pagination,
  });

  factory AppTransactionListResponse.fromJson(JsonMap json) {
    final data = ApiParser.map(json['data']);
    return AppTransactionListResponse(
      transactions: ApiParser.mapList(
        data['transactions'],
      ).map(AppTransaction.fromJson).toList(),
      pagination: PaginationMeta.fromJson(ApiParser.map(data['pagination'])),
    );
  }
}

List<String> _stringList(dynamic value) {
  if (value is! List) return <String>[];
  return value
      .map((item) => item.toString().trim())
      .where((item) => item.isNotEmpty)
      .toList();
}
