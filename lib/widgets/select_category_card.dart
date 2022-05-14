import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/categoryListModel.dart';
import 'package:user/models/subCategoryModel.dart';

class SelectCategoryCard extends StatefulWidget {
  final CategoryList category;

  final Function onPressed;
  final bool isSelected;
  final double borderRadius;
  final SubCategory subCategory;
  final key;
  final int screenId;
  SelectCategoryCard({this.category, @required this.isSelected, @required this.onPressed, this.borderRadius, this.key, this.subCategory, this.screenId}) : super();

  @override
  _SelectCategoryCardState createState() => _SelectCategoryCardState(category: category, isSelected: isSelected, onPressed: onPressed, borderRadius: borderRadius, key: key, subCategory: subCategory, screenId: screenId);
}

class _SelectCategoryCardState extends State<SelectCategoryCard> {
  CategoryList category;
  Function onPressed;
  bool isSelected;
  double borderRadius;
  SubCategory subCategory;
  var key;
  int screenId;
  _SelectCategoryCardState({this.category, @required this.isSelected, @required this.onPressed, this.borderRadius, this.key, this.subCategory, this.screenId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 3, bottom: 3,right: 16),
      decoration: BoxDecoration(
        borderRadius: borderRadius == null ? BorderRadius.circular(5) : BorderRadius.circular(5),
        color: isSelected ? Theme.of(context).primaryColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            blurRadius: 4,
            offset: Offset(0, 0.75),
          )
        ],
      ),
      child: ElevatedButton(
        key: key,
        style: ElevatedButton.styleFrom(
          primary: isSelected ? Theme.of(context).primaryColor : Colors.white,
          shadowColor: Theme.of(context).primaryColor,
          elevation: isSelected ? 5 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius == null ? BorderRadius.circular(5) : BorderRadius.circular(5),
          ),
          fixedSize: Size.fromWidth(93),
        ),
        onPressed: () {
          onPressed();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: screenId == 1 ? global.appInfo.imageUrl + subCategory.image : global.appInfo.imageUrl + category.image,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundColor: isSelected ? Colors.white : Color(0xffFFF5F4),
                    radius: 35,
                    backgroundImage: imageProvider,
                  ),

                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: isSelected ? Colors.white : Color(0xffFFF5F4),
                    radius: 30,
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: 42,
                alignment: Alignment.center,
                child: Text(
                  screenId == 1 ? subCategory.title : category.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: !isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class SelectCategoryCard1 extends StatefulWidget {
  final CategoryList category;

  final Function onPressed;
  final bool isSelected;
  final double borderRadius;
  final SubCategory subCategory;
  final key;
  final int screenId;
  SelectCategoryCard1({this.category, @required this.isSelected, @required this.onPressed, this.borderRadius, this.key, this.subCategory, this.screenId}) : super();

  @override
  _SelectCategoryCardState1 createState() => _SelectCategoryCardState1(category: category, isSelected: isSelected, onPressed: onPressed, borderRadius: borderRadius, key: key, subCategory: subCategory, screenId: screenId);
}

class _SelectCategoryCardState1 extends State<SelectCategoryCard1> {
  CategoryList category;
  Function onPressed;
  bool isSelected;
  double borderRadius;
  SubCategory subCategory;
  var key;
  int screenId;
  _SelectCategoryCardState1({this.category, @required this.isSelected, @required this.onPressed, this.borderRadius, this.key, this.subCategory, this.screenId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 3, bottom: 3,right: 16),
      decoration: BoxDecoration(
        borderRadius: borderRadius == null ? BorderRadius.circular(5) : BorderRadius.circular(5),
        color: isSelected ? Theme.of(context).primaryColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            blurRadius: 4,
            offset: Offset(0, 0.75),
          )
        ],
      ),
      child: ElevatedButton(
        key: key,
        style: ElevatedButton.styleFrom(
          primary: isSelected ? Theme.of(context).primaryColor : Colors.white,
          shadowColor: Theme.of(context).primaryColor,
          elevation: isSelected ? 5 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius == null ? BorderRadius.circular(5) : BorderRadius.circular(5),
          ),
          fixedSize: Size.fromWidth(93),
        ),
        onPressed: () {
          onPressed();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                height: 62,
                child: CachedNetworkImage(
                  imageUrl: screenId == 1 ? global.appInfo.imageUrl + subCategory.image : global.appInfo.imageUrl + category.image,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundColor: isSelected ? Colors.white : Color(0xffFFF5F4),
                    radius: 35,
                    backgroundImage: imageProvider,
                  ),

                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: isSelected ? Colors.white : Color(0xffFFF5F4),
                    radius: 30,
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: 42,
                alignment: Alignment.center,
                child: Text(
                  screenId == 1 ? subCategory.title : category.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: !isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
