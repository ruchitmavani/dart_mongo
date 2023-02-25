import 'dart:convert';

class Note {
    String title;

  String description;

  Note({
      required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  factory Note.fromMap(Map<String, String> map) {
    return Note(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, String>);

  @override
  String toString() => 'Note(title: $title, description: $description)';
}
