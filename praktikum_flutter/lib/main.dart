import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widget Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WidgetDemoPage(),
    );
  }
}

class WidgetDemoPage extends StatelessWidget {
  const WidgetDemoPage({super.key});

  static const List<String> builderItems = [
    'Item Dinamis 1',
    'Item Dinamis 2',
    'Item Dinamis 3',
    'Item Dinamis 4',
    'Item Dinamis 5',
  ];

  static const List<String> separatedItems = [
    'Data A',
    'Data B',
    'Data C',
    'Data D',
  ];

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Widget Flutter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Container (Kotak Berwarna)'),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.indigo.shade300,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Ini adalah Container',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            buildSectionTitle('Stack (Tumpukan Widget)'),
            SizedBox(
              height: 180,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade600,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const Text(
                      'Stack',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            buildSectionTitle('GridView (6 Item)'),
            SizedBox(
              height: 220,
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(6, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100.withOpacity((index + 1) / 6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Grid ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ),
            ),
            buildSectionTitle('ListView (Statis A, B, C)'),
            SizedBox(
              height: 140,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ListTile(title: Text('A')),
                  ListTile(title: Text('B')),
                  ListTile(title: Text('C')),
                ],
              ),
            ),
            buildSectionTitle('ListView.builder (Dari Array)'),
            SizedBox(
              height: 180,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: builderItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade200,
                        child: Text('${index + 1}'),
                      ),
                      title: Text(builderItems[index]),
                    ),
                  );
                },
              ),
            ),
            buildSectionTitle('ListView.separated (Dengan Garis)'),
            SizedBox(
              height: 180,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: separatedItems.length,
                separatorBuilder: (context, index) {
                  return const Divider(color: Colors.grey);
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.label, color: Colors.purple.shade400),
                    title: Text(separatedItems[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
