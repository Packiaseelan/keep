import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep/models/user_model.dart';
import 'package:keep/ui/screens/share_with/cubit/share_with_cubit.dart';

class ShareWithScreen extends StatefulWidget {
  final String noteId;
  const ShareWithScreen({Key? key, required this.noteId}) : super(key: key);

  @override
  State<ShareWithScreen> createState() => _ShareWithScreenState();
}

class _ShareWithScreenState extends State<ShareWithScreen> {
  final selectedUsers = <UserModel>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, selectedUsers);
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<ShareWithCubit, ShareWithState>(
      builder: (context, state) {
        if (state is ShareWithInitial) {
          context.read<ShareWithCubit>().getUsers(widget.noteId);
        } else if (state is ShareWithLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ShareWithSuccess) {
          if (state.users.isEmpty) {
            return _buildNoUser();
          }

          return _buildUserList(state.users);
        }

        return const SizedBox();
      },
      listener: (context, state) {
        if (state is ShareWithFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
    );
  }

  Widget _buildUserList(List<UserModel> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(users[index].userName!),
          subtitle: Text(users[index].emailId!),
          onTap: () {
            addUser(users[index]);
          },
          trailing: Icon(
            users[index].isSelected == true ? Icons.check_circle : Icons.circle_outlined,
            color: users[index].isSelected == true ? Colors.green : Colors.grey,
          ),
        );
      },
    );
  }

  Widget _buildNoUser() {
    return Center(
      child: Text(
        'No users found.',
        style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.grey),
      ),
    );
  }

  void addUser(UserModel user) {
    var isSelected = user.isSelected ?? false;
    user.isSelected = !isSelected;
    if (user.isSelected == true) {
      selectedUsers.add(user);
    } else {
      selectedUsers.remove(user);
    }
    setState(() {});
  }
}
