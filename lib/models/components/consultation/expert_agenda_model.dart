import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/api/pagination_meta.dart';

class ExpertAgendaProduct {
  final String uuid;
  final String type;
  final int duration;
  final double price;

  const ExpertAgendaProduct({
    required this.uuid,
    required this.type,
    required this.duration,
    required this.price,
  });

  factory ExpertAgendaProduct.fromJson(JsonMap json) {
    return ExpertAgendaProduct(
      uuid: ApiParser.string(json['uuid']),
      type: ApiParser.string(json['type']),
      duration: ApiParser.integer(json['duration']),
      price: ApiParser.decimal(json['price']),
    );
  }
}

class ExpertAgendaUser {
  final String uuid;
  final String name;
  final String email;

  const ExpertAgendaUser({
    required this.uuid,
    required this.name,
    required this.email,
  });

  factory ExpertAgendaUser.fromJson(JsonMap json) {
    return ExpertAgendaUser(
      uuid: ApiParser.string(json['uuid']),
      name: ApiParser.string(json['name']),
      email: ApiParser.string(json['email']),
    );
  }
}

class ExpertAgenda {
  final String uuid;
  final String type;
  final double rating;
  final DateTime? date;
  final String? zoomLink;
  final ExpertAgendaProduct? product;
  final ExpertAgendaUser? user;

  const ExpertAgenda({
    required this.uuid,
    required this.type,
    required this.rating,
    required this.date,
    required this.zoomLink,
    required this.product,
    required this.user,
  });

  factory ExpertAgenda.fromJson(JsonMap json) {
    final productJson = ApiParser.map(json['product']);
    final userJson = ApiParser.map(json['user']);
    return ExpertAgenda(
      uuid: ApiParser.string(json['uuid']),
      type: ApiParser.string(json['type']),
      rating: ApiParser.decimal(json['rating']),
      date: ApiParser.dateTime(json['date']),
      zoomLink: ApiParser.nullableString(json['zoom_link']),
      product: productJson.isEmpty
          ? null
          : ExpertAgendaProduct.fromJson(productJson),
      user: userJson.isEmpty ? null : ExpertAgendaUser.fromJson(userJson),
    );
  }
}

class ExpertAgendaListResponse {
  final List<ExpertAgenda> consultations;
  final PaginationMeta pagination;

  const ExpertAgendaListResponse({
    required this.consultations,
    required this.pagination,
  });

  factory ExpertAgendaListResponse.fromJson(JsonMap json) {
    final data = ApiParser.map(json['data']);
    return ExpertAgendaListResponse(
      consultations: ApiParser.mapList(
        data['consultations'],
      ).map(ExpertAgenda.fromJson).toList(),
      pagination: PaginationMeta.fromJson(ApiParser.map(data['pagination'])),
    );
  }
}
