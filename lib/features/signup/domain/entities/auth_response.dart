import 'package:equatable/equatable.dart';
import 'package:transportation_app/features/signup/domain/entities/user_entity.dart';

class AuthResponseEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final UserEntity user;

  const AuthResponseEntity({required this.accessToken, required this.refreshToken, required this.expiresAt, required this.user});
  
  @override
  List<Object?> get props => [accessToken,refreshToken];
  
}
