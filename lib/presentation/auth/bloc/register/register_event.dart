import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/request/auth/register_request_model.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final RegisterRequestModel requestModel;

  const RegisterRequested({required this.requestModel});

  @override
  List<Object?> get props => [requestModel];
}
