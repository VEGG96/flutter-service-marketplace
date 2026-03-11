import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/content_skeletons.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/request_state_widget.dart';

class ServicesPage extends StatefulWidget {
  final bool isLoading;
  final String? errorMessage;
  final bool isEmpty;
  final VoidCallback? onRetry;

  const ServicesPage({
    super.key,
    this.isLoading = false,
    this.errorMessage,
    this.isEmpty = false,
    this.onRetry,
  });

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  int _selectedTab = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomTabTap(int index) {
    setState(() => _selectedTab = index);

    switch (index) {
      case 0:
      case 1:
        context.go(AppRoutes.services);
        break;
      case 2:
        context.go(AppRoutes.booking);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF11408B),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.build_rounded, size: 22),
            SizedBox(width: 8),
            Text('QuickFix'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.go(AppRoutes.profile),
            icon: const Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      body: RequestStateWidget(
        isLoading: widget.isLoading,
        errorMessage: widget.errorMessage,
        isEmpty: widget.isEmpty,
        onRetry: widget.onRetry,
        loading: const ServicesScreenSkeleton(),
        empty: EmptyStateWidget(
          title: 'No hay servicios disponibles',
          message: 'Intenta ajustar la busqueda o recargar la pantalla.',
          actionLabel: 'Recargar',
          onAction: widget.onRetry,
          icon: Icons.location_off_outlined,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth;
              final bool isDesktop = width >= 1080;
              final bool isTablet = width >= 760;

              final double contentMaxWidth = isDesktop ? 1200 : 940;
              final double horizontalPadding = isDesktop ? 24 : 16;
              final double mapHeight = isDesktop ? 320 : (isTablet ? 252 : 194);

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      14,
                      horizontalPadding,
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _SearchBar(controller: _searchController),
                        const SizedBox(height: 12),
                        _MapHero(
                          height: mapHeight,
                          onScheduleTap: () => context.go(AppRoutes.booking),
                        ),
                        const SizedBox(height: 22),
                        if (isDesktop)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: _PopularServicesSection(
                                  columns: 3,
                                  onTap: (String id) => context.push(
                                    '${AppRoutes.serviceDetail}?id=$id',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 5,
                                child: _NearbyProsSection(
                                  columns: 1,
                                  onViewProfile: () =>
                                      context.go(AppRoutes.profile),
                                ),
                              ),
                            ],
                          )
                        else ...<Widget>[
                          _PopularServicesSection(
                            columns: isTablet ? 3 : 2,
                            onTap: (String id) => context.push(
                              '${AppRoutes.serviceDetail}?id=$id',
                            ),
                          ),
                          const SizedBox(height: 18),
                          _NearbyProsSection(
                            columns: isTablet ? 2 : 1,
                            onViewProfile: () => context.go(AppRoutes.profile),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: _onBottomTabTap,
        selectedItemColor: const Color(0xFF11408B),
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_rounded),
            label: 'Servicios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Buscar servicios, profesionales...',
          prefixIcon: Icon(Icons.search_rounded),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}

class _MapHero extends StatelessWidget {
  final VoidCallback onScheduleTap;
  final double height;

  const _MapHero({required this.onScheduleTap, required this.height});

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = _nearbyPros
        .map(
          (_Professional pro) => Marker(
            markerId: MarkerId(pro.initials),
            position: pro.location,
            infoWindow: InfoWindow(
              title: pro.name,
              snippet: '${pro.category} • ${pro.rating.toStringAsFixed(1)} ★',
            ),
          ),
        )
        .toSet();

    final bool compact = height < 230;

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _defaultMapCenter,
                  zoom: 12.6,
                ),
                markers: markers,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: InkWell(
                onTap: onScheduleTap,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  width: compact ? 86 : 108,
                  height: compact ? 72 : 84,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8A00),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.event_note_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Agendar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Servicio',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 30 / 1.5,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1E1E1E),
      ),
    );
  }
}

class _PopularServicesSection extends StatelessWidget {
  final int columns;
  final ValueChanged<String> onTap;

  const _PopularServicesSection({required this.columns, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionTitle(title: 'Servicios Populares'),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _popularServices.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 176,
          ),
          itemBuilder: (BuildContext context, int index) {
            final _ServiceCategory item = _popularServices[index];
            return _ServiceCategoryCard(
              item: item,
              onTap: () => onTap(item.id),
            );
          },
        ),
      ],
    );
  }
}

class _NearbyProsSection extends StatelessWidget {
  final int columns;
  final VoidCallback onViewProfile;

  const _NearbyProsSection({
    required this.columns,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionTitle(title: 'Profesionales Cerca'),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _nearbyPros.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 178,
          ),
          itemBuilder: (BuildContext context, int index) {
            final _Professional item = _nearbyPros[index];
            return _ProfessionalCard(item: item, onViewProfile: onViewProfile);
          },
        ),
      ],
    );
  }
}

class _ServiceCategoryCard extends StatelessWidget {
  final _ServiceCategory item;
  final VoidCallback onTap;

  const _ServiceCategoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6E6E6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(item.icon, size: 30, color: const Color(0xFF2C66B8)),
            const SizedBox(height: 14),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              item.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF666666), fontSize: 13),
            ),
            const Spacer(),
            Row(
              children: <Widget>[
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFF5B400),
                  size: 18,
                ),
                const SizedBox(width: 3),
                Text(
                  item.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  final _Professional item;
  final VoidCallback onViewProfile;

  const _ProfessionalCard({required this.item, required this.onViewProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFDDE7F7),
                child: Text(
                  item.initials,
                  style: const TextStyle(
                    color: Color(0xFF2C66B8),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF5B400),
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF11A36A).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Disponible',
              style: TextStyle(
                color: Color(0xFF0E8B5A),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: onViewProfile,
              child: const Text(
                'Ver Perfil',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const LatLng _defaultMapCenter = LatLng(25.6866, -100.3161);

const List<_ServiceCategory> _popularServices = <_ServiceCategory>[
  _ServiceCategory(
    id: 'plomeria',
    name: 'Plomeria',
    subtitle: 'Urgencias 24/7',
    rating: 4.8,
    icon: Icons.plumbing_rounded,
  ),
  _ServiceCategory(
    id: 'limpieza',
    name: 'Limpieza',
    subtitle: 'Hogar y Oficina',
    rating: 4.9,
    icon: Icons.cleaning_services_rounded,
  ),
  _ServiceCategory(
    id: 'electricista',
    name: 'Electricista',
    subtitle: 'Instalaciones',
    rating: 4.7,
    icon: Icons.lightbulb_outline_rounded,
  ),
];

const List<_Professional> _nearbyPros = <_Professional>[
  _Professional(
    name: 'Carlos Gomez',
    category: 'Plomero',
    rating: 4.9,
    initials: 'CG',
    location: LatLng(25.6956, -100.3376),
  ),
  _Professional(
    name: 'Sofia Torres',
    category: 'Electricista',
    rating: 4.8,
    initials: 'ST',
    location: LatLng(25.6808, -100.3152),
  ),
];

class _ServiceCategory {
  final String id;
  final String name;
  final String subtitle;
  final double rating;
  final IconData icon;

  const _ServiceCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.icon,
  });
}

class _Professional {
  final String name;
  final String category;
  final double rating;
  final String initials;
  final LatLng location;

  const _Professional({
    required this.name,
    required this.category,
    required this.rating,
    required this.initials,
    required this.location,
  });
}
