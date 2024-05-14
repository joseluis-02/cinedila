import 'package:cinedila/presentation/views/movies/popular_view.dart';
import 'package:flutter/material.dart';
import 'package:cinedila/presentation/views/views.dart';
import 'package:cinedila/presentation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home_screen';
  final int viewIndex;

  //Contructor de la clase HomeSCreen
  const HomeScreen({super.key, required this.viewIndex})
      : assert(viewIndex >= 0,
            'No se permite valores negativos parámetro: viewIndex debe ser mayor o igual a (0)');

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late PageController pageController;
  //Creamos una lista de nuestros views= Pantallas
  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final viewRoutes = const <Widget>[
    HomeView(),
    PopularView(),
    FavoriteView(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (pageController.hasClients) {
      pageController.animateToPage(
        widget.viewIndex,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
      );
    }
    return Scaffold(
      body: PageView(
        //* Esto evitará que rebote
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        // index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar:
          CustomButtomNavigationbar(currentIndexView: widget.viewIndex),
    ); /*return Scaffold(
      body: IndexedStack(
        index: widget.viewIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar:
          CustomButtomNavigationbar(currentIndexView: widget.viewIndex),
    );*/
  }

  @override
  bool get wantKeepAlive => true;
}
