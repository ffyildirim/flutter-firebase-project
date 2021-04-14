import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meet_app/locator.dart';
import 'package:meet_app/models/user_model.dart';
import 'package:meet_app/repositories/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository _userRepository = locator<UserRepository>();

  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is CheckAuthentication) {
      yield* _mapCheckAuthenticationEventToState();
    }
    if (event is SignInAnonymous) {
      yield* _mapAnonymousEventToState();
    }
    if (event is SignInViaFacebook) {
      yield* _mapFacebookLoginEventToState();
    }
    if (event is SignOut) {
      yield* _mapSignOutEventToState();
    }
    if (event is SignUpEmailAndPassword) {
      yield* _mapRegisterationEventToState(event.email, event.password);
    }
    if (event is LoginEmailAndPassword) {
      yield* _mapLoginViaEmailEventToState(event.email, event.password);
    }
  }

  Stream<AuthenticationState> _mapCheckAuthenticationEventToState() async* {
    final _myCurrentUser = await _userRepository.getCurrentUser();

    if (_myCurrentUser == null) {
      debugPrint(
          "AUTHENTICATION BLOK | _mapCheckAuthenticationEventToState HATA: user is null...");
      yield AuthenticationFailure();
    } else if (_myCurrentUser != null) {
      yield AuthenticationSuccess(_myCurrentUser);
    }
  }

  Stream<AuthenticationState> _mapAnonymousEventToState() async* {
    try {
      final anonymousUser = await _userRepository.getSignInAnonimously();
      yield AuthenticationSuccess(anonymousUser);
    } catch (e) {
      debugPrint("AUTHENTICATION BLOK | _mapAnonymousEventToState HATA");
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapFacebookLoginEventToState() async* {
    try {
      final facebookUser = await _userRepository.getSignInWithFacebook();
      if (facebookUser != null) {
        await _userRepository.getRegisterUser(facebookUser).then((value) {
          if (value) {
            debugPrint("FACEBOOK REGİSTERATİON SUCCESS");
          } else {
            debugPrint("FACEBOOK REGİSTERATİON FAİLURE");
          }
        });
        yield AuthenticationSuccess(facebookUser);
      } else {
        debugPrint("FACEBOOK GİRİŞ BAŞARISIZ BLOK 2");
        yield AuthenticationFailure();
      }
    } catch (e) {
      debugPrint("FACEBOOK GİRİŞ BAŞARISIZ BLOK " + e);
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapSignOutEventToState() async* {
    final signOut = await _userRepository.getSignOut();
    if (signOut) {
      yield SignOutSuccess();
    } else {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapRegisterationEventToState(
      String email, String password) async* {
    try {
      final _user = await _userRepository.getSignUpVieEmail(email, password);
      final verification = await _userRepository.getRegisterUser(_user);
      if (verification) {
      } else {
        debugPrint("FİRESTORE REGISTERATION FAİLURE BLOC");
      }
      yield AuthenticationSuccess(_user);
    } catch (e) {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapLoginViaEmailEventToState(
      String email, String password) async* {
    try {
      if (email != null) {
        final _user = await _userRepository.getLoginVieEmail(email, password);
        yield AuthenticationSuccess(_user);
      } else {
        yield AuthenticationFailure();
      }
    } catch (e) {
      yield AuthenticationFailure();
    }
  }
}
