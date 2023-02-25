import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'note_routes.dart';

/// Defines application's top-level routes
class AppRoutes {

  /// to query and insert data into MongoDb database
  final Db db;

  AppRoutes(this.db);

  Router get router {
    final router = Router();

    router.get('/', (Request request) {
      final aboutApp = {
        'name': 'MNote',
        'version': '1',
        'description': 'A minimal note management API to take and save notes'
      };
      return Response.ok(jsonEncode(aboutApp));
    });

    // router.mount('/users', UserRoutes(api: api).router);
    router.mount('/notes', NoteRoutes(db).router);

    router.all(
        '/<ignore|.*>',
        (Request r) =>
            Response.notFound(jsonEncode({'message': 'Route not defined'})));
    return router;
  }
}
