import 'package:flutter/material.dart';
import 'package:cinedila/presentation/views/views.dart';
import 'package:cinedila/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  final int viewIndex;

  //Contructor de la clase HomeSCreen
  const HomeScreen({super.key, required this.viewIndex})
      : assert(viewIndex >= 0,
            'No se permite valores negativos parámetro: viewIndex debe ser mayor o igual a (0)');

  //Creamos una lista de nuestros views= Pantallas
  final viewRoutes = const <Widget>[
    HomeView(),
    CategoryView(),
    FavoriteView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: viewIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar:
          CustomButtomNavigationbar(currentIndexView: viewIndex),
    );
  }
}
