import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Domain/Usecases/get_profile_usecase.dart';
import '../../../Domain/Usecases/log_out_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileBloc(this.getProfileUseCase, this.logoutUseCase) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getProfileUseCase.execute();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<Logout>((event, emit) async {
      try {
        await logoutUseCase.execute();
        emit(ProfileLoggedOut());
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}