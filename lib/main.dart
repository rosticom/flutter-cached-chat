
import 'dart:io';
import 'package:dartchat/bloc_observer.dart';
import 'package:dartchat/services/hive_service/start_hive.dart';
import 'package:dartchat/view/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_app.dart';
import 'package:flutter/material.dart';
import 'package:dartchat/service_locator.dart';
import 'package:permission/permission.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.requestPermissions([PermissionName.Storage])
      .then((_) => startHive());
  serviceLoctorSetup();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: deviceBottomColor, // navigation bar color
    statusBarColor: headerDevice,
    systemNavigationBarIconBrightness: Brightness.dark// status bar color
  ));



  runApp(MyApp());
}
