import 'package:dio/dio.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:kickmyflutter/models/DTOs/SigninResponse.dart';
import 'package:kickmyflutter/models/DTOs/SignupRequest.dart';
import 'package:kickmyflutter/models/SingletonDio.dart';

const dev = false;
const URL_ENDPOINT = dev
    ? 'http://10.0.2.2:8080/api/id'
    : 'https://kickmyb-server.herokuapp.com/api/id';

Future<SigninResponse> signUp(SignupRequest request) async {
  final response =
  await SingletonDio.getDio().post("$URL_ENDPOINT/signup", data: request);

  final cookies = await SingletonDio.cookieManager.cookieJar
      .loadForRequest(Uri.parse(URL_ENDPOINT));
  await SessionManager().set("auth-cookie", cookies.first.value);
  await SessionManager().set("username", request.username);

  return SigninResponse.fromJson(response.data);
}

Future<SigninResponse> signIn(SignupRequest request) async {
  final response =
      await SingletonDio.getDio().post("$URL_ENDPOINT/signin", data: request);

  final cookies = await SingletonDio.cookieManager.cookieJar
      .loadForRequest(Uri.parse(URL_ENDPOINT));
  await SessionManager().set("auth-cookie", cookies.first.value);
  await SessionManager().set("username", request.username);

  return SigninResponse.fromJson(response.data);
}

Future<void> signOut(SignupRequest request) async {
  final response =
      await SingletonDio.getDio().post("$URL_ENDPOINT/signout", data: request);

  await SessionManager().destroy();
}
