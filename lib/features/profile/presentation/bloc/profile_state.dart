import 'package:equatable/equatable.dart';

import '../../domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  final ProfileEntity? profile;
  final bool isLoading;
  final bool isSaving;
  final bool isUploadingImage;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.isUploadingImage = false,
    this.errorMessage,
    this.successMessage,
  });

  factory ProfileState.initial() => const ProfileState(isLoading: true);

  ProfileState copyWith({
    ProfileEntity? profile,
    bool? isLoading,
    bool? isSaving,
    bool? isUploadingImage,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    profile,
    isLoading,
    isSaving,
    isUploadingImage,
    errorMessage,
    successMessage,
  ];
}
