import 'package:sporky_maxi/models/api/api_parser.dart';

class ConsultationProductExpert {
  final String uuid;
  final String name;
  final String role;
  final double rating;
  final String? photo;

  const ConsultationProductExpert({
    required this.uuid,
    required this.name,
    required this.role,
    required this.rating,
    required this.photo,
  });

  factory ConsultationProductExpert.fromJson(JsonMap json) {
    return ConsultationProductExpert(
      uuid: ApiParser.string(json['uuid']),
      name: ApiParser.string(json['name']),
      role: ApiParser.string(json['role']),
      rating: ApiParser.decimal(json['rating']),
      photo: ApiParser.nullableString(json['photo']),
    );
  }
}

class ConsultationProduct {
  final String uuid;
  final String type;
  final int duration;
  final double price;
  final ConsultationProductExpert? expert;
  final DateTime? createdAt;

  const ConsultationProduct({
    required this.uuid,
    required this.type,
    required this.duration,
    required this.price,
    required this.expert,
    required this.createdAt,
  });

  factory ConsultationProduct.fromJson(JsonMap json) {
    final expertJson = ApiParser.map(json['expert']);
    return ConsultationProduct(
      uuid: ApiParser.string(json['uuid']),
      type: ApiParser.string(json['type']),
      duration: ApiParser.integer(json['duration']),
      price: ApiParser.decimal(json['price']),
      expert: expertJson.isEmpty
          ? null
          : ConsultationProductExpert.fromJson(expertJson),
      createdAt: ApiParser.dateTime(json['created_at']),
    );
  }
}

class ConsultationProductListResponse {
  final List<ConsultationProduct> products;

  const ConsultationProductListResponse({required this.products});

  factory ConsultationProductListResponse.fromJson(JsonMap json) {
    return ConsultationProductListResponse(
      products: ApiParser.mapList(
        json['data'],
      ).map(ConsultationProduct.fromJson).toList(),
    );
  }
}

class ConsultationCheckoutResponse {
  final String checkoutUrl;

  const ConsultationCheckoutResponse({required this.checkoutUrl});

  factory ConsultationCheckoutResponse.fromJson(JsonMap json) {
    final data = ApiParser.map(json['data']);
    return ConsultationCheckoutResponse(
      checkoutUrl: ApiParser.string(data['checkout_url']),
    );
  }
}
