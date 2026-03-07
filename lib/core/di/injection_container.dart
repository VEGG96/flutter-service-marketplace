import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

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

  if (!sl.isRegistered<FirebaseStorage>()) {
    sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  }

  if (!sl.isRegistered<ImagePicker>()) {
    sl.registerLazySingleton<ImagePicker>(() => ImagePicker());
  }

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(firebaseAuth: sl(), firebaseFirestore: sl()),
    );
  }

  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(
      () => FirebaseProfileRepository(
        firebaseAuth: sl(),
        firebaseFirestore: sl(),
        firebaseStorage: sl(),
        imagePicker: sl(),
      ),
    );
  }

  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl()));
  }

  if (!sl.isRegistered<ProfileBloc>()) {
    sl.registerFactory<ProfileBloc>(() => ProfileBloc(profileRepository: sl()));
  }
}
