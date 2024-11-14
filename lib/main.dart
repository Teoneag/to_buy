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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> items = [];
  bool _isLoading = true;

  Future<void> _subscribeToItems() async {
    FireabseMethods.getItems().listen(
      (newItems) => setState(() {
        items = newItems;
        _isLoading = false;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _subscribeToItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To Buy')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                final item = items.removeAt(oldIndex);
                if (newIndex > oldIndex) newIndex--;
                items.insert(newIndex, item);
                setState(() {});
                FireabseMethods.updateItems(items);
              },
              children: items
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
                    FireabseMethods.addItem(value, items);
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
