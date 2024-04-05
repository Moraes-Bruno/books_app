import 'package:books_app/model/livro.dart';
import 'package:books_app/repository/sqlite.dart';


class sqliteCrud{
  sqliteCrud();

  Future<void> salvarLista(Livro livro) async {
  var db = await SQliteDataBase().obterDataBase();
  await db.rawInsert(
    'INSERT INTO livros (titulo, descricao, imagem) VALUES (?,?,?)',
    [livro.getTitulo(), livro.getDescricao(), livro.getImagem()]
  );

}


   Future<List<Livro>> recuperarLista() async {
  List<Livro> livros = [];
  var db = await SQliteDataBase().obterDataBase();
  var result = await db.rawQuery('SELECT * FROM livros');
  for (var element in result) {
     livros.add(Livro(
      element["id"].toString(),
      element["titulo"].toString(),
      element["descricao"].toString(),
      element["imagem"].toString(),
    ));
  }
  return livros;
}

Future<void> excluirLivro(String nome) async {
  var db = await SQliteDataBase().obterDataBase();
  await db.delete('livros', where: 'titulo = ?', whereArgs: [nome]);
}

}

