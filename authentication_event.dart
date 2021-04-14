part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthentication extends AuthenticationEvent {}

class SignInAnonymous extends AuthenticationEvent {}

class SignInViaFacebook extends AuthenticationEvent {}

class SignOut extends AuthenticationEvent {}

class SignUpEmailAndPassword extends AuthenticationEvent {
  final String email;
  final String password;

  SignUpEmailAndPassword({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}

class LoginEmailAndPassword extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEmailAndPassword({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
