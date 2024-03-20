import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.get('SUPABSE_URL'),
    anonKey: dotenv.get('SUPABSE_ANON_KEY'),
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 2,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(supabase: Supabase.instance.client),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.supabase});
  final SupabaseClient supabase;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _documentId = "";
  late RealtimeChannel _subscription;
  final List<dynamic> _trackerData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _subscription = widget.supabase
        .channel('public:tracker')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'tracker',
            callback: (PostgresChangePayload payload) {
              final Map<String, dynamic> newRecord = payload.newRecord;
              setState(() {
                _trackerData.add(newRecord);
              });
            })
        .subscribe();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.supabase.removeChannel(_subscription);
    super.dispose();
  }

  Future<void> _createDocument() async {
    final response = await widget.supabase.functions
        .invoke("document_create", body: {"name": "test"});

    final responseData = response.data as Map<String, dynamic>;
    final documentId = responseData['id'] as String;

    setState(() {
      _documentId = documentId;
    });
  }

  Future<void> _runWorkflow() async {
    await widget.supabase.functions.invoke('workflow_run', body: {
      "workflowName": "main_process",
      "body": {"token": "test-token", "document_id": _documentId},
      "documentId": _documentId
    });
  }

  Future<void> _makeDecision(String decision) async {
    await widget.supabase.functions.invoke('workflow_decision',
        body: {"documentId": _documentId, "decision": decision});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App Title'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Your document id:',
                ),
                Text(
                  _documentId,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: _createDocument,
                tooltip: 'Create',
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                onPressed: _runWorkflow,
                tooltip: 'Run Workflow',
                child: const Icon(Icons.run_circle),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _makeDecision("APPROVED");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Approve"),
                ),
                const SizedBox(width: 5.0),
                ElevatedButton(
                  onPressed: () {
                    _makeDecision("REJECTED");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Reject"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _trackerData.length,
              itemBuilder: (context, index) {
                final change = _trackerData[index];
                // Преобразуйте объект Map в строку
                final changeAsString = change.toString();
                // Возвращаем ListTile с строковым представлением изменения
                return ListTile(
                  title: Text('Change ${index + 1}'),
                  subtitle: Text('Data: $changeAsString'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
