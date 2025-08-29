import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/drawer.dart';
import '../components/topic_tile.dart';
import '../models/topic.dart';
import '../models/topic_database.dart';
import 'package:provider/provider.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  // text controller to access what the user typed
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // on app startup, fetch existing topics
    readTopics();
  }

  // create a topic
  void createTopic() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: textController,
        ),
        actions: [
          // create button
          MaterialButton(onPressed: () {
            // add to db
            context.read<TopicDatabase>().addTopic(textController.text);

            // clear controller
            textController.clear();

            // pop dialog box
            Navigator.pop(context);
          },
          child: const Text("Create"),
          )
        ],
      ),
    );
  }

  // read topics
  void readTopics() {
    context.read<TopicDatabase>().fetchTopics();
  }

  // update a topic
  void updateTopic(Topic topic) {
    // pre-fill the current topic text
    textController.text = topic.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text("Update Topic"), // Update Notes prev.
        content: TextField(controller: textController),
        actions: [
          // update button
          MaterialButton(
            onPressed: () {
              // update topic in db
              context
                  .read<TopicDatabase>()
                  .updateTopic(topic.id, textController.text);
              // clear controller
              textController.clear();
              // pop dialog box
              Navigator.pop(context);
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  // delete a topic
  void deleteTopic(int id) {
    context.read<TopicDatabase>().deleteTopic(id);
  }

  @override
  Widget build(BuildContext context) {
    // topic database
    final topicDatabase = context.watch<TopicDatabase>();

    // current topics
    List<Topic> currentTopics = topicDatabase.currentTopics;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createTopic,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADING
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Topics',
              style: GoogleFonts.inter(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          // LIST OF NOTES
          Expanded(
            child: ListView.builder(
              itemCount: currentTopics.length,
              itemBuilder: (context, index) {
                // get individual topic
                final topic = currentTopics[index];

                // list tile UI
                return TopicTile(
                  text: topic.text,
                  onEditPressed: () => updateTopic(topic),
                  onDeletePressed: () => deleteTopic(topic.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}