import 'dart:async';

mixin ResourceManager {
  final List<StreamSubscription> _subscriptions = [];
  final List<Timer> _timers = [];
  final List<Completer> _completers = [];

  void registerSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  void registerTimer(Timer timer) {
    _timers.add(timer);
  }

  void registerCompleter(Completer completer) {
    _completers.add(completer);
  }

  void disposeResources() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();

    for (final completer in _completers) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
    _completers.clear();
  }
}

