import 'package:equatable/equatable.dart';

class ProfileSaveInput extends Equatable {
  final String fullName;
  final String businessName;
  final String phone;
  final String city;
  final String address;
  final String bio;
  final String serviceArea;
  final List<String> specialties;
  final double hourlyRate;

  const ProfileSaveInput({
    required this.fullName,
    required this.businessName,
    required this.phone,
    required this.city,
    required this.address,
    required this.bio,
    required this.serviceArea,
    required this.specialties,
    required this.hourlyRate,
  });

  @override
  List<Object?> get props => <Object?>[
    fullName,
    businessName,
    phone,
    city,
    address,
    bio,
    serviceArea,
    specialties,
    hourlyRate,
  ];
}

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class ProfileStarted extends ProfileEvent {}

class ProfileSaveRequested extends ProfileEvent {
  final ProfileSaveInput input;

  const ProfileSaveRequested(this.input);

  @override
  List<Object?> get props => <Object?>[input];
}

class ProfileImageUploadRequested extends ProfileEvent {}

class ProfileMessageConsumed extends ProfileEvent {}
