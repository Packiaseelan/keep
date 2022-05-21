import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep/config/service_locator.dart';
import 'package:keep/models/user_model.dart';
import 'package:keep/service/firebase_database_service.dart';

part 'share_with_state.dart';

class ShareWithCubit extends Cubit<ShareWithState> {
  
  final _auth = FirebaseAuth.instance;

  ShareWithCubit() : super(ShareWithInitial());

  Future<void> getUsers(String noteId) async {
    emit(ShareWithLoading());
    try {
      final userId = _auth.currentUser?.uid;
      final users = await serviceLocator<FirebaseDatabaseService>().getUsers();
      final shared = await serviceLocator<FirebaseDatabaseService>().getSharedWith(noteId);
      for (var u in users) {
        if (shared.where((e) => e.userId == u.userId).isNotEmpty) {
          u.isSelected = true;
        }
      }
      var currentUser = users.firstWhere((u) => u.userId == userId);
      users.remove(currentUser);
      emit(ShareWithSuccess(users));
    } catch (error) {
      emit(ShareWithFailed(error.toString()));
    }
  }
}
