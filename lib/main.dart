import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
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
  String _expression = '';
  String _result = '0';

  void _onNumberPressed(String number) {
    setState(() {
      _expression += number;
      _updateResult();
    });
  }

  void _onOperatorPressed(String operator) {
    if (_expression.isEmpty) return;
    
    // Prevent multiple consecutive operators
    if (_expression.endsWith('+') ||
        _expression.endsWith('-') ||
        _expression.endsWith('*') ||
        _expression.endsWith('/')) {
      return;
    }
    
    setState(() {
      _expression += ' $operator ';
      _updateResult();
    });
  }

  void _updateResult() {
    try {
      // Only update result if the expression is valid
      final expression = _expression.replaceAll(' ', '');
      
      if (expression.isEmpty) {
        _result = '0';
        return;
      }
      
      // Don't try to evaluate incomplete expressions
      if (expression.endsWith('+') ||
          expression.endsWith('-') ||
          expression.endsWith('*') ||
          expression.endsWith('/')) {
        _result = '0';
        return;
      }

      final exp = Expression.parse(expression);
      final evaluator = const ExpressionEvaluator();
      final value = evaluator.eval(exp, {});
      
      // Format the result
      if (value is num) {
        if (value is double && value == value.toInt()) {
          _result = value.toInt().toString();
        } else if (value is double) {
          _result = value.toStringAsFixed(10).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
        } else {
          _result = value.toString();
        }
      } else {
        _result = '0';
      }
    } catch (e) {
      // If there's an error in evaluation, keep showing 0
      _result = '0';
    }
  }

  void _onEquals() {
    if (_expression.isEmpty) return;
    
    setState(() {
      _expression += ' = $_result';
    });
  }

  void _onClear() {
    setState(() {
      _expression = '';
      _result = '0';
    });
  }

  void _onBackspace() {
    if (_expression.isEmpty) return;
    
    setState(() {
      _expression = _expression.substring(0, _expression.length - 1).trimRight();
      _updateResult();
    });
  }

  void _onSquare() {
    if (_expression.isEmpty) return;
    
    setState(() {
      _expression = '($_expression)*($_expression)';
      _updateResult();
    });
  }

  void _onModulo() {
    if (_expression.isEmpty) return;
    
    // Prevent multiple consecutive operators
    if (_expression.endsWith('+') ||
        _expression.endsWith('-') ||
        _expression.endsWith('*') ||
        _expression.endsWith('/') ||
        _expression.endsWith('%')) {
      return;
    }
    
    setState(() {
      _expression += ' % ';
      _updateResult();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title with developer name
                  const Text(
                    'GitHub Copilot Calculator',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Calculator Container
                  Container(
                    width: 400,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0f3460),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Display Section
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1a1a2e),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xFF00d4ff),
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Expression Display
                              Text(
                                _expression.isEmpty ? '0' : _expression,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF00d4ff),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 15),
                              // Result Display
                              Text(
                                _result,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Buttons Grid
                        Column(
                          children: [
                            // Row 1: Clear, Backspace, Divide
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('C', () => _onClear(), isOperator: true, width: 80),
                                _buildButton('⌫', () => _onBackspace(), isOperator: true, width: 80),
                                _buildButton('/', () => _onOperatorPressed('/'), isOperator: true, width: 80),
                              ],
                            ),
                            const SizedBox(height: 15),
                            
                            // Row 1.5: Square, Modulo
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('x²', () => _onSquare(), isOperator: true, width: 80),
                                _buildButton('%', () => _onModulo(), isOperator: true, width: 80),
                                _buildButton('', () {}, isOperator: true, width: 80),
                              ],
                            ),
                            const SizedBox(height: 15),
                            
                            // Row 2: 7, 8, 9, *
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('7', () => _onNumberPressed('7')),
                                _buildButton('8', () => _onNumberPressed('8')),
                                _buildButton('9', () => _onNumberPressed('9')),
                                _buildButton('*', () => _onOperatorPressed('*'), isOperator: true),
                              ],
                            ),
                            const SizedBox(height: 15),
                            
                            // Row 3: 4, 5, 6, -
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('4', () => _onNumberPressed('4')),
                                _buildButton('5', () => _onNumberPressed('5')),
                                _buildButton('6', () => _onNumberPressed('6')),
                                _buildButton('-', () => _onOperatorPressed('-'), isOperator: true),
                              ],
                            ),
                            const SizedBox(height: 15),
                            
                            // Row 4: 1, 2, 3, +
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('1', () => _onNumberPressed('1')),
                                _buildButton('2', () => _onNumberPressed('2')),
                                _buildButton('3', () => _onNumberPressed('3')),
                                _buildButton('+', () => _onOperatorPressed('+'), isOperator: true),
                              ],
                            ),
                            const SizedBox(height: 15),
                            
                            // Row 5: 0, Decimal, Equals
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('0', () => _onNumberPressed('0'), width: 170),
                                _buildButton('.', () => _onNumberPressed('.')),
                                _buildButton('=', () => _onEquals(), isEquals: true),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Footer
                  const Text(
                    'Built with Flutter & Expressions Package',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    String label,
    VoidCallback onPressed, {
    bool isOperator = false,
    bool isEquals = false,
    double width = 70,
    double height = 70,
  }) {
    Color backgroundColor;
    Color textColor;
    
    if (isEquals) {
      backgroundColor = const Color(0xFF00d4ff);
      textColor = Colors.black;
    } else if (isOperator) {
      backgroundColor = const Color(0xFFe94560);
      textColor = Colors.white;
    } else {
      backgroundColor = const Color(0xFF16213e);
      textColor = const Color(0xFF00d4ff);
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
