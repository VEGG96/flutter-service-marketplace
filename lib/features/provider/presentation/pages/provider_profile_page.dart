import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';

class ProviderProfilePage extends StatelessWidget {
  final String providerId;

  const ProviderProfilePage({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    final _ProviderProfile provider =
        _providerCatalog[providerId] ?? _providerCatalog.values.first;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF11408B),
        title: Text(provider.name),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isWide = constraints.maxWidth >= 980;
            final double contentMaxWidth = isWide ? 1120 : 720;

            final Widget details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ProviderHero(provider: provider),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Sobre el profesional',
                  child: _AboutBlock(provider: provider),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Servicios destacados',
                  child: _ServicesList(services: provider.services),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Resenas recientes',
                  child: _ReviewsList(reviews: provider.reviews),
                ),
                const SizedBox(height: 16),
                if (!isWide)
                  _ContactCard(
                    provider: provider,
                    onMessage: () => context.go(AppRoutes.chat),
                    onBook: () => context.go(AppRoutes.booking),
                  ),
              ],
            );

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(flex: 7, child: details),
                            const SizedBox(width: 18),
                            Expanded(
                              flex: 4,
                              child: _ContactCard(
                                provider: provider,
                                onMessage: () => context.go(AppRoutes.chat),
                                onBook: () => context.go(AppRoutes.booking),
                              ),
                            ),
                          ],
                        )
                      : details,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProviderHero extends StatelessWidget {
  final _ProviderProfile provider;

  const _ProviderHero({required this.provider});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(
                  provider.initials,
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
                      provider.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.title,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _ScoreBadge(
                rating: provider.rating,
                reviews: provider.reviewCount,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _Pill(
                icon: Icons.work_outline_rounded,
                label: '${provider.completedJobs}+ trabajos',
              ),
              _Pill(
                icon: Icons.schedule_rounded,
                label: 'Respuesta ${provider.responseTime}',
              ),
              _Pill(
                icon: Icons.place_rounded,
                label: provider.city,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutBlock extends StatelessWidget {
  final _ProviderProfile provider;

  const _AboutBlock({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          provider.bio,
          style: const TextStyle(
            fontSize: 14.5,
            height: 1.5,
            color: Color(0xFF2B2B2B),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.specialties
              .map(
                (String item) => _InfoChip(
                  icon: Icons.check_circle_rounded,
                  label: item,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ServicesList extends StatelessWidget {
  final List<_ProviderService> services;

  const _ServicesList({required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: services
          .map(
            (_ProviderService service) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ServiceTile(service: service),
            ),
          )
          .toList(),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final _ProviderService service;

  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(service.icon, color: const Color(0xFF2C66B8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  service.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${service.category} • ${service.duration}',
                  style: const TextStyle(
                    color: Color(0xFF6B6B6B),
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFF5B400),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      service.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                _formatCurrency(service.price),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 34,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8A00),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => context.push(
                    '${AppRoutes.serviceDetail}?id=${service.id}',
                  ),
                  child: const Text(
                    'Ver',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewsList extends StatelessWidget {
  final List<_ProviderReview> reviews;

  const _ReviewsList({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reviews
          .map(
            (_ProviderReview review) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ReviewTile(review: review),
            ),
          )
          .toList(),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final _ProviderReview review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  review.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF5B400),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(
              color: Color(0xFF2B2B2B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review.dateLabel,
            style: const TextStyle(
              color: Color(0xFF7A7A7A),
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final _ProviderProfile provider;
  final VoidCallback onMessage;
  final VoidCallback onBook;

  const _ContactCard({
    required this.provider,
    required this.onMessage,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            AppStrings.availability,
            style: TextStyle(
              color: Color(0xFF4B4B4B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.nextAvailability,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(label: AppStrings.responseTime, value: provider.responseTime),
          _InfoRow(label: AppStrings.averageRate, value: provider.averagePrice),
          const Divider(height: 24),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onBook,
              child: const Text(
                AppStrings.bookNow,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: onMessage,
              child: const Text(AppStrings.sendMessage),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final double rating;
  final int reviews;

  const _ScoreBadge({required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '$reviews resenas',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: const Color(0xFF2C66B8)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C66B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF4B4B4B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E1E1E),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatCurrency(double value) {
  return '\$${value.toStringAsFixed(0)}';
}

class _ProviderProfile {
  final String id;
  final String name;
  final String title;
  final String city;
  final String bio;
  final double rating;
  final int reviewCount;
  final int completedJobs;
  final String responseTime;
  final String nextAvailability;
  final String averagePrice;
  final String initials;
  final List<String> specialties;
  final List<_ProviderService> services;
  final List<_ProviderReview> reviews;

  const _ProviderProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.city,
    required this.bio,
    required this.rating,
    required this.reviewCount,
    required this.completedJobs,
    required this.responseTime,
    required this.nextAvailability,
    required this.averagePrice,
    required this.initials,
    required this.specialties,
    required this.services,
    required this.reviews,
  });
}

class _ProviderService {
  final String id;
  final String name;
  final String category;
  final String duration;
  final double price;
  final double rating;
  final IconData icon;

  const _ProviderService({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.price,
    required this.rating,
    required this.icon,
  });
}

class _ProviderReview {
  final String name;
  final double rating;
  final String comment;
  final String dateLabel;

  const _ProviderReview({
    required this.name,
    required this.rating,
    required this.comment,
    required this.dateLabel,
  });
}

const Map<String, _ProviderProfile> _providerCatalog =
    <String, _ProviderProfile>{
  'carlos-gomez': _ProviderProfile(
    id: 'carlos-gomez',
    name: 'Carlos Gomez',
    title: 'Plomero certificado',
    city: 'Monterrey, NL',
    bio:
        'Especialista en urgencias del hogar. Trabajo con garantia por escrito '
        'y materiales de primera para asegurar reparaciones duraderas.',
    rating: 4.9,
    reviewCount: 128,
    completedJobs: 280,
    responseTime: '30 min',
    nextAvailability: 'Disponible hoy 4:00 PM',
    averagePrice: '\$450',
    initials: 'CG',
    specialties: <String>[
      'Urgencias 24/7',
      'Instalaciones completas',
      'Diagnostico en sitio',
    ],
    services: <_ProviderService>[
      _ProviderService(
        id: 'plomeria',
        name: 'Plomeria inmediata',
        category: 'Urgencias del hogar',
        duration: '1-2 horas',
        price: 450,
        rating: 4.9,
        icon: Icons.plumbing_rounded,
      ),
    ],
    reviews: <_ProviderReview>[
      _ProviderReview(
        name: 'Laura Ruiz',
        rating: 5.0,
        comment:
            'Llegaron rapido y dejaron todo perfecto. Precio justo y sin sorpresas.',
        dateLabel: 'Hace 2 dias',
      ),
      _ProviderReview(
        name: 'Miguel Torres',
        rating: 4.8,
        comment:
            'Muy atentos y explicaron todo el problema antes de reparar.',
        dateLabel: 'Hace 1 semana',
      ),
    ],
  ),
  'sofia-torres': _ProviderProfile(
    id: 'sofia-torres',
    name: 'Sofia Torres',
    title: 'Especialista en limpieza',
    city: 'San Pedro, NL',
    bio:
        'Equipos fijos y checklist por estancia. Cuidamos cada detalle y damos '
        'seguimiento con fotos.',
    rating: 4.9,
    reviewCount: 92,
    completedJobs: 190,
    responseTime: '2 horas',
    nextAvailability: 'Disponible manana 9:00 AM',
    averagePrice: '\$650',
    initials: 'ST',
    specialties: <String>[
      'Limpieza profunda',
      'Hogar y oficina',
      'Checklist final',
    ],
    services: <_ProviderService>[
      _ProviderService(
        id: 'limpieza',
        name: 'Limpieza premium',
        category: 'Hogar y oficina',
        duration: '3-4 horas',
        price: 650,
        rating: 4.9,
        icon: Icons.cleaning_services_rounded,
      ),
    ],
    reviews: <_ProviderReview>[
      _ProviderReview(
        name: 'Valeria Salas',
        rating: 4.9,
        comment:
            'Muy puntuales y con buena comunicacion. El checklist ayuda bastante.',
        dateLabel: 'Hace 3 dias',
      ),
      _ProviderReview(
        name: 'Jorge Diaz',
        rating: 4.7,
        comment:
            'Resultado limpio y ordenado. Volveria a contratar.',
        dateLabel: 'Hace 2 semanas',
      ),
    ],
  ),
  'sofia-morales': _ProviderProfile(
    id: 'sofia-morales',
    name: 'Sofia Morales',
    title: 'Tecnica electricista',
    city: 'Monterrey, NL',
    bio:
        'Especialista en instalaciones residenciales con enfoque en seguridad y '
        'cumplimiento de normas.',
    rating: 4.7,
    reviewCount: 74,
    completedJobs: 210,
    responseTime: '1 hora',
    nextAvailability: 'Disponible hoy 6:30 PM',
    averagePrice: '\$520',
    initials: 'SM',
    specialties: <String>[
      'Tableros y circuitos',
      'Instalaciones nuevas',
      'Diagnostico electrico',
    ],
    services: <_ProviderService>[
      _ProviderService(
        id: 'electricista',
        name: 'Electricista experto',
        category: 'Instalaciones y reparaciones',
        duration: '1-3 horas',
        price: 520,
        rating: 4.7,
        icon: Icons.lightbulb_outline_rounded,
      ),
    ],
    reviews: <_ProviderReview>[
      _ProviderReview(
        name: 'Ricardo Leon',
        rating: 4.6,
        comment:
            'Resolvio el problema rapido y explico todo el proceso.',
        dateLabel: 'Hace 5 dias',
      ),
      _ProviderReview(
        name: 'Ana Cardenas',
        rating: 4.8,
        comment:
            'Muy profesional y ordenada. Quede tranquila con la instalacion.',
        dateLabel: 'Hace 3 semanas',
      ),
    ],
  ),
};
