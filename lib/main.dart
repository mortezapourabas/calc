import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ماشین حساب ساده',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String previousValue = '';
  String operation = '';
  bool shouldResetDisplay = false;

  void appendNumber(String number) {
    setState(() {
      if (display == '0' || shouldResetDisplay) {
        display = number;
        shouldResetDisplay = false;
      } else {
        display += number;
      }
    });
  }

  void appendDecimal() {
    setState(() {
      if (!display.contains('.')) {
        display += '.';
      }
    });
  }

  void setOperation(String op) {
    setState(() {
      previousValue = display;
      operation = op;
      shouldResetDisplay = true;
    });
  }

  void calculate() {
    if (previousValue.isEmpty || operation.isEmpty) return;

    double prev = double.parse(previousValue);
    double current = double.parse(display);
    double result = 0;

    switch (operation) {
      case '+':
        result = prev + current;
        break;
      case '-':
        result = prev - current;
        break;
      case '×':
        result = prev * current;
        break;
      case '÷':
        if (current != 0) {
          result = prev / current;
        }
        break;
    }

    setState(() {
      display = result.toString();
      previousValue = '';
      operation = '';
      shouldResetDisplay = true;
    });
  }

  void clear() {
    setState(() {
      display = '0';
      previousValue = '';
      operation = '';
      shouldResetDisplay = false;
    });
  }

  void backspace() {
    setState(() {
      if (display.length > 1) {
        display = display.substring(0, display.length - 1);
      } else {
        display = '0';
      }
    });
  }

  Widget buildButton(String label, {Color? color, VoidCallback? onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ماشین حساب'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display
          Expanded(
            child: Container(
              color: Colors.black,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                display,
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: clear,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: const Text(
                          'C',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: backspace,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: const Text(
                          '⌫',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    buildButton('÷', color: Colors.blue, onPressed: () => setOperation('÷')),
                  ],
                ),
                Row(
                  children: [
                    buildButton('7', onPressed: () => appendNumber('7')),
                    buildButton('8', onPressed: () => appendNumber('8')),
                    buildButton('9', onPressed: () => appendNumber('9')),
                    buildButton('×', color: Colors.blue, onPressed: () => setOperation('×')),
                  ],
                ),
                Row(
                  children: [
                    buildButton('4', onPressed: () => appendNumber('4')),
                    buildButton('5', onPressed: () => appendNumber('5')),
                    buildButton('6', onPressed: () => appendNumber('6')),
                    buildButton('-', color: Colors.blue, onPressed: () => setOperation('-')),
                  ],
                ),
                Row(
                  children: [
                    buildButton('1', onPressed: () => appendNumber('1')),
                    buildButton('2', onPressed: () => appendNumber('2')),
                    buildButton('3', onPressed: () => appendNumber('3')),
                    buildButton('+', color: Colors.blue, onPressed: () => setOperation('+')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => appendNumber('0'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: const Text(
                            '0',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    buildButton('.', onPressed: appendDecimal),
                    buildButton('=', color: Colors.green, onPressed: calculate),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
