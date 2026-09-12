import 'dart:async';
import 'dart:io';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  IOOverrides.global = OfflineSockets();
  HttpOverrides.global = OfflineHttp();
  await testMain();
}

bool _loopback(Object host) => switch (host) {
  InternetAddress(:final bool isLoopback) => isLoopback,
  'localhost' => true,
  final String name => InternetAddress.tryParse(name)?.isLoopback ?? false,
  _ => false,
};

Future<T> _refuse<T>(Object host) {
  final SocketException error = SocketException(
    'tests connect to loopback only, not $host',
  );
  Zone.current.handleUncaughtError(error, StackTrace.current);
  return Future<T>.error(error);
}

final class OfflineSockets extends IOOverrides {
  @override
  Future<Socket> socketConnect(
    dynamic host,
    int port, {
    dynamic sourceAddress,
    int sourcePort = 0,
    Duration? timeout,
  }) => _loopback(host as Object)
      ? super.socketConnect(
          host,
          port,
          sourceAddress: sourceAddress,
          sourcePort: sourcePort,
          timeout: timeout,
        )
      : _refuse(host);

  @override
  Future<ConnectionTask<Socket>> socketStartConnect(
    dynamic host,
    int port, {
    dynamic sourceAddress,
    int sourcePort = 0,
  }) => _loopback(host as Object)
      ? super.socketStartConnect(
          host,
          port,
          sourceAddress: sourceAddress,
          sourcePort: sourcePort,
        )
      : _refuse(host);
}

class OfflineHttp extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context);
    client.findProxy = (url) => 'DIRECT';
    client.connectionFactory = (url, proxyHost, proxyPort) {
      if (!_loopback(url.host)) return _refuse(url.host);
      if (url.scheme == 'https') {
        return SecureSocket.startConnect(url.host, url.port, context: context);
      }
      return Socket.startConnect(url.host, url.port);
    };
    return client;
  }
}
