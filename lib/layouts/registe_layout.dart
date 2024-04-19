import 'package:flutter/material.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/widgets/stepper.dart';
import 'package:medix/widgets/switch_theme.dart';

class RegisterLayout extends StatelessWidget {
  const RegisterLayout(
      {super.key,
      required this.child,
      required this.division,
      required this.page,
      this.onClickItem});

  final Widget child;
  final int division;
  final int page;
  final dynamic Function(int)? onClickItem;

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
      actions: const [
        SwitchThemeMode(),
      ],
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Stack(
              children: [
                StepperWidget(
                    onClickItem: onClickItem,
                    division: division,
                    page: page,
                    list: const ['1', '2', '3']),
                Padding(
                    padding: const EdgeInsets.only(top: 45.0), child: child),
              ],
            )),
      )),
    );
  }
}
