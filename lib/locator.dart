import 'package:get_it/get_it.dart';
import 'package:meet_app/firebase_services/cloud_firestore_service.dart';
import 'package:meet_app/firebase_services/dynamic_link_service.dart';
import 'package:meet_app/firebase_services/firebase_auth_service.dart';
import 'package:meet_app/repositories/user_repository.dart';

final locator = GetIt.asNewInstance();

void setUpLocator() {
  locator.registerLazySingleton<UserRepository>(() => UserRepository());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => CloudFirestoreService());
  locator.registerLazySingleton(() => DynamicLinkService());
}
