import 'package:equatable/equatable.dart';

class AuthResponseEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
