class Serie {
  int? id;
  String nome;
  String genero;
  String? descricao;
  String? foto;
  String usuario;

  Serie({
    this.id,
    required this.nome,
    required this.genero,
    this.descricao,
    this.foto,
    required this.usuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'genero': genero,
      'descricao': descricao,
      'foto': foto,
      'usuario': usuario,
    };
  }

  static Serie fromMap(Map<String, dynamic> map) {
    return Serie(
      id: map['id'],
      nome: map['nome'],
      genero: map['genero'],
      descricao: map['descricao'],
      foto: map['foto'],
      usuario: map['usuario'],
    );
  }
}
