import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  if (!sl.isRegistered<FirebaseAuth>()) {
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }

  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(firebaseAuth: sl()),
    );
  }

  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl()));
  }
}
