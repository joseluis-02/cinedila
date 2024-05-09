//import 'package:cinedila/presentation/screens/movies/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButtomNavigationbar extends StatelessWidget {
  final int currentIndexView;
  const CustomButtomNavigationbar({super.key, required this.currentIndexView});
  void onSwitchViews(BuildContext context, int index) {
    //print(index);
    context.go('/home/$index');
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndexView,
      onTap: (index) => onSwitchViews(context, index),
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          label: 'Categoria',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Favorito',
        ),
      ],
    );
  }
}
