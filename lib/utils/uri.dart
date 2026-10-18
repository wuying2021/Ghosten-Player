import 'package:api/api.dart';

extension UriExtension on Uri {
  Uri normalize() {
    if (scheme.toLowerCase() == 'file') {
      return this;
    } else {
      return replace(
        scheme: scheme.isEmpty ? Api.baseUrl.scheme : null,
        host: host.isEmpty ? Api.baseUrl.host : null,
        port: port == 0 ? Api.baseUrl.port : null,
      );
    }
  }
}
