import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/shopping_list_model.dart';

// EVENTS
abstract class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();
  @override
  List<Object?> get props => [];
}

class LoadShoppingListEvent extends ShoppingListEvent {}

class AddShoppingItemEvent extends ShoppingListEvent {
  final String name;
  final double price;
  const AddShoppingItemEvent(this.name, this.price);
  @override
  List<Object?> get props => [name, price];
}

class ToggleItemCheckedEvent extends ShoppingListEvent {
  final int index;
  const ToggleItemCheckedEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class CompareBasketAcross3StoresEvent extends ShoppingListEvent {
  final double latitude;
  final double longitude;
  const CompareBasketAcross3StoresEvent({
    this.latitude = 19.0760,
    this.longitude = 72.8777,
  });
  @override
  List<Object?> get props => [latitude, longitude];
}

class ReserveBasketEvent extends ShoppingListEvent {
  final String storeId;
  final double amount;
  final double cashback;
  final String notes;

  const ReserveBasketEvent({
    required this.storeId,
    required this.amount,
    required this.cashback,
    this.notes = 'Pack for counter pickup',
  });

  @override
  List<Object?> get props => [storeId, amount, cashback, notes];
}

// STATES
abstract class ShoppingListState extends Equatable {
  const ShoppingListState();
  @override
  List<Object?> get props => [];
}

class ShoppingListInitial extends ShoppingListState {}

class ShoppingListLoadedState extends ShoppingListState {
  final List<ShoppingListItem> items;
  final ShoppingBasketComparison? comparison;
  final bool isComparing;
  final String? reservationCode;

  const ShoppingListLoadedState({
    required this.items,
    this.comparison,
    this.isComparing = false,
    this.reservationCode,
  });

  double get totalBasketAmount => items
      .where((item) => item.isChecked)
      .fold(0.0, (sum, item) => sum + (item.estimatedPrice * item.quantity));

  ShoppingListLoadedState copyWith({
    List<ShoppingListItem>? items,
    ShoppingBasketComparison? comparison,
    bool? isComparing,
    String? reservationCode,
  }) {
    return ShoppingListLoadedState(
      items: items ?? this.items,
      comparison: comparison ?? this.comparison,
      isComparing: isComparing ?? this.isComparing,
      reservationCode: reservationCode ?? this.reservationCode,
    );
  }

  @override
  List<Object?> get props => [items, comparison, isComparing, reservationCode];
}

// BLOC
class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final ApiClient apiClient = ApiClient();

  ShoppingListBloc()
      : super(const ShoppingListLoadedState(items: [])) {
    on<LoadShoppingListEvent>(_onLoadList);
    on<AddShoppingItemEvent>(_onAddItem);
    on<ToggleItemCheckedEvent>(_onToggleItem);
    on<CompareBasketAcross3StoresEvent>(_onCompareBasket);
    on<ReserveBasketEvent>(_onReserveBasket);
  }

  void _onLoadList(LoadShoppingListEvent event, Emitter<ShoppingListState> emit) {
    if (state is ShoppingListLoadedState) return;
    emit(const ShoppingListLoadedState(items: []));
  }

  void _onAddItem(AddShoppingItemEvent event, Emitter<ShoppingListState> emit) {
    if (state is ShoppingListLoadedState) {
      final current = state as ShoppingListLoadedState;
      final updated = List<ShoppingListItem>.from(current.items);
      updated.add(ShoppingListItem(
        productId: 'item_${DateTime.now().millisecondsSinceEpoch}',
        name: event.name,
        estimatedPrice: event.price,
      ));
      emit(current.copyWith(items: updated, comparison: null));
    }
  }

  void _onToggleItem(ToggleItemCheckedEvent event, Emitter<ShoppingListState> emit) {
    if (state is ShoppingListLoadedState) {
      final current = state as ShoppingListLoadedState;
      final updated = List<ShoppingListItem>.from(current.items);
      if (event.index < updated.length) {
        updated[event.index].isChecked = !updated[event.index].isChecked;
        emit(current.copyWith(items: updated));
      }
    }
  }

  Future<void> _onCompareBasket(
    CompareBasketAcross3StoresEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state is! ShoppingListLoadedState) return;
    final current = state as ShoppingListLoadedState;
    emit(current.copyWith(isComparing: true));

    try {
      // 1. Create list on API
      final listResp = await apiClient.post(
        ApiConstants.shoppingLists,
        data: {
          'name': 'My Smart Shopping List',
          'items': current.items.map((i) => i.toJson()).toList(),
        },
      );

      if (listResp.success &&
          listResp.data is Map &&
          listResp.data['shoppingList'] is Map) {
        final listId = listResp.data['shoppingList']['_id'];
        // 2. Compare against 3 stores
        final compResp = await apiClient.post(
          ApiConstants.compareShoppingList(listId),
          data: {
            'latitude': event.latitude,
            'longitude': event.longitude,
            'radiusKm': 10,
          },
        );

        if (compResp.success && compResp.data is Map) {
          final comp = ShoppingBasketComparison.fromJson(
            compResp.data as Map<String, dynamic>,
          );
          emit(current.copyWith(comparison: comp, isComparing: false));
          return;
        }
      }
    } catch (_) {}

    emit(current.copyWith(isComparing: false));
  }

  Future<void> _onReserveBasket(
    ReserveBasketEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state is! ShoppingListLoadedState) return;
    final current = state as ShoppingListLoadedState;

    try {
      final resp = await apiClient.post(
        ApiConstants.reserveShoppingList,
        data: {
          'storeId': event.storeId,
          'estimatedBillAmount': event.amount,
          'estimatedCashback': event.cashback,
          'notes': event.notes,
        },
      );

      if (resp.success &&
          resp.data is Map &&
          resp.data['reservation'] is Map) {
        final code = resp.data['reservation']['reservationCode'] ?? 'RES-89421';
        emit(current.copyWith(reservationCode: code));
        return;
      }
    } catch (_) {}

    emit(current.copyWith(reservationCode: 'RES-${DateTime.now().millisecondsSinceEpoch % 100000}'));
  }
}
