import 'package:flutter/material.dart';
import 'package:keep/models/notes_model.dart';

class GridItem extends StatelessWidget {
  final NotesResponse note;

  const GridItem({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.value!.title != null && note.value!.title!.isNotEmpty)
              Text(
                note.value!.title!,
                style: Theme.of(context).textTheme.headline6,
              ),
            if (note.value!.description != null && note.value!.description!.isNotEmpty)
              Text(
                note.value!.description!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
          ],
        ),
      ),
    );
  }
}
