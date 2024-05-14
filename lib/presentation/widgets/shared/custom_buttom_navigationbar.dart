//import 'package:cinedila/presentation/screens/movies/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButtomNavigationbar extends StatelessWidget {
  final int currentIndexView;
  const CustomButtomNavigationbar({super.key, required this.currentIndexView});
  void onSwitchViews(BuildContext context, int index) {
    //print(index);
    //context.go('/home/$index');

    switch (index) {
      case 0:
        context.go('/home/0');
        break;

      case 1:
        context.go('/home/1');
        break;

      case 2:
        context.go('/home/2');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      currentIndex: currentIndexView,
      onTap: (index) => onSwitchViews(context, index),
      elevation: 0,
      selectedItemColor: colors.primary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.thumbs_up_down_outlined),
          label: 'Populares',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Favorito',
        ),
      ],
    );
  }
}
