import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/topic_database.dart';
import 'note_editor_page.dart';
import 'package:provider/provider.dart';

class NotesListPage extends StatefulWidget {
  final Topic topic;

  const NotesListPage({super.key, required this.topic});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TopicDatabase>(
      builder: (context, db, child) {
        // Find the latest version of the topic to get its notes
        final Topic currentTopic =
            db.currentTopics.firstWhere((t) => t.id == widget.topic.id);

        // Load notes associated with the topic
        final List<Note> notes = currentTopic.notes.toList();

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(currentTopic.text),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigate to the editor to create a new note
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditorPage(
                    topicId: currentTopic.id,
                  ),
                ),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: notes.isEmpty
                ? Center(
                    child: Text(
                      "No notes yet...",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.only(top: 10),
                        child: ListTile(
                          title: Text(note.title),
                          onTap: () {
                            // Navigate to the editor to update the selected note
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteEditorPage(
                                  topicId: currentTopic.id,
                                  noteToEdit: note,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}