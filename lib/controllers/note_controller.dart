import 'dart:convert';

import 'package:dart_mongo/helper/helper.dart';
import 'package:dart_mongo/model/notes_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

class NoteController {
  final Db db;

  NoteController(this.db);

  /// Deletes the note with the given [id]
  Future<Response> destroy(String id) async {
    try {
      if (id.length != 24) {
        return Response(400,
            body: jsonEncode({
              "Bad Request":
                  "Expected hexadecimal string with length of 24, got $id"
            }));
      }
      var call = db.collection('notes');
      final result = await call.remove(where.eq('_id', ObjectId.parse(id)));
      return Response(200,
          body: jsonEncode({"Message": "data deleted successfully."}));
    } on Exception catch (e) {
      return Helper.error(message: e.toString());
    }
  }

  /// Lists all notes
  Future<Response> get() async {
    try {
      var call = db.collection('notes');
      final result = await call.find().toList();
      return Response(200, body: jsonEncode(result));
    } on Exception catch (e) {
      return Helper.error(message: e.toString());
    }
  }

  /// Retrieves the note with the given [id]
  Future<Response> show(String id) async {
    try {
      if (id.length != 24) {
        return Response(400,
            body: jsonEncode({
              "Bad Request":
                  "Expected hexadecimal string with length of 24, got $id"
            }));
      }
      var call = db.collection('notes');
      final result = await call.findOne({'_id': ObjectId.parse(id)});
      print(result);
      if (result == null) {
        return Response(404);
      }
      return Response(200, body: jsonEncode(result));
    } on Exception catch (e) {
      return Helper.error(message: e.toString());
    }
  }

  /// Saves a note into mongoDb
  Future<Response> store(Request request) async {
    try {
      final req = await request.readAsString();
      final isEmpty = request.isEmpty || req.trim().isEmpty;

      if (isEmpty) {
        return Response.forbidden(jsonEncode({'message': 'Bad request'}));
      }

      final json = jsonDecode(req) as Map<String, dynamic>;
      final title = (json['title'] ?? '') as String;
      final description = (json['description'] ?? '') as String;

      if (title.isEmpty || description.isEmpty) {
        return Response.forbidden(
            jsonEncode({'message': 'title and description both are required'}));
      }

      final note = Note(
        title: title,
        description: description,
      );

      print("store called.");
      print(note.toMap());
      var coll = db.collection("notes");
      print(coll.collectionName);
      WriteResult data = await coll.insertOne(
        note.toMap(),
      );
      return Response(201,
          body: jsonEncode(
            {'message': 'note added successfully.', 'data': data.document},
          ));
    } on Exception catch (e) {
      return Helper.error(message: e.toString());
    }
  }

  Future<Response> update(String id, Request request) async {
    try {
      if (id.length != 24) {
        return Response(400,
            body: jsonEncode({
              "Bad Request":
                  "Expected hexadecimal string with length of 24, got $id"
            }));
      }
      var call = db.collection('notes');
      final result = await call.findOne({'_id': ObjectId.parse(id)});
      if (result == null) {
        return Response(404);
      }

      final req = await request.readAsString();
      final isEmpty = request.isEmpty || req.trim().isEmpty;

      if (isEmpty) {
        return Response.forbidden(jsonEncode({'message': 'Bad request'}));
      }

      final json = jsonDecode(req) as Map<String, dynamic>;
      final title = (json['title'] ?? '') as String;
      final description = (json['description'] ?? '') as String;

      if (title.isEmpty || description.isEmpty) {
        return Response.forbidden(
            jsonEncode({'message': 'title and description are required'}));
      }

      final note = Note(
        title: title,
        description: description,
      );

      final resultUpdate =
          await call.modernUpdate({'_id': ObjectId.parse(id)}, note.toMap());

      return Response(200, body: jsonEncode({"message": "data is updated"}));
    } on Exception catch (e) {
      return Helper.error(message: e.toString());
    }
  }

  Future<Response> partialUpdate(String id, Request request) async {
    try {
      if (id.length != 24) {
        return Response(400,
            body: jsonEncode({
              "Bad Request":
                  "Expected hexadecimal string with length of 24, got $id"
            }));
      }
      var call = db.collection('notes');
      final result = await call.findOne({'_id': ObjectId.parse(id)});
      if (result == null) {
        return Response(404);
      }

      final req = await request.readAsString();
      final isEmpty = request.isEmpty || req.trim().isEmpty;

      if (isEmpty) {
        return Response.forbidden(
            jsonEncode({'message': 'title or description are required'}));
      }

      final json = jsonDecode(req) as Map<String, dynamic>;
      final title = (json['title'] ?? '') as String;
      final description = (json['description'] ?? '') as String;

      if (title.isEmpty && description.isEmpty) {
        return Response.forbidden(
            jsonEncode({'message': 'title or description are required'}));
      }

      final note = Note(
        title: title,
        description: description,
      );

      final resultUpdate = await call.modernFindAndModify(query: {
        '_id': ObjectId.parse(id)
      }, update: {
        "\$set": {
          if (title.isNotEmpty) "title": title,
          if (description.isNotEmpty) "description": description
        }
      }, upsert: true);

      return Response(200, body: jsonEncode({"message": "data is updated"}));
    } on Exception catch (e) {
      return Helper.error(message: e.toString());
    }
  }
}
