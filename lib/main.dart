import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'fireabse_methods.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'To Buy',
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To Buy')),
      body: StreamBuilder(
        stream: FireabseMethods.getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              final items = snapshot.data!;
              final item = items.removeAt(oldIndex);
              if (newIndex > oldIndex) newIndex--;
              items.insert(newIndex, item);
              FireabseMethods.updateItems(items);
            },
            children: snapshot.data!
                .map(
                  (item) => ListTile(
                    key: ValueKey(item),
                    title: Text(item),
                    leading: IconButton(
                      icon: const Icon(Icons.circle_outlined),
                      onPressed: () => FireabseMethods.deleteItem(item),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Task'),
              content: TextField(
                focusNode: FocusNode()..requestFocus(),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    FireabseMethods.addItem(value);
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
