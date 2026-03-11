import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';

class ServiceDetailPage extends StatelessWidget {
  final String serviceId;

  const ServiceDetailPage({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final _ServiceDetail service =
        _serviceCatalog[serviceId] ?? _serviceCatalog.values.first;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF11408B),
        title: Text(service.name),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isWide = constraints.maxWidth >= 980;
            final double contentMaxWidth = isWide ? 1120 : 720;

            final Widget details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _HeroCard(service: service),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Resumen',
                  child: _SummaryBlock(service: service),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Que incluye',
                  child: _BulletedList(items: service.inclusions),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Sobre el profesional',
                  child: _ProviderCard(service: service),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Resenas recientes',
                  child: _ReviewsList(reviews: service.reviews),
                ),
                const SizedBox(height: 16),
                if (!isWide)
                  _BookingSummary(
                    service: service,
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
                              child: _BookingSummary(
                                service: service,
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

class _HeroCard extends StatelessWidget {
  final _ServiceDetail service;

  const _HeroCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 210),
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
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -40,
            top: -60,
            child: _GlowCircle(
              diameter: 160,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: _GlowCircle(
              diameter: 120,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _IconBadge(icon: service.icon),
              const SizedBox(height: 16),
              Text(
                service.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                service.category,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _Pill(
                    icon: Icons.star_rounded,
                    label:
                        '${service.rating.toStringAsFixed(1)} (${service.reviewCount})',
                  ),
                  _Pill(
                    icon: Icons.schedule_rounded,
                    label: 'Respuesta ${service.responseTime}',
                  ),
                  const _Pill(
                    icon: Icons.verified_rounded,
                    label: 'Garantia 30 dias',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryBlock extends StatelessWidget {
  final _ServiceDetail service;

  const _SummaryBlock({required this.service});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          service.description,
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
          children: <Widget>[
            _InfoChip(
              icon: Icons.timer_rounded,
              label: service.duration,
            ),
            _InfoChip(
              icon: Icons.place_rounded,
              label: service.location,
            ),
            const _InfoChip(
              icon: Icons.shield_rounded,
              label: 'Pago protegido',
            ),
            const _InfoChip(
              icon: Icons.payment_rounded,
              label: 'Pago seguro',
            ),
          ],
        ),
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final _ServiceDetail service;

  const _ProviderCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFDDE7F7),
              child: Text(
                service.providerInitials,
                style: const TextStyle(
                  color: Color(0xFF2C66B8),
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
                    service.providerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.providerTitle,
                    style: const TextStyle(
                      color: Color(0xFF5C5C5C),
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.push(
                '${AppRoutes.providerProfile}?id=${service.providerId}',
              ),
              child: const Text('Ver perfil'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          service.providerBio,
          style: const TextStyle(
            color: Color(0xFF2B2B2B),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            _InfoChip(
              icon: Icons.work_outline_rounded,
              label: '${service.completedJobs}+ trabajos',
            ),
            _InfoChip(
              icon: Icons.schedule_rounded,
              label: 'Responde ${service.responseTime}',
            ),
            const _InfoChip(
              icon: Icons.verified_user_rounded,
              label: 'Profesional verificado',
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewsList extends StatelessWidget {
  final List<_Review> reviews;

  const _ReviewsList({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reviews
          .map(
            (_Review review) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ReviewTile(review: review),
            ),
          )
          .toList(),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final _Review review;

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

class _BookingSummary extends StatelessWidget {
  final _ServiceDetail service;
  final VoidCallback onBook;

  const _BookingSummary({required this.service, required this.onBook});

  @override
  Widget build(BuildContext context) {
    const double fee = 35;
    final double total = service.price + fee;

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
            'Precio estimado',
            style: TextStyle(
              color: Color(0xFF4B4B4B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(service.price),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 12),
          _PriceRow(
            label: 'Servicio base',
            value: _formatCurrency(service.price),
          ),
          const _PriceRow(
            label: 'Tarifa plataforma',
            value: '\$35',
          ),
          const Divider(height: 24),
          _PriceRow(
            label: 'Total',
            value: _formatCurrency(total),
            emphasize: true,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onBook,
              child: const Text(
                'Agendar ahora',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Cancelacion gratis hasta 2 horas antes.',
            style: TextStyle(
              color: Color(0xFF7A7A7A),
              fontSize: 12.5,
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

class _BulletedList extends StatelessWidget {
  final List<String> items;

  const _BulletedList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (String item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF11A36A),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFF2B2B2B),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
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

class _IconBadge extends StatelessWidget {
  final IconData icon;

  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double diameter;
  final Color color;

  const _GlowCircle({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _PriceRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = TextStyle(
      fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
      color: emphasize ? const Color(0xFF1E1E1E) : const Color(0xFF4B4B4B),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: baseStyle)),
          Text(value, style: baseStyle),
        ],
      ),
    );
  }
}

String _formatCurrency(double value) {
  return '\$${value.toStringAsFixed(0)}';
}

class _ServiceDetail {
  final String id;
  final String providerId;
  final String name;
  final String category;
  final String description;
  final double rating;
  final int reviewCount;
  final String duration;
  final String location;
  final String responseTime;
  final double price;
  final IconData icon;
  final String providerName;
  final String providerTitle;
  final String providerBio;
  final String providerInitials;
  final int completedJobs;
  final List<String> inclusions;
  final List<_Review> reviews;

  const _ServiceDetail({
    required this.id,
    required this.providerId,
    required this.name,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.duration,
    required this.location,
    required this.responseTime,
    required this.price,
    required this.icon,
    required this.providerName,
    required this.providerTitle,
    required this.providerBio,
    required this.providerInitials,
    required this.completedJobs,
    required this.inclusions,
    required this.reviews,
  });
}

class _Review {
  final String name;
  final double rating;
  final String comment;
  final String dateLabel;

  const _Review({
    required this.name,
    required this.rating,
    required this.comment,
    required this.dateLabel,
  });
}

const Map<String, _ServiceDetail> _serviceCatalog =
    <String, _ServiceDetail>{
  'plomeria': _ServiceDetail(
    id: 'plomeria',
    providerId: 'carlos-gomez',
    name: 'Plomeria inmediata',
    category: 'Urgencias del hogar',
    description:
        'Solucion rapida para fugas, tuberias tapadas y problemas de presion. '
        'Llevamos herramientas completas y dejamos todo limpio al finalizar.',
    rating: 4.9,
    reviewCount: 128,
    duration: '1-2 horas',
    location: 'Monterrey, NL',
    responseTime: '30 min',
    price: 450,
    icon: Icons.plumbing_rounded,
    providerName: 'Carlos Gomez',
    providerTitle: 'Plomero certificado',
    providerBio:
        'Mas de 8 anos atendiendo emergencias residenciales con garantia por '
        'escrito y materiales de primera.',
    providerInitials: 'CG',
    completedJobs: 280,
    inclusions: <String>[
      'Diagnostico en sitio y cotizacion transparente.',
      'Reparacion de fugas visibles y ajuste de presion.',
      'Reemplazo de piezas menores si es necesario.',
      'Garantia de 30 dias en mano de obra.',
    ],
    reviews: <_Review>[
      _Review(
        name: 'Laura Ruiz',
        rating: 5.0,
        comment:
            'Llegaron en menos de una hora y dejaron todo perfecto. Muy claros '
            'con el costo.',
        dateLabel: 'Hace 2 dias',
      ),
      _Review(
        name: 'Miguel Torres',
        rating: 4.8,
        comment:
            'Buen servicio y buena actitud. Me explicaron lo que estaba pasando.',
        dateLabel: 'Hace 1 semana',
      ),
    ],
  ),
  'limpieza': _ServiceDetail(
    id: 'limpieza',
    providerId: 'sofia-torres',
    name: 'Limpieza premium',
    category: 'Hogar y oficina',
    description:
        'Equipo profesional con insumos propios y checklists por estancia. '
        'Ideal para entregas, eventos o mantenimiento mensual.',
    rating: 4.9,
    reviewCount: 92,
    duration: '3-4 horas',
    location: 'San Pedro, NL',
    responseTime: '2 horas',
    price: 650,
    icon: Icons.cleaning_services_rounded,
    providerName: 'Sofia Torres',
    providerTitle: 'Especialista en limpieza',
    providerBio:
        'Coordinamos equipos fijos con estandares claros. Nos enfocamos en '
        'detalles y comunicacion continua.',
    providerInitials: 'ST',
    completedJobs: 190,
    inclusions: <String>[
      'Limpieza profunda de cocina y banos.',
      'Aspirado y trapeado de todas las areas.',
      'Limpieza de cristales interiores.',
      'Checklist final y fotos de entrega.',
    ],
    reviews: <_Review>[
      _Review(
        name: 'Valeria Salas',
        rating: 4.9,
        comment:
            'Muy puntuales y el resultado super limpio. Me gusto el checklist.',
        dateLabel: 'Hace 3 dias',
      ),
      _Review(
        name: 'Jorge Diaz',
        rating: 4.7,
        comment:
            'Buen servicio. Dejaron todo en orden y avisaron al terminar.',
        dateLabel: 'Hace 2 semanas',
      ),
    ],
  ),
  'electricista': _ServiceDetail(
    id: 'electricista',
    providerId: 'sofia-morales',
    name: 'Electricista experto',
    category: 'Instalaciones y reparaciones',
    description:
        'Revisiones completas de tableros, contactos y luminarias. '
        'Servicio seguro con cumplimiento de normas y materiales certificados.',
    rating: 4.7,
    reviewCount: 74,
    duration: '1-3 horas',
    location: 'Monterrey, NL',
    responseTime: '1 hora',
    price: 520,
    icon: Icons.lightbulb_outline_rounded,
    providerName: 'Sofia Morales',
    providerTitle: 'Tecnica electricista',
    providerBio:
        'Especialista en instalaciones residenciales con enfoque en seguridad. '
        'Explico cada paso antes de intervenir.',
    providerInitials: 'SM',
    completedJobs: 210,
    inclusions: <String>[
      'Diagnostico electrico con multimetro.',
      'Reemplazo de contactos o interruptores.',
      'Revision de tierras fisicas y protecciones.',
      'Recomendaciones de seguridad.',
    ],
    reviews: <_Review>[
      _Review(
        name: 'Ricardo Leon',
        rating: 4.6,
        comment:
            'Muy profesional y resolvio el problema rapido. Recomendable.',
        dateLabel: 'Hace 5 dias',
      ),
      _Review(
        name: 'Ana Cardenas',
        rating: 4.8,
        comment:
            'Explico todo con claridad y dejo todo funcionando perfecto.',
        dateLabel: 'Hace 3 semanas',
      ),
    ],
  ),
};
