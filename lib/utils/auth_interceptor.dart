import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final String authToken;

  AuthInterceptor(this.authToken);

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add the bearer token to the request headers
    options.headers['Authorization'] = 'Bearer $authToken';
    return super.onRequest(options, handler);
  }
}
