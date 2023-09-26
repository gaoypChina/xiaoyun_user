import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class NetworkOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      while (line.isNotEmpty) {
        if (line.length > 512) {
          print(line.substring(0, 512));
          line = line.substring(512, line.length);
        } else {
          print(line);
          line = "";
        }
      }
    }
  }
}

class LogsInterceptors extends InterceptorsWrapper {
  var logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
    ),
    output: NetworkOutput(),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d("Url: " + options.uri.toString());
    if (options.data != null) {
      String contentType = options.contentType.toString();
      if (contentType != 'multipart/form-data') {
        logger.d("Prams: " + options.data.toString());
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('Response: ' + response.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('Error message: ' + err.toString());
    super.onError(err, handler);
  }
}
