import 'package:flutter/material.dart';

class NewsTile extends StatelessWidget {
  final String title;
  final String source;

  const NewsTile({super.key, required this.title, required this.source});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title),
        subtitle: Text(source),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {
          // You can route to full news article in future
        },
      ),
    );
  }
}