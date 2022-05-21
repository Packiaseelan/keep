import 'package:flutter/material.dart';
import 'package:keep/models/notes_model.dart';

class GridItem extends StatelessWidget {
  final NotesResponse note;
  final Function() onPinned;
  final Function() onDelete;

  const GridItem({
    Key? key,
    required this.note,
    required this.onPinned,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButtonWidget(icon: note.value?.isPinned ?? false ? Icons.push_pin_sharp : Icons.push_pin_outlined, onTap: onPinned),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButtonWidget(icon: Icons.delete, onTap: onDelete),
        ),
      ],
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final Color bgColor;
  final Color iconColor;
  const IconButtonWidget({
    Key? key,
    required this.icon,
    required this.onTap,
    this.bgColor = Colors.black12,
    this.iconColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(icon, size: 15, color: iconColor),
        ),
      ),
    );
  }
}
