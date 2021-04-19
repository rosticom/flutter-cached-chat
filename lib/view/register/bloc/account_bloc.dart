import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartchat/models/user_chat.dart';
import 'package:dartchat/services/authentication_service/authentication_repository.dart';
import 'package:dartchat/services/storage_service/storage_repository.dart';
import 'package:dartchat/utils/failure.dart';
import 'package:dartchat/utils/functions.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthenticationRepository authImpl;
  final StorageRepository storageRepository;
  AccountBloc({@required this.storageRepository, @required this.authImpl})
      : super(RegisterInitial());
  String userId;
  @override
  Stream<AccountState> mapEventToState(
    AccountEvent event,
  ) async* {
    if (event is IsSignedInEvent) {
      yield* handleIsSignInEvent();
    } else if (event is SigninEvent) {
      yield* handleSigninEvent(event);
    } else if (event is SignupEvent) {
      yield* handleSignupEvent(event);
    } else if (event is EditAccountEvent) {
      yield* handleEditAccountEvent(event);
    } else if (event is LogOutEvent) {
      yield* handleLogOutEvent();
    } else if (event is FetchProfileEvent) {
      yield* handleFetchProfileEvent();
    }
  }

  Stream<AccountState> handleIsSignInEvent() async* {
    try {
      final userId = await authImpl.isSignIn();
      UserChat user = await storageRepository.fetchProfileUser(userId);
      yield RegisterSucceed(user);
      this.userId = userId;
    } on Failure catch (failure) {
      yield IsSignInFailed(failure);
    }
  }

  Stream<AccountState> handleSigninEvent(SigninEvent event) async* {
    yield SigninLoading();
    if (Platform.isAndroid && !await Functions.getNetworkStatus()) {
      yield SigninFailed(NetworkException());
    } else {
      try {
        yield SigninLoading();
        final userId =
            await authImpl.signIn(email: event.email, password: event.password);
        this.userId = userId;    
        UserChat user = await storageRepository.fetchProfileUser(userId);
        yield RegisterSucceed(user);
      } on Failure catch (failure) {
        yield SigninFailed(failure);
      }
    }
  }

  Stream<AccountState> handleSignupEvent(SignupEvent event) async* {
    yield SignupLoading();
    if (Platform.isAndroid && !await Functions.getNetworkStatus()) {
      yield SignupFailed(NetworkException());
    } else {
       final user = await authImpl.signUp(
            email: event.email,
            password: event.password,
            username: event.username
          );
      this.userId = user.userId;
      try {
        yield SignupLoading();
        await storageRepository.saveProfileUser(user);
        yield RegisterSucceed(user);
      } on Failure catch (failure) {
        yield SignupFailed(failure);
      }
    }
  }

  Stream<AccountState> handleEditAccountEvent(EditAccountEvent event) async* {
    yield EditAccountLoading();
    if (Platform.isAndroid && !await Functions.getNetworkStatus()) {
      yield EditAccountFailed(NetworkException());
    } else {
      yield EditAccountLoading();
      try {
        UserChat editedUser = await storageRepository.updateProfileNameAndImage(
            name: event.username,
            photo: event.photo,
            userId: event.userId,
            imgUrl: event.imgUrl);
        yield EditAccountSucceed(editedUser);
      } on Failure catch (failure) {
        EditAccountFailed(failure);
      }
    }
  }

  Stream<AccountState> handleFetchProfileEvent() async* {
    yield FetchProfileLoading();
    if (Platform.isAndroid && !await Functions.getNetworkStatus()) {
      yield FetchProfileFailed(NetworkException());
    } else {
      yield FetchProfileLoading();
      try {
        final user = await storageRepository
            .fetchProfileUser(await authImpl.getUserID());
        this.userId = user.userId;    
        yield FetchProfileSucceed(user);
      } on Failure catch (failure) {
        yield FetchProfileFailed(failure);
      }
    }
  }

  Stream<AccountState> handleLogOutEvent() async* {
    try {
      await authImpl.logout();
      yield LogOutSucceed();
    } on Failure catch (failure) {
      yield LogOutFailed(failure);
    }
  }
}
