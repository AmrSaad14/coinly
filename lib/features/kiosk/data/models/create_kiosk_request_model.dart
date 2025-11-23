import 'package:equatable/equatable.dart';
import 'market_model.dart';

class CreateKioskRequestModel extends Equatable {
  final MarketModel market;

  const CreateKioskRequestModel({required this.market});

  Map<String, dynamic> toJson() {
    return {
      'market': {
        'name': market.name,
        'kind': market.kind,
        'location': market.location,
      }
    };
  }

  @override
  List<Object> get props => [market];
}
