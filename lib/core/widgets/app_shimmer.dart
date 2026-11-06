import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0xFFE8ECEF),
      highlightColor: highlightColor ?? const Color(0xFFF8F9FA),
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class StoreCardShimmer extends StatelessWidget {
  const StoreCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: AppShimmer(
        child: Row(
          children: [
            const ShimmerBox(width: 80, height: 80, borderRadius: 12),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: 140, height: 16, borderRadius: 4),
                  const SizedBox(height: 8),
                  const ShimmerBox(width: 200, height: 12, borderRadius: 4),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      ShimmerBox(width: 50, height: 16, borderRadius: 4),
                      SizedBox(width: 12),
                      ShimmerBox(width: 60, height: 16, borderRadius: 4),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: Center(
                child: ShimmerBox(width: 100, height: 100, borderRadius: 12),
              ),
            ),
            SizedBox(height: 8),
            ShimmerBox(width: 110, height: 14, borderRadius: 4),
            SizedBox(height: 6),
            ShimmerBox(width: 70, height: 12, borderRadius: 4),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 50, height: 16, borderRadius: 4),
                ShimmerBox(width: 40, height: 16, borderRadius: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DealsBannerShimmer extends StatelessWidget {
  const DealsBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const AppShimmer(
        child: ShimmerBox(width: double.infinity, height: 140, borderRadius: 20),
      ),
    );
  }
}

class WalletCardShimmer extends StatelessWidget {
  const WalletCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: AppShimmer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerBox(width: 120, height: 14, borderRadius: 4),
              SizedBox(height: 16),
              ShimmerBox(width: 180, height: 32, borderRadius: 6),
              Spacer(),
              Row(
                children: [
                  Expanded(child: ShimmerBox(width: double.infinity, height: 44, borderRadius: 12)),
                  SizedBox(width: 12),
                  Expanded(child: ShimmerBox(width: double.infinity, height: 44, borderRadius: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComparisonCardShimmer extends StatelessWidget {
  const ComparisonCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerBox(width: 200, height: 20, borderRadius: 6),
            SizedBox(height: 16),
            ShimmerBox(width: double.infinity, height: 80, borderRadius: 12),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 60, borderRadius: 12),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 60, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}
