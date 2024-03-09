class Lazy<T> {
  T? item;
  bool ready = false;
  Future<T> Function() refreshFunc;
  Lazy(this.refreshFunc);

  T get() => item!;

  Future<T> getAsync() async {
    if (!ready) {
      T item = await refreshFunc();
      this.item = item;
      ready = true;
    }
    return item!;
  }
}
