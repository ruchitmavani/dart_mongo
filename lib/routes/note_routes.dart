import 'package:dart_mongo/controllers/note_controller.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class NoteRoutes {
  final Db db;

  NoteRoutes(this.db);

  Router get router {
    final router = Router();

    router.get('/', (Request request) => NoteController(db).get());

    router.post('/', (Request request) => NoteController(db).store(request));

    router.get(
        '/<id>', (Request request, String id) => NoteController(db).show(id));

    router.delete('/<id>',
        (Request request, String id) => NoteController(db).destroy(id));

    router.put('/<id>', (request,id)=> NoteController(db).update(id,request));

    router.patch('/<id>', (request,id)=> NoteController(db).partialUpdate(id,request));


    return router;
  }
}
