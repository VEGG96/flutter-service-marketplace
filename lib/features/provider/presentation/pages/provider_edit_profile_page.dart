import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../../profile/domain/entities/profile_entity.dart';

class ProviderEditProfilePage extends StatefulWidget {
  const ProviderEditProfilePage({super.key});

  @override
  State<ProviderEditProfilePage> createState() => _ProviderEditProfilePageState();
}

class _ProviderEditProfilePageState extends State<ProviderEditProfilePage> {
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
            return const Scaffold(
              body: LoadingWidget(
                isExpanded: true,
                message: 'Cargando perfil...',
              ),
            );
          }

          if (state.profile == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Mi perfil')),
              body: AppErrorWidget(
                message: 'No fue posible cargar el perfil',
                onRetry: () => _profileBloc.add(ProfileStarted()),
              ),
            );
          }

          final ProfileEntity profile = state.profile!;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Editar perfil (Proveedor)'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _ProviderProfileHeader(profile: profile),
                    const SizedBox(height: 18),
                    _ReadOnlyInfoTile(label: 'Correo', value: profile.email),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _fullNameController,
                      validator: (String? value) =>
                          Validators.requiredField(value, fieldName: 'Nombre'),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _businessNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del negocio',
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cityController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Ciudad de operación',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Dirección',
                        prefixIcon: Icon(Icons.pin_drop_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _serviceAreaController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Zona de servicio',
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _hourlyRateController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Tarifa por hora',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _specialtiesController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Especialidades',
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
                        labelText: 'Sobre mis servicios',
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
                      label: 'Guardar cambios',
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

class _ProviderProfileHeader extends StatelessWidget {
  final ProfileEntity profile;

  const _ProviderProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF0F3A85), Color(0xFF2C66B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              profile.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  profile.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.businessName.isEmpty
                      ? 'Proveedor'
                      : profile.businessName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyInfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
