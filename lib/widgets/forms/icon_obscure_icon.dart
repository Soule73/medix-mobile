import 'package:flutter/material.dart';

obscureIcon({required BuildContext context, required isObscure}) {
  return isObscure
      ? Icon(Icons.visibility_off, color: Theme.of(context).primaryColor)
      : Icon(Icons.visibility, color: Theme.of(context).primaryColor);
}
