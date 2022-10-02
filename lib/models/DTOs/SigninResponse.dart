

class SigninResponse {
  String username;
  SigninResponse(this.username);

  SigninResponse.fromJson(Map<String, dynamic> json)
      : username = json['username'];
}
