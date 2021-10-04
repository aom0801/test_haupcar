import 'package:http/http.dart' as http;

class ApiProvider {
  ApiProvider();
  //
  String apiUrl = 'https://api.publicapis.org/categories';

  Future<http.Response> getPost() async {
    return await http.get('$apiUrl/post');
  }

  Future<http.Response> getPostView() async {
    return await http.get('$apiUrl/post');
  }
}
