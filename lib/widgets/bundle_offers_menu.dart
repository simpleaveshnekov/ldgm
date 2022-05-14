import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/addtocartmessagestatus.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/categoryProductModel.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/product_description_screen.dart';
import 'package:user/theme/style.dart';
import 'package:user/widgets/toastfile.dart';

class BundleOffersMenu extends StatefulWidget {
  final dynamic analytics;
  final dynamic observer;
  final List<Product> categoryProductList;
  final Function(int) onSelected;

  BundleOffersMenu({this.onSelected, this.categoryProductList, this.analytics, this.observer}) : super();

  @override
  _BundleOffersMenuState createState() => _BundleOffersMenuState(onSelected: onSelected, categoryProductList: categoryProductList, analytics: analytics, observer: observer);
}

class BundleOffersMenuItem extends StatefulWidget {
  final Product product;

  final dynamic analytics;
  final dynamic observer;
  BundleOffersMenuItem({@required this.product, this.analytics, this.observer}) : super();

  @override
  _BundleOffersMenuItemState createState() => _BundleOffersMenuItemState(product: product, analytics: analytics, observer: observer);
}

class _BundleOffersMenuItemState extends State<BundleOffersMenuItem> {
  Product product;
  dynamic analytics;
  dynamic observer;
  final CartController cartController = Get.put(CartController());

  int _qty;
  _BundleOffersMenuItemState({this.product, this.analytics, this.observer});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.53,
      child: GetBuilder<CartController>(
          init: cartController,
          builder: (value) => Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xffF4F4F4),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            imageUrl: global.appInfo.imageUrl + product.productImage,
                            imageBuilder: (context, imageProvider) => Container(
                              width: (screenWidth * 0.53) - 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: imageProvider,
                              )),
                              child: Visibility(
                                visible: product.stock > 0 ? false : true,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(5),
                                  child: Center(
                                    child: Transform.rotate(
                                      angle: 12,
                                      child: Text(
                                        '${AppLocalizations.of(context).txt_out_of_stock}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, url) => SizedBox(child: Center(child: CircularProgressIndicator())),
                            errorWidget: (context, url, error) => SizedBox(
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                product.productName,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                product.type != null && product.type != '' ? product.type : '',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: normalCaptionStyle(context).copyWith(fontSize: 11),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                product.description != null && product.description != '' ? product.description : '',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: normalCaptionStyle(context).copyWith(fontSize: 12),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${global.appInfo.currencySign} ${product.price}",
                                      style: textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    product.price == product.mrp
                                        ? SizedBox()
                                        : Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "${global.appInfo.currencySign}${product.mrp}",
                                        style: textTheme.overline.copyWith(decoration: TextDecoration.lineThrough, fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),
                                product.stock > 0
                                    ? InkWell(
                                  onTap: () async {
                                    if (global.currentUser.id == null) {
                                      Get.to(LoginScreen(
                                        a: widget.analytics,
                                        o: widget.observer,
                                      ));
                                    } else {
                                      _showVarientModalBottomSheet(textTheme, cartController);
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(3),
                                    color: Theme.of(context).colorScheme.secondary,
                                    child: Icon(
                                      Icons.add,
                                      size: 15.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                                    : SizedBox()
                              ],
                            ),
                            product.rating != null && product.rating > 0
                                ? Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 10,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: "${product.rating} ",
                                      style: Theme.of(context).textTheme.caption.copyWith(fontSize: 11),
                                      children: [
                                        TextSpan(
                                          text: '|',
                                          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 11),
                                        ),
                                        TextSpan(
                                          text: ' ${product.ratingCount} ${AppLocalizations.of(context).txt_ratings}',
                                          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 11),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : SizedBox(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
    );
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: new CircularProgressIndicator()),
        );
      },
    );
  }

  _showVarientModalBottomSheet(TextTheme textTheme, CartController value) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return GetBuilder<CartController>(
            init: cartController,
            builder: (value) => Container(
              height: 200,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.productName,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Divider(),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: product.varient.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        title: ReadMoreText(
                          '${product.varient[i].description}',
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '${AppLocalizations.of(context).txt_show_more}',
                          trimExpandedText: '${AppLocalizations.of(context).txt_show_less}',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                          lessStyle: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                          moreStyle: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                        ),
                        subtitle: Text('${product.varient[i].quantity} ${product.varient[i].unit} / ${global.appInfo.currencySign} ${product.varient[i].price}  ', style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 15)),
                        trailing: product.varient[i].cartQty == null || product.varient[i].cartQty == 0
                            ? InkWell(
                                onTap: () async {
                                  if (global.currentUser.id == null) {
                                    Get.to(LoginScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    ));
                                  } else {
                                    _qty = 1;
                                    showOnlyLoaderDialog();
                                    ATCMS isSuccess;
                                    isSuccess = await value.addToCart(product, _qty, false, varient: product.varient[i]);
                                    if (isSuccess.isSuccess != null) {
                                      Navigator.of(context).pop();
                                    }
                                    showToast(isSuccess.message);
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  height: 23,
                                  width: 23,
                                  alignment: Alignment.center,
                                  color: Theme.of(context).colorScheme.secondary,
                                  child: Icon(
                                    Icons.add,
                                    size: 17.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if (product.varient[i].cartQty != null && product.varient[i].cartQty == 1) {
                                          _qty = 0;
                                        } else {
                                          _qty = product.varient[i].cartQty - 1;
                                        }

                                        showOnlyLoaderDialog();
                                        ATCMS isSuccess;
                                        isSuccess = await value.addToCart(product, _qty, true, varient: product.varient[i]);

                                        if (isSuccess.isSuccess != null) {
                                          Navigator.of(context).pop();
                                        }
                                        showToast(isSuccess.message);
                                        setState(() {});
                                      },
                                      child: Container(
                                          height: 23,
                                          width: 23,
                                          alignment: Alignment.center,
                                          color: Theme.of(context).colorScheme.secondary,
                                          child: product.varient != null && product.varient[i].cartQty == 1
                                              ? Icon(
                                                  Icons.delete,
                                                  size: 17.0,
                                                  color: Theme.of(context).primaryColor,
                                                )
                                              : Icon(
                                                  MdiIcons.minus,
                                                  size: 17.0,
                                                  color: Theme.of(context).primaryColor,
                                                )),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 23,
                                      width: 23,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1.0,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                            ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${product.varient[i].cartQty}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        _qty = product.varient[i].cartQty + 1;

                                        showOnlyLoaderDialog();
                                        ATCMS isSuccess;
                                        isSuccess = await value.addToCart(product, _qty, false, varient: product.varient[i]);
                                        if (isSuccess.isSuccess != null) {
                                          Navigator.of(context).pop();
                                        }
                                        showToast(isSuccess.message);
                                        setState(() {});
                                      },
                                      child: Container(
                                          height: 23,
                                          width: 23,
                                          alignment: Alignment.center,
                                          color: Theme.of(context).colorScheme.secondary,
                                          child: Icon(
                                            MdiIcons.plus,
                                            size: 17,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int i) {
                      return Divider();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}

class _BundleOffersMenuState extends State<BundleOffersMenu> {
  List<Product> categoryProductList;
  Function(int) onSelected;
  dynamic analytics;
  dynamic observer;
  APIHelper apiHelper = APIHelper();

  _BundleOffersMenuState({this.onSelected, this.categoryProductList, this.analytics, this.observer});

  Future<bool> addRemoveWishList(int varientId) async {
    bool _isAddedSuccesFully = false;
    try {
      showOnlyLoaderDialog();
      await apiHelper.addRemoveWishList(varientId).then((result) async {
        if (result != null) {
          if (result.status == "1" || result.status == "2") {
            _isAddedSuccesFully = true;
            Navigator.pop(context);
          } else {
            _isAddedSuccesFully = false;
            Navigator.pop(context);

            showSnackBar(snackBarMessage: '${AppLocalizations.of(context).txt_please_try_again_after_sometime} ');
          }
        }
      });
      return _isAddedSuccesFully;
    } catch (e) {
      print("Exception - bundle_offers_menu.dart - addRemoveWishList():" + e.toString());
      return _isAddedSuccesFully;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width*1/2/1,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryProductList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Get.to(() => ProductDescriptionScreen(a: widget.analytics, o: widget.observer, productId: categoryProductList[index].productId)),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Stack(
                  children: [
                    BundleOffersMenuItem(
                      product: categoryProductList[index],
                      analytics: widget.analytics,
                      observer: widget.observer,
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: categoryProductList[index].discount != null && categoryProductList[index].discount > 0
                            ? Container(
                          height: 16,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                          child: Text(
                            "${categoryProductList[index].discount} % OFF",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).primaryTextTheme.caption.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                            : SizedBox(
                          height: 16,
                          width: 60,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: categoryProductList[index].isFavourite
                            ? Icon(
                          MdiIcons.heart,
                          size: 20,
                          color: Colors.red,
                        )
                            : Icon(
                          MdiIcons.heartOutline,
                          size: 20,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          if (global.currentUser.id == null) {
                            Future.delayed(Duration.zero, () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    )),
                              );
                            });
                          } else {
                            bool _isAdded = await addRemoveWishList(
                              categoryProductList[index].varientId,
                            );
                            if (_isAdded) {
                              categoryProductList[index].isFavourite = !categoryProductList[index].isFavourite;
                            }

                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: new CircularProgressIndicator()),
        );
      },
    );
  }

  void showSnackBar({String snackBarMessage}) {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(
    //     snackBarMessage,
    //     textAlign: TextAlign.center,
    //   ),
    //   duration: Duration(seconds: 2),
    // ));
    showToast(snackBarMessage);
  }
}
