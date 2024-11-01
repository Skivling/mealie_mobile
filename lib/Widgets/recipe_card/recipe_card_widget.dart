import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/Pages/Home/Search/Recipe/Page/recipe_page.dart';
import 'package:maize/Widgets/recipe_card/recipe_card_cubit.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:maize/colors.dart';
import 'package:mealie_repository/mealie_repository.dart';


// RecipeCard(s) are on the menu screens when there is a list of recipes
// includes: 
//    Image (or Mealie logo if there isn't one)
//    Recipe Title
//    Favorite button
//    Star rating (not a button)
//    Three dot menu (not functional yet)

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    this.isFavorite,
  });

  final Recipe recipe;
  final bool? isFavorite;

  @override
  Widget build(BuildContext context) {
    final AppBloc appBloc = context.read<AppBloc>();
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final String imageUrl =
        appBloc.repo.uri.replace(path: recipe.imagePath).toString();
    return BlocProvider(
      create: (_) => RecipeCardCubit(
          appBloc: context.read<AppBloc>(), isFavorite: isFavorite),
      child: BlocBuilder<RecipeCardCubit, RecipeCardState>(
          builder: (context, state) {
        return InkWell(
          onTap: () => homeCubit.setScreen(RecipePage(recipe: recipe)),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                        fit: BoxFit.cover,
                        "assets/mealie_logo.svg",
                        height: 120,
                        colorFilter: const ColorFilter.mode(
                            MealieColors.orange, BlendMode.srcIn),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 243,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          recipe.name.toString(),
                          maxLines: 2,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: FaIcon(
                                  (state.isFavorite == true)
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                  color: MealieColors.red,
                                ),
                                iconSize: 15,
                                onPressed: () => context
                                    .read<RecipeCardCubit>()
                                    .toggleFavorite(recipe),
                              ),
                              _StarRating(recipe: recipe),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              const SnackBar snackBar = SnackBar(
                                content: Text(
                                  'This feature has not yet been implemented.',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.ellipsis,
                              color: MealieColors.orange,
                              size: 18,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List<Widget>.generate(
            (recipe.rating ?? 0).toInt(),
            (index) => const Icon(
              Icons.star,
              color: MealieColors.red,
              size: 15,
            ),
          ),
        ),
        Row(
          children: List<Widget>.generate(
            (5 - (recipe.rating ?? 0)).toInt(),
            (index) => const Icon(
              Icons.star_border,
              color: MealieColors.peach,
              size: 15,
            ),
          ),
        ),
      ],
    );
  }
}
