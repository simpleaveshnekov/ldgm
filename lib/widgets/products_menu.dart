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

class PopularProductsMenuItem extends StatefulWidget {
  final int callId;
  final key;
  final Product product;
  final dynamic analytics;
  final dynamic observer;
  PopularProductsMenuItem({@required this.product, this.analytics, this.observer, this.callId, this.key}) : super();

  @override
  _PopularProductsMenuItemState createState() => _PopularProductsMenuItemState(product: product, analytics: analytics, observer: observer, callId: callId, key: key);
}

class ProductsMenu extends StatefulWidget {
  final dynamic analytics;
  final dynamic observer;
  final int callId;
  final List<Product> categoryProductList;
  ProductsMenu({this.analytics, this.observer, this.categoryProductList, this.callId}) : super();

  @override
  _ProductsMenuState createState() => _ProductsMenuState(analytics: analytics, observer: observer, categoryProductList: categoryProductList, callId: callId);
}

class _PopularProductsMenuItemState extends State<PopularProductsMenuItem> {
  Product product;
  dynamic analytics;
  dynamic observer;
  APIHelper apiHelper = APIHelper();
  Key key;
  int callId;
  final CartController cartController = Get.put(CartController());
  int _qty;
  _PopularProductsMenuItemState({this.product, this.analytics, this.observer, this.callId, this.key});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      key: key,
      height: 120,
      child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 10),
            child: GetBuilder<CartController>(
              init: cartController,
              builder: (value) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 56,
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              product.discount != null && product.discount > 0
                                  ? Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  "${product.discount}% OFF",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).primaryTextTheme.caption.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ):SizedBox.shrink(),
                              CachedNetworkImage(
                                imageUrl: global.appInfo.imageUrl + product.productImage,
                                imageBuilder: (context, imageProvider) => Container(
                                  color: Color(0xffF7F7F7),
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(color: Color(0xffF7F7F7), image: DecorationImage(image: imageProvider, fit: BoxFit.contain)),
                                    child: Visibility(
                                      visible: product.stock > 0 ? false : true,
                                      child: Container(
                                        width: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(5)),
                                        padding: const EdgeInsets.all(5),
                                        child: Center(
                                          child: Transform.rotate(
                                            angle: 12,
                                            child: Text(
                                              '${AppLocalizations.of(context).txt_out_of_stock}',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Container(
                                  height: 80,
                                  width: 60,
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    product.type != null && product.type != '' ? product.type : '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: normalCaptionStyle(context),
                                  ),
                                ),
                                Text(
                                  product.description != null && product.description != '' ? product.description : '',
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: normalCaptionStyle(context),
                                ),
                                product.rating != null && product.rating > 0
                                    ? Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 13,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: "${product.rating} ",
                                          style: Theme.of(context).textTheme.caption,
                                          children: [
                                            TextSpan(
                                              text: '|',
                                              style: Theme.of(context).textTheme.caption,
                                            ),
                                            TextSpan(
                                              text: ' ${product.ratingCount} ${AppLocalizations.of(context).txt_ratings}',
                                              style: Theme.of(context).textTheme.caption,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: InkWell(
                                onTap: () async {
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
                                    showOnlyLoaderDialog();
                                    await addRemoveWishList(product.varientId, product);

                                    Navigator.pop(context);
                                    setState(() {});
                                  }
                                },
                                child: product.isFavourite
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
                              ),
                            ),
                            Text(
                              "${global.appInfo.currencySign} ${product.price}",
                              style: textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            product.price == product.mrp
                                ? SizedBox()
                                : Text(
                              "${global.appInfo.currencySign} ${product.mrp}",
                              style: textTheme.overline.copyWith(decoration: TextDecoration.lineThrough, fontSize: 12),
                            ),
                            Spacer(),
                            product.stock > 0
                                ? callId == 0
                                ? product.cartQty == null || product.cartQty == 0
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
                                  isSuccess = await value.addToCart(product, _qty, false, varientId: product.varientId, callId: 0);
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
                                  size: 15.0,
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
                                      if (product.cartQty != null && product.cartQty == 1) {
                                        _qty = 0;
                                      } else {
                                        _qty = product.cartQty - 1;
                                      }

                                      showOnlyLoaderDialog();
                                      ATCMS isSuccess;
                                      isSuccess = await value.addToCart(product, _qty, true, varientId: product.varientId, callId: 0);
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
                                        child: product.varient != null && product.cartQty == 1
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
                                    height: 21,
                                    width: 21,
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
                                        "${product.cartQty}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      _qty = product.cartQty + 1;

                                      showOnlyLoaderDialog();
                                      ATCMS isSuccess;
                                      isSuccess = await value.addToCart(product, _qty, false, varientId: product.varientId, callId: 0);
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
                            )
                                : InkWell(
                              onTap: () async {
                                if (global.currentUser.id == null) {
                                  Get.to(LoginScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  ));
                                } else {
                                  _showVarientModalBottomSheet(textTheme, value);
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
                                : SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<bool> addRemoveWishList(int varientId, Product product) async {
    bool _isAddedSuccesFully = false;
    try {
      await apiHelper.addRemoveWishList(varientId).then((result) async {
        if (result != null) {
          if (result.status == "1" || result.status == "2") {
            _isAddedSuccesFully = true;

            product.isFavourite = !product.isFavourite;

            if (result.status == "2") {
              if (callId == 0) {
                // product
                // categoryProductList.removeWhere((e) => e.varientId == varientId);
              }
            }

            setState(() {});
          } else {
            _isAddedSuccesFully = false;

            setState(() {});
            showSnackBar(snackBarMessage: '${AppLocalizations.of(context).txt_please_try_again_after_sometime}');
          }
        }
      });
      return _isAddedSuccesFully;
    } catch (e) {
      print("Exception - products_menu.dart - addRemoveWishList():" + e.toString());
      return _isAddedSuccesFully;
    }
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
        isScrollControlled: false,
        builder: (BuildContext context) {
          return GetBuilder<CartController>(
            init: cartController,
            builder: (value) => StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 300,
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
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: product.varient.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            title: ReadMoreText(
                              '${product.varient[i].description}',
                              trimLines: 2,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                              lessStyle: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                              moreStyle: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
                            ),
                            subtitle: Text('${product.varient[i].quantity} ${product.varient[i].unit} / ${global.appInfo.currencySign} ${product.varient[i].price}', style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 15)),
                            trailing: product.varient[i].cartQty == null || product.varient[i].cartQty == 0
                                ? InkWell(
                                    onTap: () async {
                                      if (global.currentUser.id == null) {
                                        Get.to(LoginScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                        ));
                                      } else {
                                        showOnlyLoaderDialog();
                                        ATCMS isSuccess;
                                        _qty = 1;
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
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }
}

class _ProductsMenuState extends State<ProductsMenu> {
  dynamic analytics;
  dynamic observer;
  int callId;
  List<Product> categoryProductList;
  APIHelper apiHelper = APIHelper();
  _ProductsMenuState({this.analytics, this.observer, this.categoryProductList, this.callId});
  Future<bool> addRemoveWishList(int varientId, int index) async {
    bool _isAddedSuccesFully = false;
    try {
      await apiHelper.addRemoveWishList(varientId).then((result) async {
        if (result != null) {
          if (result.status == "1" || result.status == "2") {
            _isAddedSuccesFully = true;

            categoryProductList[index].isFavourite = !categoryProductList[index].isFavourite;

            if (result.status == "2") {
              if (callId == 0) {
                categoryProductList.removeWhere((e) => e.varientId == varientId);
              }
            }

            setState(() {});
          } else {
            _isAddedSuccesFully = false;

            setState(() {});
            showSnackBar(snackBarMessage: '${AppLocalizations.of(context).txt_please_try_again_after_sometime}');
          }
        }
      });
      return _isAddedSuccesFully;
    } catch (e) {
      print("Exception - products_menu.dart - addRemoveWishList():" + e.toString());
      return _isAddedSuccesFully;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categoryProductList.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            onTap: () => Get.to(() => ProductDescriptionScreen(a: widget.analytics, o: widget.observer, productId: categoryProductList[index].productId)),
            child: PopularProductsMenuItem(
              key: Key('${categoryProductList.length}'),
              product: categoryProductList[index],
              analytics: widget.analytics,
              observer: widget.observer,
              callId: callId,
            ),
          ),
        );
      },
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
