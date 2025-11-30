import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoggerObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
      ProviderBase provider,
      Object? prevValue,
      Object? newValue,
      ProviderContainer container,
      ) {
    print('Provider: ${provider.name}');
    print('Old Value: $prevValue');
    print('New Value: $newValue');
  }

  @override
  void didAddProvider(
      ProviderBase provider,
      Object? value,
      ProviderContainer container,
      ) {
    print('Added provider: ${provider.name}');
  }

  @override
  void didDisposeProvider(
      ProviderBase provider,
      ProviderContainer container,
      ) {
    print('Disposed provider: ${provider.name}');
  }
}
