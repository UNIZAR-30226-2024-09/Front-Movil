class UserPassword {
    final String correo;
    final String contrasegna;

    UserPassword({required this.correo, required this.contrasegna});

    factory UserPassword.fromJSon(Map <String, dynamic> json){
      return UserPassword(
        correo: json['correo'],
        contrasegna: json['contrasegna'],
      );
    }

    Map<String, dynamic> toJson() => {
      'usuario' : correo,
      'contrasegna': contrasegna,
    };
}