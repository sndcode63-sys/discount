import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../shared/models/deal_model.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  bool _isLoading = true;
  List<DealModel> _deals = [];

  @override
  void initState() {
    super.initState();
    _fetchDealsFromApi();
  }

  Future<void> _fetchDealsFromApi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiClient().get(ApiConstants.affiliateDeals);
      if (response.success && response.data != null) {
        final rawData = response.data;
        List<dynamic> listData = [];
        if (rawData is Map<String, dynamic> && rawData['deals'] is List) {
          listData = rawData['deals'] as List;
        } else if (rawData is List) {
          listData = rawData;
        }

        final parsedList = listData
            .map((item) => DealModel.fromJson(item as Map<String, dynamic>))
            .toList();

        setState(() {
          _deals = parsedList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offers & Coupons'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Banner
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Exclusive Savings',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap copy to apply coupon at checkout',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textWhite.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_deals.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Icon(Icons.local_offer_outlined, size: 60, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          Text('No live offers right now', style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _fetchDealsFromApi,
                            child: const Text('Refresh Offers'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._deals.map(
                    (deal) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildDealCard(deal),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildDealCard(DealModel deal) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 85,
              height: 85,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${deal.discountPercent.toInt()}% OFF',
                  style: AppTextStyles.semiboldMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          deal.platform.isNotEmpty ? deal.platform : 'DISCOUNT50',
                          style: AppTextStyles.semiboldMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: deal.title));
                          ToastUtils.success('Coupon copied to clipboard!');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    deal.title,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${deal.dealPrice.toStringAsFixed(0)} (MRP ₹${deal.regularPrice.toStringAsFixed(0)})',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
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
