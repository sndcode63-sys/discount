import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/user_model.dart';

// EVENTS
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SendOtpEvent extends AuthEvent {
  final String phone;
  const SendOtpEvent(this.phone);
  @override
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;
  const VerifyOtpEvent({required this.phone, required this.otp});
  @override
  List<Object?> get props => [phone, otp];
}

class LoginWithPasswordEvent extends AuthEvent {
  final String identifier; // phone or email
  final String password;
  const LoginWithPasswordEvent({required this.identifier, required this.password});
  @override
  List<Object?> get props => [identifier, password];
}

class RegisterUserEvent extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String role; // 'customer' or 'merchant'
  final String referralCode;

  const RegisterUserEvent({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    this.role = 'customer',
    this.referralCode = '',
  });

  @override
  List<Object?> get props => [name, phone, email, password, role, referralCode];
}

class LogoutEvent extends AuthEvent {}

// STATES
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSentState extends AuthState {
  final String message;
  final String phone;
  const OtpSentState({required this.message, required this.phone});
  @override
  List<Object?> get props => [message, phone];
}

class AuthenticatedState extends AuthState {
  final UserModel user;
  final String token;
  const AuthenticatedState({required this.user, required this.token});
  @override
  List<Object?> get props => [user, token];
}

class UnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiClient apiClient = ApiClient();

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LoginWithPasswordEvent>(_onLoginWithPassword);
    on<RegisterUserEvent>(_onRegisterUser);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final token = await apiClient.getAuthToken();
    if (token == null || token.isEmpty) {
      emit(UnauthenticatedState());
      return;
    }

    final cachedUser = await apiClient.getUserData();
    if (cachedUser != null) {
      emit(AuthenticatedState(
        user: UserModel.fromJson(cachedUser, token: token),
        token: token,
      ));
    }

    // Refresh profile in background
    final resp = await apiClient.get(ApiConstants.getProfile);
    if (resp.success && resp.data is Map && resp.data['user'] is Map) {
      final user = UserModel.fromJson(resp.data['user'], token: token);
      await apiClient.saveUserData(resp.data['user']);
      emit(AuthenticatedState(user: user, token: token));
    } else if (cachedUser == null) {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final resp = await apiClient.post(
      ApiConstants.sendOtp,
      data: {'phone': event.phone},
    );

    if (resp.success) {
      emit(OtpSentState(
        message: resp.message ?? 'SMS OTP dispatched to +91 ${event.phone}',
        phone: event.phone,
      ));
    } else {
      emit(AuthErrorState(
        resp.error ?? resp.message ?? 'Failed to send OTP to ${event.phone}. Check mobile number.',
      ));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final resp = await apiClient.post(
      ApiConstants.verifyOtp,
      data: {'phone': event.phone, 'otp': event.otp},
    );

    if (resp.success && resp.data is Map && resp.data['token'] != null) {
      final token = resp.data['token'].toString();
      final userMap = resp.data['user'] as Map<String, dynamic>? ??
          {'name': 'Customer', 'phone': event.phone, 'role': 'customer'};
      final user = UserModel.fromJson(userMap, token: token);

      await apiClient.saveAuthToken(token);
      await apiClient.saveUserData(userMap);
      emit(AuthenticatedState(user: user, token: token));
    } else {
      emit(AuthErrorState(
        resp.error ?? resp.message ?? 'Invalid OTP entered. Please try again.',
      ));
    }
  }

  Future<void> _onLoginWithPassword(
    LoginWithPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final resp = await apiClient.post(
      ApiConstants.login,
      data: {'identifier': event.identifier, 'password': event.password},
    );

    if (resp.success && resp.data is Map && resp.data['token'] != null) {
      final token = resp.data['token'].toString();
      final userMap = resp.data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap, token: token);

      await apiClient.saveAuthToken(token);
      await apiClient.saveUserData(userMap);
      emit(AuthenticatedState(user: user, token: token));
    } else {
      emit(AuthErrorState(
        resp.error ?? resp.message ?? 'Invalid credentials. Check identifier and password.',
      ));
    }
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final resp = await apiClient.post(
      ApiConstants.register,
      data: {
        'name': event.name,
        'phone': event.phone,
        'email': event.email,
        'password': event.password,
        'role': event.role,
        if (event.referralCode.isNotEmpty) 'referralCode': event.referralCode,
      },
    );

    if (resp.success && resp.data is Map && resp.data['token'] != null) {
      final token = resp.data['token'].toString();
      final userMap = resp.data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap, token: token);

      await apiClient.saveAuthToken(token);
      await apiClient.saveUserData(userMap);
      emit(AuthenticatedState(user: user, token: token));
    } else {
      emit(AuthErrorState(
        resp.error ?? resp.message ?? 'Registration failed. Check phone or email.',
      ));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await apiClient.clearAuth();
    emit(UnauthenticatedState());
  }
}
