import 'dart:convert';
import 'package:shelf/shelf.dart';

class Helper {
  /// A helper function that returns a `500 Internal Server Error` JSON
  /// error response. Takes an optional [message] argument to return.
  static Response error({String? message}) {
    return Response.internalServerError(
        body: jsonEncode({'message': (message ?? 'There was an error')}));
  }
}