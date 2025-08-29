import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'topic.dart';

class TopicDatabase extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final List<Topic> currentTopics = [];
  
  // Get current user ID
  String? get _userId => _supabase.auth.currentUser?.id;
  
  // --- TOPIC OPERATIONS ---
  
  Future<void> addTopic(String textFromUser) async {
    if (_userId == null) return;
    
    await _supabase.from('topics').insert({
      'text': textFromUser,
      'user_id': _userId,
    });
    await fetchTopics();
  }
  
  Future<void> fetchTopics() async {
    if (_userId == null) return;
    
    try {
      // Fetch topics with their associated notes using a JOIN
      final response = await _supabase
          .from('topics')
          .select('*, notes(*)')
          .eq('user_id', _userId)  // Only get current user's topics
          .order('created_at');
          
      currentTopics.clear();
      currentTopics.addAll(
        response.map((json) => Topic.fromJson(json)).toList()
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching topics: $e');
    }
  }
  
  Future<void> updateTopic(String id, String newText) async {
    if (_userId == null) return;
    
    try {
      await _supabase.from('topics').update({
        'text': newText,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id).eq('user_id', _userId);  // Ensure user owns this topic
      
      await fetchTopics();
    } catch (e) {
      debugPrint('Error updating topic: $e');
    }
  }
  
  Future<void> deleteTopic(String id) async {
    if (_userId == null) return;
    
    try {
      // This will cascade delete all notes in this topic
      await _supabase.from('topics')
          .delete()
          .eq('id', id)
          .eq('user_id', _userId);  // Ensure user owns this topic
      
      await fetchTopics();
    } catch (e) {
      debugPrint('Error deleting topic: $e');
    }
  }
  
  // --- NOTE OPERATIONS ---
  
  Future<void> addNoteToTopic(String topicId, String title, String content) async {
    if (_userId == null) return;
    
    try {
      await _supabase.from('notes').insert({
        'title': title,
        'content': content,
        'topic_id': topicId,
        'user_id': _userId,
      });
      await fetchTopics(); // Refresh to get updated topic with new note
    } catch (e) {
      debugPrint('Error adding note: $e');
    }
  }
  
  Future<void> updateNote(String noteId, String newTitle, String newContent) async {
    if (_userId == null) return;
    
    try {
      await _supabase.from('notes').update({
        'title': newTitle,
        'content': newContent,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', noteId).eq('user_id', _userId);  // Ensure user owns this note
      
      await fetchTopics();
    } catch (e) {
      debugPrint('Error updating note: $e');
    }
  }
  
  Future<void> deleteNote(String noteId) async {
    if (_userId == null) return;
    
    try {
      await _supabase.from('notes')
          .delete()
          .eq('id', noteId)
          .eq('user_id', _userId);  // Ensure user owns this note
      
      await fetchTopics();
    } catch (e) {
      debugPrint('Error deleting note: $e');
    }
  }
}