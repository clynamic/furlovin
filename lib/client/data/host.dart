const String faDomain = 'furaffinity.net';
const String faHost = 'www.$faDomain';
const String faOrigin = 'https://$faHost';

bool isFaHost(String? host) {
  if (host == null) return false;
  final String value = host.toLowerCase();
  return value == faDomain || value.endsWith('.$faDomain');
}
