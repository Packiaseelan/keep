import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep/config/config.dart';
import 'package:keep/models/notes_model.dart';
import 'package:keep/ui/screens/home/cubit/home_cubit.dart';
import 'package:keep/ui/screens/home/cubit/home_state.dart';
import 'package:keep/ui/widgets/grid_item.dart';
import 'package:keep/ui/widgets/notes_dialog_widget.dart';
import 'package:keep/ui/widgets/notes_field.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:keep/utils/custom_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keep Notes'),
          actions: [
            IconButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is HomeInitial) {
              context.read<HomeCubit>().getNotes();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NotesTextField(
                  onSave: (title, description) {
                    context.read<HomeCubit>().saveNotes(title, description, false);
                  },
                ),
                if (state is HomeNotesState && state.pinnedNotes.isNotEmpty) _buildTitle('PINNED'),
                if (state is HomeNotesState && state.pinnedNotes.isNotEmpty) _buildGrid(state.pinnedNotes),
                if (state is HomeNotesState && state.pinnedNotes.isNotEmpty) const SizedBox(height: 20),
                if (state is HomeNotesState && state.pinnedNotes.isNotEmpty && state.notes.isNotEmpty)
                  _buildTitle('OTHERS'),
                if (state is HomeNotesState && state.notes.isNotEmpty) _buildGrid(state.notes),
                _buildNoData(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGrid(List<NotesResponse> notes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ReorderableGridView.extent(
        shrinkWrap: true,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        maxCrossAxisExtent: 250,
        childAspectRatio: 2 / 1,
        onReorder: (oldIndex, newIndex) {
          final temp = notes[oldIndex];
          notes[oldIndex] = notes[newIndex];
          notes[newIndex] = temp;
          setState(() {});
        },
        children: notes
            .map((e) => GestureDetector(
                  key: ValueKey(e),
                  onTap: () async {
                    customDialog(context, child: NotesDialogWidget(note: e)).then((value) {
                      context.read<HomeCubit>().updateNotes(e);
                    });
                  },
                  child: GridItem(
                    note: e,
                    onPinned: () => context.read<HomeCubit>().pinnedNotes(e, !e.value!.isPinned!),
                    onDelete: () => context.read<HomeCubit>().delete(e.key!),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildNoData(HomeState state) {
    if (state is HomeNotesState && state.notes.isEmpty && state.pinnedNotes.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/bulb.png', color: Colors.grey,),
              const SizedBox(height: 15),
              Text(
                'Notes you add appear here',
                style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
