extension ListExt<T> on List<T> {
  T? find(bool Function(T index) predicate) {
    try {
      return firstWhere(predicate);
    } on StateError {
      return null;
    }
  }
}
