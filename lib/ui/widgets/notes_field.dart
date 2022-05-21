import 'package:flutter/material.dart';

class NotesTextField extends StatefulWidget {
  final Function(String, String) onSave;
  const NotesTextField({Key? key, required this.onSave}) : super(key: key);

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
    widget.onSave(title, description);
  }
}
