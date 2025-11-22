enum LoadingStatus {
  checkingConnection,
  loadingConfig,
  initializingDependencies,
  initializingStorage,
  initializingConnectivity,
  initializingNotifications,
  initializingAuth,
  initializingRadio,
  preparingApp,
  complete,
}

class LoadingState {
  final double progress;
  final LoadingStatus status;
  final String? errorMessage;

  const LoadingState({
    this.progress = 0.0,
    this.status = LoadingStatus.checkingConnection,
    this.errorMessage,
  });

  LoadingState copyWith({
    double? progress,
    LoadingStatus? status,
    String? errorMessage,
  }) {
    return LoadingState(
      progress: progress ?? this.progress,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoadingStateNotifier {
  LoadingState _state = const LoadingState();

  LoadingState get state => _state;

  void updateProgress(double progress, LoadingStatus status) {
    _state = _state.copyWith(
      progress: progress.clamp(0.0, 1.0),
      status: status,
    );
  }

  void setError(String errorMessage) {
    _state = _state.copyWith(errorMessage: errorMessage);
  }

  void reset() {
    _state = const LoadingState();
  }
}

