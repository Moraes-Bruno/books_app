class Livro {
  String? _id;
  String? _titulo;
  String? _imagem;

  Livro(this._id, this._titulo, this._imagem);

  String? getId() {
    return _id;
  }

  void setId(String id) {
    _id = id;
  }

  String? getTitulo() {
    return _titulo;
  }

  void setTitulo(String titulo) {
    _titulo = titulo;
  }

  String? getImagem() {
    return _imagem;
  }

  void setImagem(String imagem) {
    _imagem = imagem;
  }
}
