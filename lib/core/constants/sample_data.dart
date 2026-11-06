import '../../shared/models/product.dart';
import '../../shared/models/store.dart';

class SampleData {
  static List<Product> getProducts() {
    return [];
  }

  static List<Store> getStores() {
    return [];
  }

  static List<String> getCategories() {
    return [
      'Fruits',
      'Vegetables',
      'Dairy',
      'Bakery',
      'Grains',
      'Snacks',
    ];
  }

  static List<String> getRecentSearches() {
    return [
      'Apple',
      'Milk',
      'Bread',
      'Rice',
      'Tomato',
    ];
  }

  static List<String> getPopularCategories() {
    return [
      'Fresh Fruits',
      'Vegetables',
      'Dairy Products',
      'Bakery Items',
      'Snacks',
    ];
  }
}
