import 'package:animate_do/animate_do.dart';
import 'package:cinedila/config/helpers/human_formats.dart';
import 'package:cinedila/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;
  const MovieHorizontalListview(
      {super.key,
      required this.movies,
      this.title,
      this.subTitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        //print('SCroll controller itens: ${widget.movies.length}');
        //Llamar la funcion nextLoadPage
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(widget.title, widget.subTitle),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeInRight(
                    child: _SlideHorizontal(movie: widget.movies[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const _Title(this.title, this.subTitle);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      //color: Colors.red,
      padding: const EdgeInsets.only(top: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != '')
            Text(
              title!,
              style: titleStyle,
            ),
          const Spacer(),
          (subTitle != '')
              ? FilledButton.tonal(
                  style:
                      const ButtonStyle(visualDensity: VisualDensity.compact),
                  onPressed: null,
                  child: Text(subTitle!))
              : const SizedBox(),
        ],
      ),
    );
  }
}

class _SlideHorizontal extends StatelessWidget {
  final Movie movie;
  const _SlideHorizontal({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Container(
      //color: Colors.green,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                width: 150,
                height: 220,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Padding(
                      padding: EdgeInsets.all(0.8),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                      onTap: () => context.push('/home/0/movie/${movie.id}'),
                      child: FadeIn(child: child));
                },
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyle.titleSmall,
            ),
          ),

          //Rating
          Row(
            children: [
              Icon(
                Icons.star_half_outlined,
                color: Colors.yellow.shade800,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                '${movie.voteAverage}',
                style: textStyle.bodyMedium?.copyWith(
                  color: Colors.yellow.shade800,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                HumanFormats.number(movie.popularity),
                style: textStyle.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
