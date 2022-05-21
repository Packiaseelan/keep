import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keep/config/config.dart';
import 'package:keep/models/notes_model.dart';
import 'package:keep/models/shared_with_model.dart';
import 'package:keep/models/user_model.dart';
import 'package:keep/service/firebase_database_service.dart';
import 'package:keep/service/firebase_storage_service.dart';
import 'package:keep/ui/widgets/grid_item.dart';

class NotesDialogWidget extends StatefulWidget {
  final NotesResponse note;
  const NotesDialogWidget({Key? key, required this.note}) : super(key: key);

  @override
  State<NotesDialogWidget> createState() => _NotesDialogWidgetState();
}

class _NotesDialogWidgetState extends State<NotesDialogWidget> {
  final _txtDescriptionController = TextEditingController();
  final _txtTitleController = TextEditingController();
  bool _isPinned = false;

  @override
  void initState() {
    _txtTitleController.text = widget.note.value!.title ?? '';
    _txtDescriptionController.text = widget.note.value!.description ?? '';
    _isPinned = widget.note.value!.isPinned ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 195 + (widget.note.value!.imagePath != null ? 150 : 0),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Column(
                  children: [
                    TextField(
                      onChanged: (val) {
                        widget.note.value!.title = val;
                      },
                      controller: _txtTitleController,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Title'),
                    ),
                    _buildImage(widget.note.value!.imagePath),
                    TextField(
                      onChanged: (val) {
                        widget.note.value!.description = val;
                      },
                      maxLines: 2,
                      controller: _txtDescriptionController,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Take a note...'),
                    ),
                    _buildDateTime(widget.note.value?.dateTime ?? 0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          IconButtonWidget(icon: Icons.person_add, onTap: _onShare),
                          const SizedBox(width: 15),
                          IconButtonWidget(icon: Icons.image, onTap: _pickImage),
                          const Spacer(),
                          TextButtonWidget(
                            text: 'Close',
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButtonWidget(
                    icon: _isPinned ? Icons.push_pin_sharp : Icons.push_pin_outlined,
                    onTap: _onPinned,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imagePath) {
    if (imagePath != null) {
      return Stack(
        children: [
          SizedBox(
            height: 150,
            child: Image.network(imagePath, height: 150),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButtonWidget(
              bgColor: Colors.black,
              iconColor: Colors.white,
              icon: Icons.close,
              onTap: _onDeleteImage,
            ),
          )
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildDateTime(int? date) {
    final formatter = DateFormat('MMM dd');
    final date = DateTime.fromMillisecondsSinceEpoch(widget.note.value?.dateTime ?? 0);
    final dateString = formatter.format(date);
    return Align(
      alignment: Alignment.centerRight,
      child: Text('Edited on: $dateString'),
    );
  }

  void _onPinned() {
    widget.note.value!.isPinned = !_isPinned;
    setState(() {
      _isPinned = !_isPinned;
    });
  }

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    final res = await serviceLocator<FirebaseStorageService>().uploadFile(File(image!.path));
    widget.note.value!.imagePath = res;
    setState(() {});
  }

  void _onDeleteImage() async {
    final path = widget.note.value!.imagePath ?? '';
    await serviceLocator<FirebaseStorageService>().deleteFile(path);
    widget.note.value!.imagePath = "";
    setState(() {});
  }

  void _onShare() async {
    final users = await Navigator.pushNamed(context, Routes.shareWith, arguments: {'noteId': widget.note.key!}) as List<UserModel>;
    var shared = <SharedWithModel>[];
    for (var user in users) {
      shared.add(SharedWithModel(userId: user.userId, noteId: widget.note.key));
    }
    await serviceLocator<FirebaseDatabaseService>().saveSharedWith(shared);
  }
}

class TextButtonWidget extends StatelessWidget {
  final String text;
  final Function() onTap;
  const TextButtonWidget({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
