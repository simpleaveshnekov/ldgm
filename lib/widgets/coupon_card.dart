import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/couponsModel.dart';

class CouponsCard extends StatefulWidget {
  final Coupon coupon;
  final Function onRedeem;
  CouponsCard({this.coupon, this.onRedeem}) : super();

  @override
  _CouponsCardState createState() => _CouponsCardState(coupon: coupon, onRedeem: onRedeem);
}

class _CouponsCardState extends State<CouponsCard> {
  Coupon coupon;
  Function onRedeem;
  final Color color = const Color(0xffFF0000);
  final double height = Get.height;
  final double width = Get.width;
  _CouponsCardState({this.coupon, this.onRedeem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        height: height * 0.18,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: global.appInfo.imageUrl + coupon.couponImage,
                imageBuilder: (context, imageProvider) => Container(
                  child: Container(
                    margin: EdgeInsets.only(top: 12, bottom: 12),
                    width: 75,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.red, image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                  ),
                ),
                placeholder: (context, url) => Container(margin: EdgeInsets.only(top: 12, bottom: 12), width: 75, child: Center(child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => Container(
                  margin: EdgeInsets.only(top: 12, bottom: 12),
                  width: 75,
                  child: Icon(
                    Icons.image,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: width - 135,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: height * 0.040,
                          width: width * 0.2,
                          child: Center(
                              child: Text(
                            "${coupon.couponCode}",
                            style: TextStyle(color: Colors.grey),
                          )),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        coupon.userUses == coupon.usesRestriction
                            ? SizedBox()
                            : InkWell(
                                onTap: () => onRedeem(),
                                child: Container(
                                  height: height * 0.040,
                                  width: width * 0.2,
                                  child: Center(child: Text("${AppLocalizations.of(context).btn_redeem}", style: TextStyle(color: Colors.white))),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    border: Border.all(color: Colors.transparent),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(coupon.couponName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(
                          coupon.couponDescription,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        LinearPercentIndicator(
                          width: 140,
                          lineHeight: 5.0,
                          percent: (coupon.userUses / coupon.usesRestriction) * 0.1,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          progressColor: const Color(0xffFF0000),
                          fillColor: Theme.of(context).primaryColor,
                        ),
                        Row(
                          children: [
                            Text(
                              '   ${coupon.userUses} / ${coupon.usesRestriction} ${AppLocalizations.of(context).btn_uses}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
