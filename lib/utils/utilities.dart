class Wrapper<T> {
  T? object;

  Wrapper([this.object]);
}

String warning(String text) {
  return '\x1B[33m$text\x1B[0m';
}
