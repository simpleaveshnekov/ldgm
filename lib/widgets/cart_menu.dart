import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/addtocartmessagestatus.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/categoryProductModel.dart';
import 'package:user/widgets/toastfile.dart';

class CartMenu extends StatefulWidget {
  final CartController cartController;
  CartMenu({this.cartController}) : super();

  @override
  _CartMenuState createState() => _CartMenuState(cartController: cartController);
}

class CartMenuItem extends StatefulWidget {
  final Product product;
  final CartController cartController;
  CartMenuItem({this.product, this.cartController}) : super();

  @override
  _CartMenuItemState createState() => _CartMenuItemState(product: product, cartController: cartController);
}

class _CartMenuItemState extends State<CartMenuItem> {
  Product product;
  CartController cartController;
  int _qty;
  _CartMenuItemState({@required this.product, this.cartController});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        height: 100 * screenHeight / 830,
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: global.appInfo.imageUrl + product.varientImage,
                      imageBuilder: (context, imageProvider) => Container(
                        color: Color(0xffF7F7F7),
                        padding: EdgeInsets.all(5),
                        child: Container(
                          height: 80,
                          width: 40,
                          decoration: BoxDecoration(color: Color(0xffF7F7F7), image: DecorationImage(image: imageProvider, fit: BoxFit.contain)),
                        ),
                      ),
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        height: 80,
                        width: 40,
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            product.productName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${global.appInfo.currencySign} ${product.price}",
                          style: textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
                Positioned(
                    right: global.isRTL ? null : 0,
                    left: global.isRTL ? 0 : null,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              showOnlyLoaderDialog();
                              if (product.cartQty != null && product.cartQty == 1) {
                                _qty = 0;
                              } else {
                                _qty = product.cartQty - 1;
                              }
                              ATCMS isSuccess;
                              isSuccess = await cartController.addToCart(product, _qty, true, varientId: product.varientId, callId: 0);
                              if (isSuccess.isSuccess != null) {
                                Navigator.of(context).pop();
                              }
                              showToast(isSuccess.message);
                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //   content: Text(
                              //     isSuccess.message,
                              //     textAlign: TextAlign.center,
                              //   ),
                              //   duration: Duration(seconds: 2),
                              // ));
                              setState(() {});
                            },
                            child: Container(
                                height: 23,
                                width: 23,
                                alignment: Alignment.center,
                                color: Theme.of(context).colorScheme.secondary,
                                child: product.cartQty != null && product.cartQty == 1
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
                              showOnlyLoaderDialog();
                              _qty = product.cartQty + 1;
                              ATCMS isSuccess;
                              isSuccess = await cartController.addToCart(product, _qty, false, varientId: product.varientId, callId: 0);
                              if (isSuccess.isSuccess != null) {
                                Navigator.of(context).pop();
                              }
                              showToast(isSuccess.message);
                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //   content: Text(
                              //     isSuccess.message,
                              //     textAlign: TextAlign.center,
                              //   ),
                              //   duration: Duration(seconds: 2),
                              // ));
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
                    )),
              ],
            ),
          ),
        ));
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
}

class _CartMenuState extends State<CartMenu> {
  CartController cartController;
  _CartMenuState({this.cartController});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 16),
      shrinkWrap: true,
      itemCount: cartController.cartItemsList.cartList.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GetBuilder<CartController>(
          init: cartController,
          builder: (value) => Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              showOnlyLoaderDialog();
              ATCMS isSuccess;
              isSuccess = await cartController.addToCart(cartController.cartItemsList.cartList[index], 0, true, varientId: cartController.cartItemsList.cartList[index].varientId, callId: 0);
              if (isSuccess.isSuccess != null) {
                Navigator.of(context).pop();
              }
              showToast(isSuccess.message);
              setState(() {});
            },
            background: _backgroundContainer(context, screenHeight),
            child: CartMenuItem(
              product: cartController.cartItemsList.cartList[index],
              cartController: cartController,
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

  Widget _backgroundContainer(BuildContext context, double screenHeight) {
    return Column(
      children: [
        SizedBox(height: 8),
        Wrap(
          children: [
            Container(
              height: 80 * screenHeight / 830,
              color: Theme.of(context).errorColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 32),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
