import 'package:dartchat/models/user_chat.dart';
import 'package:dartchat/service_locator.dart';
import 'package:dartchat/services/storage_service/storage_repository.dart';
import 'package:flutter/foundation.dart';

abstract class AuthenticationRepository {
 // final StorageRepository storageRepository = serviceLocator<StorageRepository>();
  Future<String> signIn({@required String email, @required String password});
  Future<UserChat> signUp({
    @required String username,
    @required String email,
    @required String password,
  });
  Future<void> logout();
  Future<String> isSignIn();
  Future<String> getUserID();
}
