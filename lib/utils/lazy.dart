class Lazy<T> {
  T? item;
  Future<T> Function() refreshFunc;
  Lazy(this.item, this.refreshFunc);

  T get() => item!;

  Future<T?> refresh() async {
    item = await refreshFunc();
    return item;
  }

  Future<T> getAsync() async {
    item ??= await refreshFunc();
    return item!;
  }
}
