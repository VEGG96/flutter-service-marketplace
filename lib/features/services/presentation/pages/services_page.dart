import 'package:flutter/material.dart';
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
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _SearchBar(controller: _searchController),
                      const SizedBox(height: 12),
                      _MapHero(
                        onScheduleTap: () => context.go(AppRoutes.booking),
                      ),
                      const SizedBox(height: 18),
                      _SectionTitle(title: 'Populare services'),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 124,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _popularServices.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (BuildContext context, int index) {
                            final _ServiceCategory item =
                                _popularServices[index];
                            return _ServiceCategoryCard(
                              item: item,
                              onTap: () => context.push(
                                '${AppRoutes.serviceDetail}?id=${item.id}',
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      _SectionTitle(title: 'Profesionales Cerca'),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 154,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _nearbyPros.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (BuildContext context, int index) {
                            final _Professional item = _nearbyPros[index];
                            return _ProfessionalCard(
                              item: item,
                              onViewProfile: () =>
                                  context.go(AppRoutes.profile),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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

  const _MapHero({required this.onScheduleTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 194,
      decoration: BoxDecoration(
        color: const Color(0xFFE5EAF0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: CustomPaint(painter: _MapGridPainter())),
            ..._pins,
            const Center(child: _CurrentLocationPin()),
            Positioned(
              right: 12,
              bottom: 12,
              child: InkWell(
                onTap: onScheduleTap,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  width: 86,
                  height: 66,
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
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Servicio',
                        style: TextStyle(color: Colors.white, fontSize: 11),
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

class _CurrentLocationPin extends StatelessWidget {
  const _CurrentLocationPin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2D76D2).withValues(alpha: 0.2),
      ),
      child: Center(
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2D76D2),
            border: Border.all(color: Colors.white, width: 2),
          ),
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
        width: 138,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6E6E6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(item.icon, size: 34, color: const Color(0xFF2C66B8)),
            const Spacer(),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              item.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF666666), fontSize: 14),
            ),
            const SizedBox(height: 2),
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
      width: 258,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFDDE7F7),
                child: Text(
                  item.initials,
                  style: const TextStyle(
                    color: Color(0xFF2C66B8),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF11A36A,
                            ).withValues(alpha: 0.12),
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
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category,
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 14,
                      ),
                    ),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint bgPaint = Paint()..color = const Color(0xFFE8EDF3);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final Paint road = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;

    final Paint roadThin = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7;

    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.22),
      Offset(size.width * 0.9, size.height * 0.22),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.2, size.height),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.55, 0),
      Offset(size.width * 0.55, size.height),
      roadThin,
    );
    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.55),
      Offset(size.width * 0.95, size.height * 0.74),
      roadThin,
    );
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.95),
      Offset(size.width * 0.75, size.height * 0.1),
      roadThin,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapPin extends StatelessWidget {
  final double left;
  final double top;

  const _MapPin({required this.left, required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFF2C66B8),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.build_rounded, size: 14, color: Colors.white),
      ),
    );
  }
}

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
  ),
  _Professional(
    name: 'Sofia Torres',
    category: 'Electricista',
    rating: 4.8,
    initials: 'ST',
  ),
];

const List<Widget> _pins = <Widget>[
  _MapPin(left: 54, top: 44),
  _MapPin(left: 130, top: 26),
  _MapPin(left: 98, top: 90),
  _MapPin(left: 220, top: 44),
  _MapPin(left: 244, top: 112),
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

  const _Professional({
    required this.name,
    required this.category,
    required this.rating,
    required this.initials,
  });
}
