import 'package:shelf/shelf.dart';

Middleware ensureResponsesHaveHeaders() {
  return createMiddleware(responseHandler: (response) {
    return response.change(headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'max-age=604800',
    });
  });
}
