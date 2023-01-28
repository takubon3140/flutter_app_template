import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import '../../../extensions/context_extension.dart';
import '../../../extensions/exception_extension.dart';
import '../../custom_hooks/use_effect_once.dart';
import '../../widgets/rounded_button.dart';
import '../main/main_page.dart';
import 'start_up_controller.dart';

class StartUpPage extends HookConsumerWidget {
  const StartUpPage({super.key});

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true)
        .pushReplacement<MaterialPageRoute<dynamic>, void>(
      PageTransition(
        type: PageTransitionType.fade,
        child: const StartUpPage(),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(startUpControllerProvider);

    useEffectOnce(() {
      Future(() async {
        await ref.read(startUpControllerProvider.future);
        unawaited(MainPage.show(context));
      });
      return null;
    });

    return Scaffold(
      body: Center(
        child: asyncValue.when(
          data: (_) {
            return const CupertinoActivityIndicator();
          },
          error: (e, __) {
            final error = e as Exception?;
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'エラー\n${error?.errorMessage}',
                    style: context.bodyStyle.copyWith(
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  RoundedButton(
                    child: Text(
                      'リトライ',
                      style: context.bodyStyle.copyWith(color: Colors.white),
                    ),
                    onTap: () {
                      ref.invalidate(startUpControllerProvider);
                    },
                  ),
                ],
              ),
            );
          },
          loading: () {
            return const CupertinoActivityIndicator();
          },
        ),
      ),
    );
  }
}