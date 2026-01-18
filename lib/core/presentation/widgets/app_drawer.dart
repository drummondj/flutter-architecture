import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              TextButton.icon(
                label: Text("Todos"),
                onPressed: () {},
                icon: Icon(Icons.list_alt_outlined),
              ),
              TextButton.icon(
                label: Text("Tags"),
                onPressed: () {},
                icon: Icon(Icons.tag_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
