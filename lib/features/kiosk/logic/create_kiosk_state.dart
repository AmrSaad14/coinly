import 'package:equatable/equatable.dart';

abstract class CreateKioskState extends Equatable {
  const CreateKioskState();

  @override
  List<Object> get props => [];
}

class CreateKioskInitial extends CreateKioskState {}

class CreateKioskLoading extends CreateKioskState {}

class CreateKioskSuccess extends CreateKioskState {}

class CreateKioskError extends CreateKioskState {
  final String message;

  const CreateKioskError(this.message);

  @override
  List<Object> get props => [message];
}

