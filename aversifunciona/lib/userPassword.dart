class UserPassword {
    final String correo;
    final String contrasegna;

    UserPassword({required this.correo, required this.contrasegna});

    factory UserPassword.fromJson(Map <String, dynamic> json){
      return UserPassword(
        correo: json['correo'],
        contrasegna: json['contrasegna'],
      );
    }

    Map<String, dynamic> toJson() => {
      'correo' : correo,
      'contrasegna': contrasegna,
    };
}