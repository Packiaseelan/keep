import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep/config/config.dart';
import 'package:keep/models/notes_model.dart';
import 'package:keep/ui/screens/home/cubit/home_cubit.dart';
import 'package:keep/ui/screens/home/cubit/home_state.dart';
import 'package:keep/ui/widgets/grid_item.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

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
                const NotesTextField(),
                if (state is HomeNotesState && state.pinnedNotes.isNotEmpty) _buildTitle('PINNED'),
                if (state is HomeNotesState && state.pinnedNotes.isNotEmpty) _buildGrid(state.pinnedNotes),
                if (state is HomeNotesState && state.pinnedNotes.isNotEmpty) const SizedBox(height: 20),
                if (state is HomeNotesState && state.pinnedNotes.isNotEmpty && state.notes.isNotEmpty) _buildTitle('OTHERS'),
                if (state is HomeNotesState && state.notes.isNotEmpty) _buildGrid(state.notes)
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
            .map((e) => GridItem(
                  key: ValueKey(e),
                  note: e,
                  onPinned: () => context.read<HomeCubit>().pinnedNotes(e, !e.value!.isPinned!),
                  onDelete: () => context.read<HomeCubit>().delete(e.key!),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium,),
    );
  }
}

class NotesTextField extends StatefulWidget {
  const NotesTextField({Key? key}) : super(key: key);

  @override
  State<NotesTextField> createState() => _NotesTextFieldState();
}

class _NotesTextFieldState extends State<NotesTextField> {
  bool _isVsible = false;

  final _txtDescriptionController = TextEditingController();
  final _txtTitleController = TextEditingController();

  final _descriptionFocus = FocusNode();
  final _titleFocus = FocusNode();

  String title = "";
  String description = "";

  @override
  void initState() {
    _titleFocus.addListener(() {
      if (!_descriptionFocus.hasFocus && !_titleFocus.hasFocus) {
        _saveData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Visibility(
                visible: _isVsible,
                child: TextField(
                  focusNode: _titleFocus,
                  controller: _txtTitleController,
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'Title'),
                ),
              ),
              Focus(
                onFocusChange: _onFocusChange,
                child: TextField(
                  focusNode: _descriptionFocus,
                  controller: _txtDescriptionController,
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'Take a note...'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      if (hasFocus) {
        _isVsible = hasFocus;
      } else {
        if (_titleFocus.hasFocus) {
          _isVsible = true;
        } else {
          _isVsible = false;

          _saveData();
        }
      }
    });
  }

  void _saveData() {
    final title = _txtTitleController.text;
    final description = _txtDescriptionController.text;

    if (title.isEmpty && description.isEmpty) {
      setState(() {
        _isVsible = false;
      });
      return;
    }

    _txtTitleController.text = "";
    _txtDescriptionController.text = "";

    setState(() {
      _isVsible = false;
    });

    context.read<HomeCubit>().saveNotes(title, description, false);
  }
}
