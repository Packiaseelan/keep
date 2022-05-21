import 'package:flutter/material.dart';
import 'package:keep/models/notes_model.dart';

class GridItemShared extends StatelessWidget {
  final NotesResponse note;
  const GridItemShared({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
       width: double.infinity,
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
                    overflow: TextOverflow.ellipsis,
                  ),
                if (note.value!.description != null && note.value!.description!.isNotEmpty)
                  Text(
                    note.value!.description!,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          )
    );
  }
}