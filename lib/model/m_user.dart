import 'dart:convert';

LoginModel usersModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String usersModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel(
      {required this.idUser,
      required this.username,
      required this.nama,
      required this.idToko,
      required this.namaToko});

  int idUser;
  String username;
  String nama;
  int idToko;
  String namaToko;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty || json.containsKey('message')) {
      return LoginModel(
          idUser: 0, username: '', nama: '', idToko: 0, namaToko: '');
    }
    return LoginModel(
        idUser: json["idUser"],
        username: json["username"],
        nama: json["nama"],
        idToko: json["idToko"],
        namaToko: json["namaToko"]);
  }

  Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "username": username,
        "nama": nama,
        "idToko": idToko,
        "namaToko": namaToko
      };
}
