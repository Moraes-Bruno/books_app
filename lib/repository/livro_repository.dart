import 'package:http/http.dart' as http;
import 'dart:convert';

//import '../model/livro.dart';

class LivroRepository {
  Future<Map> buscarLivros(String busca) async {
    //await dotenv.load(fileName: "keys.env");
    //var key = dotenv.env['API_KEY'];
    var key = "AIzaSyBL 58nGhwlXnzR-9HRgXXRt fLMQ1G0oggM";
    var uri = Uri.https("www.googleapis.com", "/books/v1/volumes",
        {"q": busca, "langRestrict": "br", "projection": "lite", "key": key});
    var resultado = await http.get(uri);
    var retorno = json.decode(resultado.body);

    print(retorno);
    /*List<Livro> listLivro = [];

    for (var elemento in retorno["items"]) {
      Livro livro = Livro(elemento["id"], elemento["volumeInfo"]["title"],
          elemento["volumeInfo"]["imageLinks"]["thumbnail"]);
      listLivro.add(livro);
    }*/

    return retorno;
  }
}
