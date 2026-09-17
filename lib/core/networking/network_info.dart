import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    // result is now a List<ConnectivityResult> in newer connectivity_plus versions
    // So we check if it doesn't contain just .none, or if it has any valid connection
    return !result.contains(ConnectivityResult.none) || result.isNotEmpty;
  }
}
