import 'package:flutter/material.dart';
import 'package:duva_app/screens/dua_add_edit_screen.dart';

class DuaCard extends StatelessWidget {
  final Map<String, dynamic> dua;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const DuaCard({
    super.key,
    required this.dua,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          dua['title'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(dua['text'], maxLines: 3, overflow: TextOverflow.fade),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DuaAddEditScreen(dua: dua),
                  ),
                ).then((_) => onEdit());
              },
              icon: Icon(Icons.edit, color: Colors.amber),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete_forever, color: Colors.redAccent),
            ),
          ],
        ),
        onTap: () {
          //TODO: Navigate to Dua Details Screen
        },
      ),
    );
  }
}
