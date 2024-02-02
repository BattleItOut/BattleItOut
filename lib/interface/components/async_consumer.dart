import 'package:battle_it_out/interface/components/future_builder_with_loading.dart';
import 'package:battle_it_out/utils/factory.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class AsyncConsumer<T extends Factory> extends StatelessWidget {
  final Widget Function(T) builder;
  final Future<void>? Function(T)? future;

  const AsyncConsumer({super.key, required this.builder, this.future});

  @override
  Widget build(BuildContext context) {
    return LoadingFutureBuilder(
      future: GetIt.instance.get<T>().init(),
      builder: (BuildContext context) {
        T provider = Provider.of(context);
        return LoadingFutureBuilder(
          future: future != null ? future!(provider) : null,
          builder: (BuildContext context) {
            return builder(provider);
          },
        );
      },
    );
  }
}
