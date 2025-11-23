class AppConstants {
  // API
  static const String baseUrl = 'https://grow-eg.online';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // OAuth Credentials - Owner (مالك)
  static const String ownerClientId =
      'vETGLhpg7tTrz81Ch4xzHM4T98LovawmdMgW2oKiIvI';
  static const String ownerClientSecret =
      'PI_V7d7lCFPI9JJmJJ5ZBo8vV4cFRQJ0zyNFE03YF80';

  // OAuth Credentials - Worker (عامل)
  static const String workerClientId =
      'WhA0_ohXG3ACaQ7dpreqhuCyG8ke8YGUfXvBte5eKuI';
  static const String workerClientSecret =
      'SquV8Cd-C1xqR3eJbUXn9MQ_s8fgiPVWuqPiRQruSeo';

  // Legacy OAuth Credentials (for backward compatibility)
  static const String clientId = 'rggNKgx2KdCMcCmx3qal3vFvLovO3uD3JkRH0RZmk04';
  static const String clientSecret =
      '44_20uZyqdP7Qc7haXjvYv1O9mnN8PInzBcVaBSDjh8';

  // SharedPreferences Keys
  static const String cachedUser = 'CACHED_USER';
  static const String accessToken = 'ACCESS_TOKEN';

  // App
  static const String appName = 'Coinly';
}
