import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep/models/notes_model.dart';

class SharedNotesDialog extends StatelessWidget {
  final NotesResponse note;
  const SharedNotesDialog({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 100 + (note.value!.imagePath != null ? 150 : 0),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.value!.title!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    _buildImage(note.value!.imagePath),
                    Text(
                      note.value!.description!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text('Shared By: ${note.value!.sharedBy}'),
                        const Spacer(),
                        _buildDateTime(note.value?.dateTime ?? 0),
                      ],
                    ),
                  ],
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
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildDateTime(int? date) {
    final formatter = DateFormat('MMM dd');
    final date = DateTime.fromMillisecondsSinceEpoch(note.value?.dateTime ?? 0);
    final dateString = formatter.format(date);
    return Text('Edited on: $dateString');
  }
}
