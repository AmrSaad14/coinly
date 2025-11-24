import 'package:equatable/equatable.dart';
import '../data/models/market_model.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object> get props => [];
}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final MarketModel market;

  const MarketLoaded(this.market);

  @override
  List<Object> get props => [market];
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object> get props => [message];
}



