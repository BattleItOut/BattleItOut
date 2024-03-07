import 'package:battle_it_out/interface/components/future_builder_with_loading.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class AsyncConsumer<T extends Factory> extends StatelessWidget {
  final Widget Function(T) builder;
  final Future<void>? Function(T)? future;

  Future<void>? getAsyncData(T provider) async {
    if (future != null) {
      return future!(provider);
    }
    return;
  }

  const AsyncConsumer({super.key, required this.builder, this.future});
  @override
  Widget build(BuildContext context) {
    return LoadingFutureBuilder(
      future: GetIt.instance.get<T>().init(),
      builder: (BuildContext context) {
        T provider = Provider.of(context);
        return LoadingFutureBuilder<void>(
          future: getAsyncData(provider),
          builder: (BuildContext context) {
            return builder(provider);
          },
        );
      },
    );
  }
}

class AsyncConsumer2<T1 extends Factory, T2 extends Factory> extends StatelessWidget {
  final Widget Function(T1, T2) builder;
  final Future<void>? Function(T1, T2)? future;

  Future<void>? getAsyncData(T1 provider1, T2 provider2) async {
    if (future != null) {
      return future!(provider1, provider2);
    }
    return;
  }

  Future<void>? initProviders() async {
    GetIt.instance.get<T1>().init();
    GetIt.instance.get<T2>().init();
  }

  const AsyncConsumer2({super.key, required this.builder, this.future});
  @override
  Widget build(BuildContext context) {
    return LoadingFutureBuilder(
      future: initProviders(),
      builder: (BuildContext context) {
        T1 provider1 = Provider.of(context);
        T2 provider2 = Provider.of(context);
        return LoadingFutureBuilder(
          future: getAsyncData(provider1, provider2),
          builder: (BuildContext context) => builder(provider1, provider2),
        );
      },
    );
  }
}
