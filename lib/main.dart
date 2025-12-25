import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// URL іконки робота
const String robotIconUrl = 'https://emojiisland.com/cdn/shop/products/Robot_Emoji_Icon_abe1111a-1293-4668-bdf9-9ceb05cff58e_large.png?v=1571606090';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Previewer Navigation',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const FirstScreen(),
    );
  }
}

// --- ПЕРШИЙ ЕКРАН (Введення даних) ---
class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController _textController = TextEditingController();
  double _fontSize = 20.0;

  // --- ЗМІНЕНО: Метод для показу діалогового вікна з роботом ---
  void _showResultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        // Використовуємо Image.network замість Icon
        icon: Image.network(
          robotIconUrl,
          height: 70, // Встановлюємо висоту, щоб іконка не була занадто великою
          width: 70,
          errorBuilder: (context, error, stackTrace) {
            // Про всяк випадок, якщо інтернету немає, покажемо стандартну іконку
            return const Icon(Icons.error_outline, color: Colors.red, size: 50);
          },
        ),
        title: const Text('Message'), // Змінив заголовок на більш нейтральний
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  // Логіка переходу на другий екран (без змін)
  void _navigateToPreview(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondScreen(
          text: _textController.text,
          fontSize: _fontSize,
        ),
      ),
    );

    if (!mounted) return;

    if (result == 'ok') {
      _showResultDialog(context, 'Cool!');
    } else if (result == 'cancel') {
      _showResultDialog(context, 'Let’s try something else');
    } else {
      _showResultDialog(context, 'Don\'t know what to say');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Text',
                hintText: 'Enter text here',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Font size: ${_fontSize.toInt()}',
              style: const TextStyle(fontSize: 16),
            ),
            Slider(
              value: _fontSize,
              min: 10.0,
              max: 100.0,
              activeColor: Colors.deepPurple,
              onChanged: (double value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _navigateToPreview(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Preview'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ДРУГИЙ ЕКРАН (Попередній перегляд) --- (без суттєвих змін)
class SecondScreen extends StatelessWidget {
  final String text;
  final double fontSize;

  const SecondScreen({
    super.key,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[100],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(
                  text.isEmpty ? "No text provided" : text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'ok');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text('Ok'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, 'cancel');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    side: const BorderSide(color: Colors.deepPurple),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}