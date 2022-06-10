import 'package:dio/dio.dart';

final authHeaderInterceptor = InterceptorsWrapper(
  onRequest: (request, handler) async {
    /// AccessTokenが必要な場合はここに設定する
    const accessToken = '';
    request.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(request);
  },
);
