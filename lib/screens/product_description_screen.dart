import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/addtocartmessagestatus.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/productDetailModel.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/productlist_screen.dart';
import 'package:user/screens/ratingListScreen.dart';
import 'package:user/widgets/bottom_button.dart';
import 'package:user/widgets/my_chip.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/widgets/toastfile.dart';

class AppBarActionButton extends StatefulWidget {
  final Function onPressed;
  final CartController cartController;

  AppBarActionButton(this.cartController, {this.onPressed}) : super();

  @override
  _AppBarActionButtonState createState() => _AppBarActionButtonState(
      onPressed: onPressed, cartController: cartController);
}

class ProductDescriptionScreen extends BaseRoute {
  final int productId;
  final ProductDetail productDetail;
  final int screenId;

  ProductDescriptionScreen(
      {a, o, this.productId, this.screenId, this.productDetail})
      : super(a: a, o: o, r: 'ProductDescriptionScreen');

  @override
  _ProductDescriptionScreenState createState() =>
      _ProductDescriptionScreenState(
          productId: productId,
          screenId: screenId,
          productDetail: productDetail);
}

class _AppBarActionButtonState extends State<AppBarActionButton> {
  Function onPressed;

  CartController cartController;

  _AppBarActionButtonState({this.onPressed, this.cartController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: cartController,
      builder: (value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.add_shopping_cart_outlined,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => onPressed(),
            ),
            global.cartCount != null && global.cartCount != 0
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                          global.cartCount != null && global.cartCount != 0
                              ? '${global.cartCount}'
                              : ''),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class _ProductDescriptionScreenState extends BaseRouteState {
  int productId;
  ProductDetail productDetail;
  int screenId;
  ProductDetail _productDetail;
  bool _isDataLoaded = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());
  int _qty = 0;
  int _selectedIndex;

  _ProductDescriptionScreenState(
      {this.productId, this.screenId, this.productDetail});

  // check if add to cart button is pressed once

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isDataLoaded
              ? _productDetail.productDetail.productName
              : '${AppLocalizations.of(context).tle_product_details}',
          style: textTheme.headline6,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.keyboard_arrow_left)),
        actions: [
          AppBarActionButton(
            cartController,
            onPressed: () => global.currentUser.id == null
                ? Get.to(LoginScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  ))
                : Get.to(CartScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )),
          ),
        ],
      ),
      body: _isDataLoaded
          ? GetBuilder<CartController>(
              init: cartController,
              builder: (value) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                bool _isAdded = await addRemoveWishList(
                                    _productDetail.productDetail.varientId);
                                if (_isAdded) {
                                  _productDetail.productDetail.isFavourite =
                                      !_productDetail.productDetail.isFavourite;
                                }

                                setState(() {});
                              }
                            },
                            child: _productDetail.productDetail.isFavourite
                                ? Icon(
                                    MdiIcons.heart,
                                    size: 20,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    MdiIcons.heartOutline,
                                    size: 20,
                                    color: Colors.red,
                                  )),
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      height: 260,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      )),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          _productDetail.productDetail.images != null &&
                                  _productDetail.productDetail.images.length > 0
                              ? PhotoViewGallery.builder(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  loadingBuilder: (BuildContext context, _) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                  itemCount: _productDetail
                                      .productDetail.images.length,
                                  builder: (BuildContext context, int index) {
                                    return PhotoViewGalleryPageOptions(
                                        imageProvider: _productDetail
                                                        .productDetail.images !=
                                                    null &&
                                                _productDetail.productDetail
                                                        .images.length >
                                                    0
                                            ? CachedNetworkImageProvider(
                                                global.appInfo.imageUrl +
                                                    _productDetail.productDetail
                                                        .images[index].image,
                                              )
                                            : _productDetail.productDetail
                                                        .productImage !=
                                                    null
                                                ? CachedNetworkImageProvider(
                                                    global.appInfo.imageUrl +
                                                        _productDetail
                                                            .productDetail
                                                            .productImage,
                                                  )
                                                : Container(
                                                    width: screenWidth,
                                                    height: 260,
                                                    child: Image.asset(
                                                        'assets/images/icon.png')));
                                  },
                                  backgroundDecoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(40),
                                      )),
                                )
                              : PhotoView(
                                  imageProvider: _productDetail
                                              .productDetail.productImage !=
                                          null
                                      ? CachedNetworkImageProvider(
                                          global.appInfo.imageUrl +
                                              _productDetail
                                                  .productDetail.productImage,
                                        )
                                      : Container(
                                          width: screenWidth,
                                          height: 260,
                                          child: Image.asset(
                                              'assets/images/icon.png')),
                                  backgroundDecoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(40),
                                      )),
                                  loadingBuilder: (BuildContext context, _) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                ),
                          _productDetail.productDetail.images != null &&
                                  _productDetail.productDetail.images.length > 0
                              ? IconButton(
                                  icon: Icon(
                                    Icons.zoom_out_map,
                                    color: textTheme.bodyText1.color,
                                  ),
                                  onPressed: () {
                                    dialogToOpenImage(
                                        _productDetail
                                            .productDetail.productName,
                                        _productDetail.productDetail.images,
                                        0);
                                  },
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    _productNameAndPrice(textTheme),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _productDetail.productDetail.varient.length,
                      itemBuilder: (BuildContext context, int i) {
                        print(_productDetail.productDetail.varient[i].stock);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _productWeightAndQuantity(
                              textTheme, cartController, i),
                        );
                      },
                    ),
                    _subHeading(textTheme, "Description"),
                    _productDescription(textTheme),
                    _productDetail.productDetail.rating != null &&
                            _productDetail.productDetail.rating > 0
                        ? Padding(
                            padding: EdgeInsets.only(top: 16, left: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RatingListScreen(
                                        _productDetail.productDetail.varientId,
                                        a: widget.analytics,
                                        o: widget.observer),
                                  ),
                                );
                              },
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
                                      text:
                                          "${_productDetail.productDetail.rating} ",
                                      style:
                                          Theme.of(context).textTheme.caption,
                                      children: [
                                        TextSpan(
                                          text: '|',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${_productDetail.productDetail.ratingCount} ${AppLocalizations.of(context).txt_ratings}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    _subHeading(textTheme, "Related Products"),
                    _relatedProducts(textTheme),
                    _productDetail.productDetail.tags != null &&
                            _productDetail.productDetail.tags.length > 0
                        ? _subHeading(textTheme, "Tags")
                        : SizedBox(),
                    _productDetail.productDetail.tags != null &&
                            _productDetail.productDetail.tags.length > 0
                        ? _tags(textTheme)
                        : SizedBox(),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 32,
                        ),
                        child: BottomButton(
                            key: UniqueKey(),
                            loadingState: false,
                            disabledState: false,
                            onPressed: () {
                              if (global.currentUser.id == null) {
                                Get.to(LoginScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                ));
                              } else {
                                if (_productDetail.productDetail.stock > 0) {
                                  if (_productDetail.productDetail.varient
                                          .where((e) => e.cartQty > 0)
                                          .toList()
                                          .length >
                                      0) {
                                    //go to cart
                                    Get.to(() => CartScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                        ));
                                  } else {
                                    // add to cart
                                    _showVarientModalBottomSheet(
                                        textTheme, cartController);
                                  }
                                }
                              }
                            },
                            child: _productDetail.productDetail.stock > 0
                                ? _productDetail.productDetail.varient
                                            .where((e) => e.cartQty > 0)
                                            .toList()
                                            .length >
                                        0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${AppLocalizations.of(context).btn_go_to_cart}"),
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.shopping_cart_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "${AppLocalizations.of(context).btn_add_cart}")
                                : Text(
                                    "${AppLocalizations.of(context).txt_out_of_stock}")))
                  ],
                ),
              ),
            )
          : _shimmer(),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _getBannerProductDetail() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getBannerProductDetail(productId).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _productDetail = result.data;
            } else {
              _productDetail = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print(
          "Exception -  product_description_screen.dart - _getBannerProductDetail():" +
              e.toString());
    }
  }

  _getProductDetail() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getProductDetail(productId).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _productDetail = result.data;
            } else {
              _productDetail = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print(
          "Exception -  product_description_screen.dart - _getProductDetail():" +
              e.toString());
    }
  }

  _init() async {
    try {
      if (screenId == 0) {
        await _getBannerProductDetail();
      } else if (productDetail != null) {
        _productDetail = productDetail;
      } else {
        await _getProductDetail();
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception -  product_description_screen.dart - _init():" +
          e.toString());
    }
  }

  Widget _productDescription(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        _productDetail.productDetail.description != null &&
                _productDetail.productDetail.description != ''
            ? _productDetail.productDetail.description
            : _productDetail.productDetail.type,
        style: textTheme.bodyText1.copyWith(
          height: 1.3,
        ),
      ),
    );
  }

  Widget _productNameAndPrice(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _productDetail.productDetail.productName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: textTheme.headline6,
            ),
            _productDetail.productDetail.discount != null &&
                    _productDetail.productDetail.discount > 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "${_productDetail.productDetail.discount}% OFF",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _productWeightAndQuantity(
      TextTheme textTheme, CartController value, int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${_productDetail.productDetail.varient[i].quantity} ${_productDetail.productDetail.varient[i].unit} / ${global.appInfo.currencySign} ${_productDetail.productDetail.varient[i].price}',
            style: textTheme.caption.copyWith(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '${global.appInfo.currencySign} ${_productDetail.productDetail.varient[i].mrp}',
              style: textTheme.caption
                  .copyWith(decoration: TextDecoration.lineThrough),
            ),
          ),
          Spacer(),
          _productDetail.productDetail.varient[i].stock > 0
              ? _productDetail.productDetail.varient[i].cartQty == null ||
                      _productDetail.productDetail.varient[i].cartQty == 0
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
                          ATCMS isSuccess = await value.addToCart(
                              _productDetail.productDetail, _qty, false,
                              varient: _productDetail.productDetail.varient[i]);
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
                              if (_productDetail
                                          .productDetail.varient[i].cartQty !=
                                      null &&
                                  _productDetail
                                          .productDetail.varient[i].cartQty ==
                                      1) {
                                _qty = 0;
                              } else {
                                _qty = _productDetail
                                        .productDetail.varient[i].cartQty - 1;
                              }

                              showOnlyLoaderDialog();
                              ATCMS isSuccess = await value.addToCart(
                                  _productDetail.productDetail, _qty, true,
                                  varient:
                                      _productDetail.productDetail.varient[i]);
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
                                child: _productDetail.productDetail.varient !=
                                            null &&
                                        _productDetail.productDetail.varient[i]
                                                .cartQty ==
                                            1
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
                              borderRadius: BorderRadius.all(Radius.circular(
                                      5.0) //                 <--- border radius here
                                  ),
                            ),
                            child: Center(
                              child: Text(
                                "${_productDetail.productDetail.varient[i].cartQty}",
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
                              if (_productDetail
                                      .productDetail.varient[i].stock >
                                  _productDetail
                                      .productDetail.varient[i].cartQty) {
                                _qty = _productDetail
                                        .productDetail.varient[i].cartQty +
                                    1;

                                showOnlyLoaderDialog();
                                ATCMS isSuccess = await value.addToCart(
                                    _productDetail.productDetail, _qty, false,
                                    varient: _productDetail
                                        .productDetail.varient[i]);
                                if (isSuccess.isSuccess != null) {
                                  Navigator.of(context).pop();
                                }
                                showToast(isSuccess.message);
                              } else {
                                showToast("No more stock available.");
                              }

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
              : Text(
                  '${AppLocalizations.of(context).txt_out_of_stock}',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                )
        ],
      ),
    );
  }

  Widget _relatedProducts(TextTheme textTheme) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: _productDetail.similarProductList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  _isDataLoaded = false;
                  productId =
                      _productDetail.similarProductList[index].productId;

                  _init();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                        imageUrl: global.appInfo.imageUrl +
                            _productDetail
                                .similarProductList[index].productImage,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(image: imageProvider)),
                        ),
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => SizedBox(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 60,
                        child: Text(
                          _productDetail.similarProductList[index].productName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 260,
                    child: Card(
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Card(elevation: 0),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Card(elevation: 0),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Card(elevation: 0),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Card(elevation: 0),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: SizedBox(
                              width: 70,
                              child: Card(
                                elevation: 0,
                              )),
                        );
                      }),
                ),
              ],
            ),
          )),
    );
  }

  _showVarientModalBottomSheet(TextTheme textTheme, CartController value) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return GetBuilder<CartController>(
            init: cartController,
            builder: (value) => Container(
              height: (_productDetail.productDetail.varient != null &&
                      _productDetail.productDetail.varient.length < 2)
                  ? 200
                  : 400,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _productDetail.productDetail.productName,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _productDetail.productDetail.varient.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            title: ReadMoreText(
                              '${_productDetail.productDetail.varient[i].description}',
                              trimLines: 2,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 16),
                              lessStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 16),
                              moreStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 16),
                            ),
                            subtitle: Text(
                                '${_productDetail.productDetail.varient[i].quantity} ${_productDetail.productDetail.varient[i].unit} / ${global.appInfo.currencySign} ${_productDetail.productDetail.varient[i].price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(fontSize: 15)),
                            trailing: _productDetail
                                .productDetail.varient[i].stock>0?_productDetail
                                            .productDetail.varient[i].cartQty ==
                                        null ||
                                    _productDetail
                                            .productDetail.varient[i].cartQty ==
                                        0
                                ? InkWell(
                                    onTap: () async {
                                      if (_productDetail.productDetail
                                          .varient[i].cartQty ==
                                          null) {
                                        _productDetail.productDetail
                                            .varient[i].cartQty = 0;
                                      }
                                      if (_productDetail
                                              .productDetail.varient[i].stock >=
                                          _productDetail.productDetail
                                              .varient[i].cartQty) {
                                        if (global.currentUser.id == null) {
                                          Get.to(LoginScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                          ));
                                        } else {
                                          _qty = 1;
                                          showOnlyLoaderDialog();
                                          ATCMS isSuccess =
                                              await value.addToCart(
                                                  _productDetail.productDetail,
                                                  _qty,
                                                  false,
                                                  varient: _productDetail
                                                      .productDetail
                                                      .varient[i]);

                                          if (isSuccess.isSuccess != null) {
                                            Navigator.of(context).pop();
                                          }
                                          showToast(isSuccess.message);
                                          setState(() {});
                                        }
                                      } else {
                                        showToast(
                                            'No more stock available for this variant');
                                      }
                                    },
                                    child: Container(
                                      height: 23,
                                      width: 23,
                                      alignment: Alignment.center,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      child: Icon(
                                        Icons.add,
                                        size: 17.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            if (_productDetail.productDetail
                                                .varient[i].cartQty !=
                                                null &&
                                                _productDetail.productDetail
                                                    .varient[i].cartQty ==
                                                    1) {
                                              _qty = 0;
                                            } else {
                                              _qty = _productDetail
                                                  .productDetail
                                                  .varient[i]
                                                  .cartQty -
                                                  1;
                                            }

                                            showOnlyLoaderDialog();
                                            ATCMS isSuccess =
                                            await value.addToCart(
                                                _productDetail
                                                    .productDetail,
                                                _qty,
                                                true,
                                                varient: _productDetail
                                                    .productDetail
                                                    .varient[i]);
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              child: _productDetail
                                                              .productDetail
                                                              .varient !=
                                                          null &&
                                                      _productDetail
                                                              .productDetail
                                                              .varient[i]
                                                              .cartQty ==
                                                          1
                                                  ? Icon(
                                                      Icons.delete,
                                                      size: 17.0,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    )
                                                  : Icon(
                                                      MdiIcons.minus,
                                                      size: 17.0,
                                                      color: Theme.of(context)
                                                          .primaryColor,
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
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5.0) //                 <--- border radius here
                                                ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${_productDetail.productDetail.varient[i].cartQty}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (_productDetail.productDetail
                                                .varient[i].cartQty ==
                                                null) {
                                              _productDetail.productDetail
                                                  .varient[i].cartQty = 0;
                                            }
                                            if (_productDetail.productDetail
                                                .varient[i].stock >=
                                                _productDetail.productDetail
                                                    .varient[i].cartQty) {
                                              _qty = _productDetail.productDetail
                                                  .varient[i].cartQty +
                                                  1;

                                              showOnlyLoaderDialog();
                                              ATCMS isSuccess =
                                              await value.addToCart(
                                                  _productDetail
                                                      .productDetail,
                                                  _qty,
                                                  false,
                                                  varient: _productDetail
                                                      .productDetail
                                                      .varient[i]);
                                              if (isSuccess.isSuccess != null) {
                                                Navigator.of(context).pop();
                                              }
                                              showToast(isSuccess.message);
                                            }
                                            else {
                                              showToast(
                                                  'No more stock available for this variant');
                                            }

                                            setState(() {});
                                          },
                                          child: Container(
                                              height: 23,
                                              width: 23,
                                              alignment: Alignment.center,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              child: Icon(
                                                MdiIcons.plus,
                                                size: 17,
                                              )),
                                        )
                                      ],
                                    ),
                                  ):Text(
                              '${AppLocalizations.of(context).txt_out_of_stock}',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _subHeading(TextTheme textTheme, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        value,
        style: textTheme.subtitle1.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _tags(TextTheme textTheme) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
            height: 100,
            child: Wrap(
              children: _tagsList(),
            )));
  }

  List<Widget> _tagsList() {
    List<Widget> list = [];
    for (int i = 0; i < _productDetail.productDetail.tags.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(right: 2),
        child: MyChip(
          isSelected: _productDetail.productDetail.tags[i].isSelected,
          onPressed: () {
            setState(() {
              _productDetail.productDetail.tags
                  .map((e) => e.isSelected = false)
                  .toList();
              _selectedIndex = i;
              if (_selectedIndex == i) {
                _productDetail.productDetail.tags[i].isSelected = true;
              }
            });
            Get.to(() => ProductListScreen(
                  a: widget.analytics,
                  o: widget.observer,
                  screenId: 2,
                  categoryName: _productDetail.productDetail.tags[i].tag,
                ));
          },
          label: _productDetail.productDetail.tags[i].tag != null
              ? '#${_productDetail.productDetail.tags[i].tag}'
              : '',
        ),
      ));
    }
    return list;
  }
}
