// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponseModel _$TransactionResponseModelFromJson(
        Map<String, dynamic> json) =>
    TransactionResponseModel(
      message: json['message'] as String,
      transaction: json['transaction'] as Map<String, dynamic>?,
      workerNewBalance: (json['worker_new_balance'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionResponseModelToJson(
        TransactionResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'transaction': instance.transaction,
      'worker_new_balance': instance.workerNewBalance,
    };
