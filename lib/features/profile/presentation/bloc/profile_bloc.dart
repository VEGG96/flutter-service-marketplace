import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/profile_repository.dart';
import '../../models/profile_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository,
      super(ProfileState.initial()) {
    on<ProfileStarted>(_onProfileStarted);
    on<ProfileSaveRequested>(_onProfileSaveRequested);
    on<ProfileImageUploadRequested>(_onProfileImageUploadRequested);
    on<ProfileMessageConsumed>(_onProfileMessageConsumed);
  }

  Future<void> _onProfileStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));

    await emit.forEach<ProfileModel>(
      _profileRepository.watchProfile(),
      onData: (ProfileModel profile) {
        return state.copyWith(
          profile: profile,
          isLoading: false,
          clearError: true,
        );
      },
      onError: (Object error, StackTrace stackTrace) {
        return state.copyWith(
          isLoading: false,
          isSaving: false,
          isUploadingImage: false,
          errorMessage: _formatErrorMessage(error),
        );
      },
    );
  }

  Future<void> _onProfileSaveRequested(
    ProfileSaveRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.profile == null) {
      emit(
        state.copyWith(
          errorMessage: 'No se pudo cargar el perfil',
          isSaving: false,
        ),
      );
      return;
    }

    final ProfileModel updatedProfile = state.profile!.copyWith(
      fullName: event.input.fullName.trim(),
      businessName: event.input.businessName.trim(),
      phone: event.input.phone.trim(),
      city: event.input.city.trim(),
      address: event.input.address.trim(),
      bio: event.input.bio.trim(),
    );

    emit(state.copyWith(isSaving: true, clearError: true, clearSuccess: true));

    try {
      await _profileRepository.saveProfile(updatedProfile);
      emit(
        state.copyWith(
          isSaving: false,
          successMessage: 'Perfil actualizado correctamente',
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: _formatErrorMessage(e),
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> _onProfileImageUploadRequested(
    ProfileImageUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isUploadingImage: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      await _profileRepository.uploadProfileImageFromGallery();
      emit(
        state.copyWith(
          isUploadingImage: false,
          successMessage: 'Imagen de perfil actualizada',
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isUploadingImage: false,
          errorMessage: _formatErrorMessage(e),
          clearSuccess: true,
        ),
      );
    }
  }

  void _onProfileMessageConsumed(
    ProfileMessageConsumed event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }

  String _formatErrorMessage(Object error) {
    final String message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    return message;
  }
}
