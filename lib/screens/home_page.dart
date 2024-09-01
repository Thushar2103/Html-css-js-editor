import 'dart:io';
import 'package:html_css_js/screens/editor_screen.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Directory> _getManageDirectory() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final manageDir = Directory('${appDocumentDir.path}/Tascuit/Webcreate/');

    if (!await manageDir.exists()) {
      await manageDir.create(recursive: true);
    }

    return manageDir;
  }

  Future<List<File>> _loadFiles() async {
    final manageDir = await _getManageDirectory();
    final files =
        manageDir.listSync().where((file) => file.path.endsWith('')).toList();
    return files.map((file) => File(file.path)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tascuit'),
            Text(
              'Webcreate',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<File>>(
        future: _loadFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading documents'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No documents found'));
          } else {
            final documents = snapshot.data!;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                final fileName = document.path;
                return ListTile(
                  title: Text(
                    basenameWithoutExtension(fileName),
                  ),
                  trailing: IconButton(
                      // onPressed: () => _confirmDelete(context, document),
                      onPressed: () {},
                      icon: const Icon(Icons.delete)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              // Notes_editor(filePath: document.path),
                              EditorScreen()),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
