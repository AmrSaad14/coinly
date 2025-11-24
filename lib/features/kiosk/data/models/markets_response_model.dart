import 'package:equatable/equatable.dart';
import 'market_model.dart';

class MarketsResponseModel extends Equatable {
  final List<MarketModel> records;
  final MarketsMetadata metadata;

  const MarketsResponseModel({
    required this.records,
    required this.metadata,
  });

  factory MarketsResponseModel.fromJson(Map<String, dynamic> json) {
    return MarketsResponseModel(
      records: (json['records'] as List<dynamic>)
          .map((item) => MarketModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      metadata: MarketsMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'records': records.map((record) => record.toJson()).toList(),
      'metadata': metadata.toJson(),
    };
  }

  @override
  List<Object> get props => [records, metadata];
}

class MarketsMetadata extends Equatable {
  final int count;
  final int page;
  final int pages;
  final int limit;

  const MarketsMetadata({
    required this.count,
    required this.page,
    required this.pages,
    required this.limit,
  });

  factory MarketsMetadata.fromJson(Map<String, dynamic> json) {
    return MarketsMetadata(
      count: json['count'] as int,
      page: json['page'] as int,
      pages: json['pages'] as int,
      limit: json['limit'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'page': page,
      'pages': pages,
      'limit': limit,
    };
  }

  @override
  List<Object> get props => [count, page, pages, limit];
}



