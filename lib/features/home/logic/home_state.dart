import 'package:equatable/equatable.dart';
import '../data/models/owner_data_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final OwnerDataModel ownerData;

  const HomeLoaded(this.ownerData);

  @override
  List<Object?> get props => [ownerData];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}






