import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final _auth = FirebaseAuth.instance;
  late UserCredential userCredential;

  LoginCubit() : super(LoginInitial());

  Future<void> doLogin(String email, String password) async {
    emit(LoginLoading());

    try {
      userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } catch (error) {
      final fae = error as FirebaseAuthException;
      emit(LoginFailed(fae.message ?? ""));
    }
  }

  Future<void> doRegister(String email, String password) async {
    emit(LoginLoading());

    try {
      userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } catch (error) {
      final fae = error as FirebaseAuthException;
      emit(LoginFailed(fae.message ?? ""));
    }
  }
}
