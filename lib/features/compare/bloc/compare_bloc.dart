import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/compare_model.dart';

// EVENTS
abstract class CompareEvent extends Equatable {
  const CompareEvent();
  @override
  List<Object?> get props => [];
}

class CompareProductQueryEvent extends CompareEvent {
  final String query;
  final double latitude;
  final double longitude;

  const CompareProductQueryEvent({
    required this.query,
    this.latitude = 19.0760,
    this.longitude = 72.8777,
  });

  @override
  List<Object?> get props => [query, latitude, longitude];
}

// STATES
abstract class CompareState extends Equatable {
  const CompareState();
  @override
  List<Object?> get props => [];
}

class CompareInitial extends CompareState {}

class CompareLoading extends CompareState {}

class CompareLoadedState extends CompareState {
  final CompareResultModel result;
  const CompareLoadedState(this.result);
  @override
  List<Object?> get props => [result];
}

class CompareErrorState extends CompareState {
  final String error;
  const CompareErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

// BLOC
class CompareBloc extends Bloc<CompareEvent, CompareState> {
  final ApiClient apiClient = ApiClient();

  CompareBloc() : super(CompareInitial()) {
    on<CompareProductQueryEvent>(_onCompareProduct);
  }

  Future<void> _onCompareProduct(
    CompareProductQueryEvent event,
    Emitter<CompareState> emit,
  ) async {
    emit(CompareLoading());

    try {
      final resp = await apiClient.get(
        ApiConstants.compareProduct,
        queryParameters: {
          'query': event.query,
          'latitude': event.latitude,
          'longitude': event.longitude,
          'radiusKm': 10,
        },
      );

      if (resp.success && resp.data is Map) {
        final result = CompareResultModel.fromJson(resp.data as Map<String, dynamic>);
        emit(CompareLoadedState(result));
        return;
      } else {
        final msg = resp.message ?? '';
        emit(CompareErrorState(
          msg.isNotEmpty
              ? msg
              : 'No live comparison data found for "${event.query}". Please try another product name.',
        ));
      }
    } catch (e) {
      emit(CompareErrorState('Failed to fetch live comparison: $e'));
    }
  }
}
