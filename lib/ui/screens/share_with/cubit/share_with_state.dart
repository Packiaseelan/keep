part of 'share_with_cubit.dart';

abstract class ShareWithState {}

class ShareWithInitial extends ShareWithState {}
class ShareWithLoading extends ShareWithState {}
class ShareWithSuccess extends ShareWithState {
  final List<UserModel> users;

  ShareWithSuccess(this.users);
}
class ShareWithFailed extends ShareWithState {
  final String message;

  ShareWithFailed(this.message);
}