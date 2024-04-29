class ApiEndPoints {
  static const String baseUrl = 'https://reqres.in';
  static final _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerUrl = '/api/register';
  final String loginUrl = '/api/login';
}
