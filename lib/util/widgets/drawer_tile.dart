import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String texto;
  final IconData? icon;
  final void Function()? onTap;

  const DrawerTile({
    super.key,
    required this.texto,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        texto,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      onTap: onTap,
    );
  }
}
