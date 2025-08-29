class Topic {
  final String? id;
  final String text;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Note>? notes; // Notes will be fetched separately or joined
  
  Topic({
    this.id, 
    required this.text, 
    this.createdAt, 
    this.updatedAt,
    this.notes,
  });
  
  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json['id'],
    text: json['text'],
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    // Notes can be included if we do a JOIN query
    notes: json['notes'] != null 
        ? (json['notes'] as List).map((note) => Note.fromJson(note)).toList()
        : null,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class Note {
  final String? id;
  final String title;
  final String content;
  final String topicId; // Foreign key to topics table
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.topicId,
    this.createdAt,
    this.updatedAt,
  });
  
  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    topicId: json['topic_id'],
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'topic_id': topicId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}