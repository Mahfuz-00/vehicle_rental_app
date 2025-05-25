import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Domain/Usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await loginUseCase.execute(event.email, event.password);
        // Save token and remember me status via LocalDataSource
        emit(LoginSuccess(user));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}