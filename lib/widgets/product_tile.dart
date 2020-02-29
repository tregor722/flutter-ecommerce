// Product list view element
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:openflutterecommerce/config/theme.dart';
import 'package:openflutterecommerce/repos/models/product.dart';
import 'package:openflutterecommerce/screens/product_details/product_screen.dart';
import 'package:openflutterecommerce/widgets/favourite_button.dart';
import 'package:openflutterecommerce/widgets/product_rating.dart';

class OpenFlutterProductTile extends StatelessWidget {
  final Product product;
  final double height;
  final double width;
  final Function(bool) onFavClicked;
  final showCartButton;
  final showRemoveButton;
  final showColorAndSize;
  final showRatingInLine;
  final showTopLabel;

  const OpenFlutterProductTile(
      {Key key,
      this.product,
      this.height,
      this.width,
      this.onFavClicked,
      this.showCartButton,
      this.showRemoveButton,
      this.showColorAndSize,
      this.showRatingInLine,
      this.showTopLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    print("hello");
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen())),
              child: Padding(
                padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                child: Container(
                    height: height,
                    decoration: new BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.imageRadius),
                    ),
                    child: Row(children: <Widget>[
                      buildProductImage(_theme),
                      Container(
                        padding: EdgeInsets.only(
                            top: AppSizes.linePadding * 2,
                            left: AppSizes.sidePadding),
                        alignment: Alignment.topLeft,
                        width: this.width - 100,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(product.categoryTitle,
                                  style: _theme.textTheme.bodyText1),
                              Text(product.title,
                                  style: _theme.textTheme.headline3),
                              Padding(
                                padding: EdgeInsets.all(AppSizes.linePadding),
                              ),
                              Visibility(
                                child: Row(
                                  children: <Widget>[
                                    buildColor(product, _theme),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(AppSizes.linePadding),
                                    ),
                                    buildSize(product, _theme),
                                  ],
                                ),
                                visible: showColorAndSize,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: AppSizes.linePadding,
                                      bottom: AppSizes.linePadding)),
                              buildRating(_theme)
                            ]),
                      ),
                    ])),
              ),
            ),
            Visibility(
              child: Positioned(
                  bottom: 0,
                  right: 0,
                  child: OpenFlutterFavouriteButton(
                    favourite: product.favorite,
                    setFavourite: this.onFavClicked,
                    size: 36.0,
                    iconSize: 12.0,
                  )),
              visible: !showCartButton,
            ),
            Visibility(
              child: buildCartButton(product, _theme),
              visible: showCartButton,
            ),
            Visibility(
              child: buildRemoveButton(product),
              visible: showRemoveButton,
            )
          ],
        ));
  }

  buildRating(ThemeData _theme) {
    return showRatingInLine
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildPrice(product, _theme),
              Padding(
                padding: EdgeInsets.only(left: AppSizes.sidePadding * 0.45),
              ),
              OpenFlutterProductRating(
                rating: product.rating,
                ratingCount: product.ratingCount,
                iconSize: 12,
                alignment: MainAxisAlignment.start,
              ),
            ],
          )
        : Column(
            children: <Widget>[
              OpenFlutterProductRating(
                rating: product.rating,
                ratingCount: product.ratingCount,
                iconSize: 12,
                alignment: MainAxisAlignment.start,
              ),
              Padding(padding: EdgeInsets.only(top: AppSizes.linePadding)),
              Text('\$' + product.price.toStringAsFixed(2),
                  style: _theme.textTheme.headline5.copyWith(
                      color: _theme.primaryColor, fontWeight: FontWeight.bold))
            ],
          );
  }

  buildProductImage(ThemeData _theme) {
    return Visibility(
      child: showTopLabel
          ? Stack(
              children: <Widget>[
                Container(
                    width: width * 0.30,
                    child: Container(
                        height: width * 0.35,
                        decoration: new BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSizes.imageRadius),
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(product.image))),
                        child: Container())),
                buildTopLabel(product, _theme)
              ],
            )
          : Container(
              width: 100,
              alignment: Alignment.centerLeft,
              child: Image(image: AssetImage(product.image))),
    );
  }

  getDiscountPrice(Product product) {
    return (product.price * (100 - product.discountPercent) / 100)
        .roundToDouble();
  }

  buildPrice(Product product, ThemeData _theme) {
    double discountPrice = getDiscountPrice(product);
    return Row(
      children: <Widget>[
        Text("\$" + product.price.toStringAsFixed(0),
            style: _theme.textTheme.headline5.copyWith(
              decoration: discountPrice > 0
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            )),
        Padding(
          padding: EdgeInsets.only(left: AppSizes.linePadding),
        ),
        discountPrice > 0
            ? Text("\$" + discountPrice.toStringAsFixed(0),
                style: _theme.textTheme.headline5
                    .copyWith(color: _theme.errorColor))
            : Container()
      ],
    );
  }

  buildColor(Product product, ThemeData _theme) {
    return Row(
      children: <Widget>[
        Text("Color:", style: _theme.textTheme.headline5.copyWith()),
        Padding(
          padding: EdgeInsets.only(left: AppSizes.linePadding),
        ),
        Text("Blue",
            style: _theme.textTheme.headline5.copyWith(color: AppColors.black))
      ],
    );
  }

  buildSize(Product product, ThemeData _theme) {
    return Row(
      children: <Widget>[
        Text("Size:", style: _theme.textTheme.headline5.copyWith()),
        Padding(
          padding: EdgeInsets.only(left: AppSizes.linePadding),
        ),
        Text("L",
            style: _theme.textTheme.headline5.copyWith(color: AppColors.black))
      ],
    );
  }

  buildCartButton(Product product, ThemeData theme) {
    return Positioned(
        bottom: 0,
        right: AppSizes.sidePadding / 8,
        child: Container(
            height: 40.0,
            width: 40.0,
            padding: EdgeInsets.all(5.0),
            child: SvgPicture.asset("assets/icons/favourites/fav_cart.svg"),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              color: AppColors.red,
            )));
  }

  buildRemoveButton(Product product) {
    return Positioned(
        top: AppSizes.sidePadding / 2 - 10,
        right: AppSizes.sidePadding / 2 - 10,
        child: IconButton(
          icon: Icon(Icons.close),
          color: AppColors.lightGray,
          onPressed: () {
            print("Remove clicked");
          },
        ));
  }

  buildTopLabel(Product product, ThemeData theme) {
    return Positioned(
      top: 5,
      left: AppSizes.sidePadding / 3,
      child: product.isNew
          ? Container(
              padding: EdgeInsets.all(AppSizes.linePadding * 1.5),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                color: AppColors.black,
              ),
              child: Text('NEW',
                  style: theme.textTheme.bodyText1.copyWith(
                      color: AppColors.white, fontWeight: FontWeight.bold)))
          : (product.discountPercent > 0
              ? Container(
                  padding: EdgeInsets.all(AppSizes.linePadding * 1.5),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                    color: theme.errorColor,
                  ),
                  child: Text(
                      "-" + product.discountPercent.toStringAsFixed(0) + "%",
                      style: theme.textTheme.bodyText1.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      )))
              : Container()),
    );
  }
}

//
//InkWell(
//onTap: ( () => {
//this.onFavClicked(!product.favorite)
//}),
//child: Container(
//decoration: BoxDecoration(
//color: AppColors.white,
//boxShadow: [
//BoxShadow(color: _theme.primaryColorLight,
//blurRadius: 10),
//],
//borderRadius: BorderRadius.all(Radius.circular(18)),
//),
//height: 36,
//width: 36,
//child: product.favorite ?
//Icon(Icons.favorite, size: 12,
//color: _theme.accentColor) :
//Icon(Icons.favorite_border, size: 12,
//color: _theme.primaryColorLight)
//)
//)
