class Livro {
  String? _id;
  String? _titulo;
  String? _descricao;
  String? _imagem;

  Livro(this._id, this._titulo,this._descricao,this._imagem);

Map<String, dynamic> toJson() {
    return {
      "id": getId(),
      "titulo": getTitulo(),
      "descricao": getDescricao(),
      "imagem": getImagem()
    };
  }

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

  String? getDescricao(){
    return _descricao;
  }
  
  void setDescricao(String descricao){
    _descricao = descricao;
  }

  String? getImagem() {
    return _imagem;
  }

  void setImagem(String imagem) {
    _imagem = imagem;
  }
}
