class ApiConfig {
  ApiConfig._();

  static const String baseUrl = "https://api.todoist.com/rest/v2";

  static const String token = '1d4e4b18ec452878f50242d0adfb2648c8ab8b3f';
  static const Duration receiveTimeout = Duration(milliseconds: 15000);
  static const Duration connectionTimeout = Duration(milliseconds: 15000);

  static const String tasks = "/tasks";
  static const String projects = "/projects";
  static const String sections = "/sections";
  static const String comments = "/comments";

  static const String syncBaseUrl = 'https://api.todoist.com/sync/v9';
  static const String sync = '/sync';
  static const String completedTasks = '/completed/get_all';
}
