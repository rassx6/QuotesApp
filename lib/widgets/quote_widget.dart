import 'package:flutter/material.dart';

class QuoteWidget extends StatelessWidget {
  final String quote;
  final String author;
  final bool isFavorite;
  final Function()? onNextClick;
  final Function()? onPrClick;
  final Function()? onShareClick;
  final Function()? onFavoriteToggle;
  final Color? bgColor;

  const QuoteWidget({
    super.key,
    required this.quote,
    required this.author,
    required this.isFavorite,
    this.onNextClick,
    this.onPrClick,
    this.onShareClick,
    this.onFavoriteToggle,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Image.asset(
            "assets/images/icon_quote.png",
            height: 30,
            width: 30,
            color: Colors.white,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            quote,
            style: const TextStyle(color: Colors.white, fontSize: 30),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            author,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: onFavoriteToggle,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
