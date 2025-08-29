import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../models/topic.dart';
import '../models/topic_database.dart';
import 'package:provider/provider.dart';

class NoteEditorPage extends StatefulWidget {
  final int topicId;
  final Note? noteToEdit;

  const NoteEditorPage({
    super.key,
    required this.topicId,
    this.noteToEdit,
  });

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late QuillController _controller;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  void _loadNote() {
    if (widget.noteToEdit != null) {
      _titleController.text = widget.noteToEdit!.title;
      try {
        final doc = Document.fromJson(jsonDecode(widget.noteToEdit!.content));
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        // Handle case where content is not valid JSON
        _controller = QuillController.basic();
      }
    } else {
      _controller = QuillController.basic();
    }
  }

  void saveNote() {
    final db = context.read<TopicDatabase>();
    final title = _titleController.text.isNotEmpty ? _titleController.text : "Untitled Note";
    final content = jsonEncode(_controller.document.toDelta().toJson());

    if (widget.noteToEdit != null) {
      db.updateNote(widget.noteToEdit!.id, title, content);
    } else {
      db.addNoteToTopic(widget.topicId, title, content);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.noteToEdit == null ? "New Note" : "Edit Note"),
        actions: [IconButton(onPressed: saveNote, icon: const Icon(Icons.save))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Note Title...",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          
          // QuillSimpleToolbar with proper configuration
          QuillSimpleToolbar(
            controller: _controller,
            config: const QuillSimpleToolbarConfig(),
          ),
          
          const Divider(height: 1),
          
          // QuillEditor with proper configuration
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: QuillEditor.basic(
                controller: _controller,
                config: const QuillEditorConfig(
                  placeholder: 'Start typing your note...',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }
}