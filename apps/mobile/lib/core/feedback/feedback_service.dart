enum FeedbackSeverity { info, warning, error }

abstract interface class FeedbackService {
  void show(FeedbackSeverity severity, String message);
}

extension FeedbackServiceShortcuts on FeedbackService {
  void showInfo(String message) => show(FeedbackSeverity.info, message);
  void showWarning(String message) => show(FeedbackSeverity.warning, message);
  void showError(String message) => show(FeedbackSeverity.error, message);
}
