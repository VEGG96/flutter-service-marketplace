import 'package:flutter/material.dart';

import 'skeleton_widget.dart';

class SearchBarSkeleton extends StatelessWidget {
  const SearchBarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonBox(
      height: 52,
      borderRadius: BorderRadius.all(Radius.circular(14)),
    );
  }
}

class ServiceCategoryCardSkeleton extends StatelessWidget {
  const ServiceCategoryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SkeletonBox(width: 26, height: 26),
          SizedBox(height: 10),
          SkeletonBox(width: 86, height: 14),
          SizedBox(height: 8),
          SkeletonBox(width: 60, height: 12),
        ],
      ),
    );
  }
}

class ProfessionalCardSkeleton extends StatelessWidget {
  const ProfessionalCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: <Widget>[
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SkeletonCircle(size: 50),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SkeletonBox(width: 120, height: 14),
                    SizedBox(height: 8),
                    SkeletonBox(width: 80, height: 12),
                    SizedBox(height: 8),
                    SkeletonBox(width: 56, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SkeletonBox(
            width: double.infinity,
            height: 38,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ],
      ),
    );
  }
}

class ServicesScreenSkeleton extends StatelessWidget {
  const ServicesScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SearchBarSkeleton(),
          const SizedBox(height: 14),
          Stack(
            children: <Widget>[
              const SkeletonBox(
                height: 190,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: SkeletonBox(
                  width: 86,
                  height: 58,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const SkeletonBox(width: 170, height: 20),
          const SizedBox(height: 12),
          SizedBox(
            height: 125,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 10),
              itemBuilder: (BuildContext context, int index) =>
                  const ServiceCategoryCardSkeleton(),
            ),
          ),
          const SizedBox(height: 18),
          const SkeletonBox(width: 190, height: 20),
          const SizedBox(height: 12),
          SizedBox(
            height: 148,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 10),
              itemBuilder: (BuildContext context, int index) =>
                  const ProfessionalCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}
