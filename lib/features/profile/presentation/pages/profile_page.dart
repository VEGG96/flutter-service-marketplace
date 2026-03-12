import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _serviceAreaController = TextEditingController();
  final TextEditingController _specialtiesController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();

  late final ProfileBloc _profileBloc;
  bool _didHydrateForm = false;

  @override
  void initState() {
    super.initState();
    _profileBloc = sl<ProfileBloc>()..add(ProfileStarted());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _businessNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _serviceAreaController.dispose();
    _specialtiesController.dispose();
    _hourlyRateController.dispose();
    _profileBloc.close();
    super.dispose();
  }

  void _hydrateForm(ProfileEntity profile) {
    if (_didHydrateForm) return;

    _fullNameController.text = profile.fullName;
    _businessNameController.text = profile.businessName;
    _phoneController.text = profile.phone;
    _cityController.text = profile.city;
    _addressController.text = profile.address;
    _bioController.text = profile.bio;
    _serviceAreaController.text = profile.serviceArea;
    _specialtiesController.text = profile.specialties.join(', ');
    _hourlyRateController.text = profile.hourlyRate.toStringAsFixed(0);
    _didHydrateForm = true;
  }

  void _saveProfile() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _profileBloc.add(
      ProfileSaveRequested(
        ProfileSaveInput(
          fullName: _fullNameController.text,
          businessName: _businessNameController.text,
          phone: _phoneController.text,
          city: _cityController.text,
          address: _addressController.text,
          bio: _bioController.text,
          serviceArea: _serviceAreaController.text,
          specialties: _specialtiesController.text
              .split(',')
              .map((String item) => item.trim())
              .where((String item) => item.isNotEmpty)
              .toList(),
          hourlyRate: double.tryParse(_hourlyRateController.text) ?? 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>.value(
      value: _profileBloc,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (BuildContext context, ProfileState state) {
          if (state.profile != null) {
            _hydrateForm(state.profile!);
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            _profileBloc.add(ProfileMessageConsumed());
          }

          if (state.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            _profileBloc.add(ProfileMessageConsumed());
          }
        },
        builder: (BuildContext context, ProfileState state) {
          if (state.isLoading && state.profile == null) {
            return Scaffold(
              body: LoadingWidget(
                isExpanded: true,
                message: AppStrings.loadingProfile,
              ),
            );
          }

          if (state.profile == null) {
            return Scaffold(
              appBar: AppBar(title: const Text(AppStrings.myProfile)),
              body: AppErrorWidget(
                message: AppStrings.profileLoadError,
                onRetry: () => _profileBloc.add(ProfileStarted()),
              ),
            );
          }

          final ProfileEntity profile = state.profile!;

          return Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.myProfile),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _ProfileHeader(
                      profile: profile,
                      isUploadingImage: state.isUploadingImage,
                      onUploadImage: () =>
                          _profileBloc.add(ProfileImageUploadRequested()),
                    ),
                    const SizedBox(height: 18),
                    _ReadOnlyInfoTile(label: AppStrings.email, value: profile.email),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _fullNameController,
                      validator: (String? value) =>
                          Validators.requiredField(
                            value,
                            fieldName: AppStrings.name,
                          ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.fullName,
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),

                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.phone,
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cityController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.city,
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.address,
                        prefixIcon: Icon(Icons.pin_drop_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _serviceAreaController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.serviceAreaLabel,
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _hourlyRateController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.hourlyRate,
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _specialtiesController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.specialties,
                        hintText: 'Ej: plomería, electricidad, pintura',
                        prefixIcon: Icon(Icons.list_alt_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 4,
                      maxLength: 250,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        labelText: AppStrings.aboutMe,
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.fromLTRB(
                          0,
                          18,
                          12,
                          12,
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 40,
                        ),
                        prefixIcon: Transform.translate(
                          offset: const Offset(0, -36),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
                            child: Icon(Icons.info_outline_rounded),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: AppStrings.saveProfile,
                      icon: Icons.save_outlined,
                      isLoading: state.isSaving,
                      onPressed: _saveProfile,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ProfileEntity profile;
  final bool isUploadingImage;
  final VoidCallback onUploadImage;

  const _ProfileHeader({
    required this.profile,
    required this.isUploadingImage,
    required this.onUploadImage,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = profile.profileImageUrl.trim().isNotEmpty;

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 56,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: hasImage
                  ? NetworkImage(profile.profileImageUrl)
                  : null,
              child: hasImage
                  ? null
                  : Text(
                      profile.initials,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Material(
                color: Theme.of(context).colorScheme.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: isUploadingImage ? null : onUploadImage,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: isUploadingImage
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.photo_camera_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          profile.fullName.trim().isEmpty
              ? AppStrings.completeYourProfile
              : profile.fullName,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ReadOnlyInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyInfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.verified_user_outlined),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
