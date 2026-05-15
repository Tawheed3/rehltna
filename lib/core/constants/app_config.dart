/// Compile-time configuration.
///
/// For production builds, inject values via --dart-define so the key is NOT
/// embedded as a plain string in the binary:
///
///   flutter build apk \
///     --dart-define=API_BASE_URL=https://admin.rehltna.com/api/v1 \
///     --dart-define=API_KEY=YOUR_KEY \
///     --dart-define=TENANT_ID=1
///
/// The defaultValue fields below are used only for local development.
/// Do NOT ship a production build without passing --dart-define=API_KEY.
class AppConfig {
  const AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://admin.rehltna.com/api/v1',
  );

  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'P4OIp8prRKBeO0kogfGViTNzmAT8UnzL',
  );

  static const int tenantId = int.fromEnvironment(
    'TENANT_ID',
    defaultValue: 1,
  );
}
