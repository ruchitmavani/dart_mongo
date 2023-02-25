import 'dart:io';

import 'package:dart_mongo/helper/middleware.dart';
import 'package:dart_mongo/routes/app_routes.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as server;
import 'package:shelf_router/shelf_router.dart';

Future<void> main(List<String> args) async {
  try {
    var port = 4000;
    var dbName = 'ruchit';

    final db = await Db.create(
        'mongodb+srv://ruchit:ruchit123@cluster.ammng.mongodb.net:$port/$dbName?retryWrites=true&w=majority');
    await db.open();
    await db.createCollection('users');
    await db.createCollection('notes');
    final app = Router();

    app.mount('/v1', AppRoutes(db).router);

    final handler = const Pipeline()
        .addMiddleware(ensureResponsesHaveHeaders())
        .addMiddleware(logRequests())
        .addHandler(app);

    final mServer = await server.serve(handler, InternetAddress.anyIPv4, 8080);
    print('Server started at http://${mServer.address.host}:${mServer.port}');
  } catch (e) {
    print(e);
  }
}
