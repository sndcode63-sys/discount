import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/store_model.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/models/deal_model.dart';
import '../../../shared/models/user_model.dart';

// EVENTS
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class LoadHomeDataEvent extends HomeEvent {
  final double latitude;
  final double longitude;
  final bool forceRefresh;

  const LoadHomeDataEvent({
    this.latitude = 19.0760,
    this.longitude = 72.8777,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [latitude, longitude, forceRefresh];
}

class SelectCategoryEvent extends HomeEvent {
  final String category;
  const SelectCategoryEvent(this.category);
  @override
  List<Object?> get props => [category];
}

class SearchQueryEvent extends HomeEvent {
  final String query;
  const SearchQueryEvent(this.query);
  @override
  List<Object?> get props => [query];
}

// STATES
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<StoreModel> nearbyStores;
  final List<ProductModel> products;
  final List<DealModel> deals;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final UserModel? user;
  final String locationName;

  const HomeLoaded({
    required this.nearbyStores,
    required this.products,
    required this.deals,
    required this.categories,
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.user,
    this.locationName = 'Bengaluru, Karnataka',
  });

  List<ProductModel> get filteredProducts {
    return products.where((p) {
      final matchesCategory = selectedCategory == 'All' ||
          p.category.toLowerCase().contains(selectedCategory.toLowerCase());
      final matchesQuery = searchQuery.isEmpty ||
          p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  HomeLoaded copyWith({
    List<StoreModel>? nearbyStores,
    List<ProductModel>? products,
    List<DealModel>? deals,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    UserModel? user,
    String? locationName,
  }) {
    return HomeLoaded(
      nearbyStores: nearbyStores ?? this.nearbyStores,
      products: products ?? this.products,
      deals: deals ?? this.deals,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      user: user ?? this.user,
      locationName: locationName ?? this.locationName,
    );
  }

  @override
  List<Object?> get props => [
        nearbyStores,
        products,
        deals,
        categories,
        selectedCategory,
        searchQuery,
        user,
        locationName,
      ];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiClient apiClient = ApiClient();

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<SearchQueryEvent>(_onSearchQuery);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    List<StoreModel> stores = [];
    List<ProductModel> products = [];
    List<DealModel> deals = [];
    UserModel? user;

    // 1. Fetch Nearby Stores from API
    try {
      final storeResp = await apiClient.get(
        ApiConstants.nearbyStores,
        queryParameters: {
          'latitude': event.latitude,
          'longitude': event.longitude,
          'radiusKm': 10,
        },
      );

      if (storeResp.success &&
          storeResp.data is Map &&
          storeResp.data['stores'] is List) {
        final list = storeResp.data['stores'] as List;
        stores = list.map((json) => StoreModel.fromJson(json)).toList();
      }
    } catch (_) {}

    // 2. Fetch Products from API (100% Dynamic)
    try {
      final prodResp = await apiClient.get(
        ApiConstants.products,
        queryParameters: {'page': 1, 'limit': 20},
      );

      if (prodResp.success &&
          prodResp.data is Map &&
          prodResp.data['products'] is List) {
        final list = prodResp.data['products'] as List;
        products = list.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (_) {}

    // 3. Fetch Deals & Festival Offers (100% Dynamic)
    try {
      final dealResp = await apiClient.get(ApiConstants.affiliateDeals);
      if (dealResp.success &&
          dealResp.data is Map &&
          dealResp.data['deals'] is List) {
        final list = dealResp.data['deals'] as List;
        deals = list.map((json) => DealModel.fromJson(json)).toList();
      }
    } catch (_) {}

    // 4. Get User Profile if logged in
    final cachedUser = await apiClient.getUserData();
    if (cachedUser != null) {
      user = UserModel.fromJson(cachedUser);
    }

    // Dynamic Categories extracted from real live products
    final Set<String> categorySet = {'All'};
    for (final p in products) {
      if (p.category.trim().isNotEmpty) {
        categorySet.add(p.category.trim());
      }
    }
    final categories = categorySet.toList();

    emit(HomeLoaded(
      nearbyStores: stores,
      products: products,
      deals: deals,
      categories: categories,
      selectedCategory: 'All',
      user: user,
      locationName: 'Current Location',
    ));
  }

  void _onSelectCategory(SelectCategoryEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      emit(current.copyWith(selectedCategory: event.category));
    }
  }

  void _onSearchQuery(SearchQueryEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      emit(current.copyWith(searchQuery: event.query));
    }
  }
}
