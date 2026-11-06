import 'package:flutter/material.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/deal_model.dart';

class DealsAndOffersScreen extends StatefulWidget {
  const DealsAndOffersScreen({super.key});

  @override
  State<DealsAndOffersScreen> createState() => _DealsAndOffersScreenState();
}

class _DealsAndOffersScreenState extends State<DealsAndOffersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiClient _apiClient = ApiClient();

  List<DealModel> _allDeals = [];
  List<DealModel> _festivalOffers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchDeals();
  }

  Future<void> _fetchDeals() async {
    setState(() => _isLoading = true);

    try {
      // 1. All Deals
      final dResp = await _apiClient.get(ApiConstants.affiliateDeals);
      if (dResp.success && dResp.data is Map && dResp.data['deals'] is List) {
        final list = dResp.data['deals'] as List;
        _allDeals = list.map((json) => DealModel.fromJson(json)).toList();
      }

      // 2. Festival Offers
      final fResp = await _apiClient.get(ApiConstants.festivalOffers);
      if (fResp.success && fResp.data is Map && fResp.data['deals'] is List) {
        final list = fResp.data['deals'] as List;
        _festivalOffers = list.map((json) => DealModel.fromJson(json)).toList();
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Deals & Offers',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'All Deals'),
            Tab(text: 'Festival Offers'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDealsList(_allDeals),
                _buildDealsList(_festivalOffers),
              ],
            ),
    );
  }

  Widget _buildDealsList(List<DealModel> deals) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Big Billion Days Banner
        Container(
          height: 130,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage('assets/images/deals_banner.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Partner Marketplace Pills (Amazon, Flipkart, Meesho)
        const Text(
          'Top Partner Marketplaces',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildPartnerChip('Amazon', const Color(0xFFFF9900)),
            const SizedBox(width: 8),
            _buildPartnerChip('Flipkart', const Color(0xFF2874F0)),
            const SizedBox(width: 8),
            _buildPartnerChip('Meesho', const Color(0xFFE91E63)),
          ],
        ),

        const SizedBox(height: 16),

        if (deals.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.local_offer_outlined, size: 40, color: AppColors.textTertiary),
                  SizedBox(height: 8),
                  Text('No deals available', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 4),
                  Text('Check back soon for new discounts and cashback deals', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          )
        else
          ...deals.map((deal) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.local_offer_rounded, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              deal.platform,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${deal.cashbackPercent.toInt()}% Cashback',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        deal.title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '₹${deal.dealPrice.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '₹${deal.regularPrice.toInt()}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPartnerChip(String name, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
