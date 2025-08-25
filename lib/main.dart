// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app_state.dart';
import 'features/calculator/calculator_screen.dart';
import 'features/graphing/graphing_screen.dart';
import 'features/matrix/matrix_screen.dart';
import 'features/graphing/graphing_state.dart';
import 'features/matrix/matrix_state.dart';

void main() {
  runApp(const EulexRoot());
}

class EulexRoot extends StatelessWidget {
  const EulexRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorState()),
        ChangeNotifierProvider(create: (_) => GraphingState()),
        ChangeNotifierProvider(create: (_) => MatrixState()),
      ],
      child: Consumer<CalculatorState>(
        builder: (_, state, __) {
          final t = state.currentTheme;
          final scheme = ColorScheme.fromSeed(
            seedColor: t.functionButton,
            brightness: t.brightness,
          );
          return MaterialApp(
            title: 'Eulex Super Calculator',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: t.brightness,
              scaffoldBackgroundColor: t.background,
              colorScheme: scheme.copyWith(
                secondaryContainer: t.functionButton,
                onSecondaryContainer: t.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                primary: t.operatorButton,
              ),
              useMaterial3: true,
            ),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  final _screens = const [CalculatorScreen(), GraphingScreen(), MatrixScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Scientific',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Graphing',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_on_outlined),
            selectedIcon: Icon(Icons.grid_on),
            label: 'Matrix',
          ),
        ],
      ),
    );
  }
}
