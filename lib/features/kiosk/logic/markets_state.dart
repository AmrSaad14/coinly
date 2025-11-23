import 'package:equatable/equatable.dart';
import '../data/models/market_model.dart';

abstract class MarketsState extends Equatable {
  const MarketsState();

  @override
  List<Object> get props => [];
}

class MarketsInitial extends MarketsState {}

class MarketsLoading extends MarketsState {}

class MarketsLoaded extends MarketsState {
  final List<MarketModel> markets;

  const MarketsLoaded(this.markets);

  @override
  List<Object> get props => [markets];
}

class MarketsError extends MarketsState {
  final String message;

  const MarketsError(this.message);

  @override
  List<Object> get props => [message];
}


