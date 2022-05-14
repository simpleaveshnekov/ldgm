import 'package:user/models/bannerModel.dart';
import 'package:user/models/categoryListModel.dart';
import 'package:user/models/categoryProductModel.dart';

class HomeScreenData {
  String status;
  String message;
  List<CategoryList> topCat = [];
  List<CategoryProdList> catProdList = [];
  List<Banner> banner = [];
  List<Banner> secondBanner = [];
  List<CategoryList> categoryList = [];
  List<Product> dealproduct = [];
  List<Product> topselling = [];
  List<Product> recentSellingProductList = [];
  List<Product> whatsnewProductList = [];
  List<Product> spotLightProductList = [];

  HomeScreenData();

  HomeScreenData.fromJson(Map<String, dynamic> json) {
    try {
      status = json["status"] != null ? json["status"] : null;
      message = json["message"] != null ? json["message"] : null;
      banner = json["banner"] != null
          ? List<Banner>.from(json["banner"].map((x) => Banner.fromJson(x)))
          : [];
      secondBanner = json["second_banner"] != null
          ? List<Banner>.from(
              json["second_banner"].map((x) => Banner.fromJson(x)))
          : [];
      topCat = json["top_cat"] != null
          ? List<CategoryList>.from(
              json["top_cat"].map((x) => CategoryList.fromJson(x)))
          : [];
      dealproduct = json["dealproduct"] != null
          ? List<Product>.from(
              json["dealproduct"].map((x) => Product.fromJson(x)))
          : [];
      topselling = json["topselling"] != null
          ? List<Product>.from(
              json["topselling"].map((x) => Product.fromJson(x)))
          : [];
      categoryList = json['top_cat'] != null
          ? List<CategoryList>.from(
              json["top_cat"].map((x) => CategoryList.fromJson(x)))
          : [];
      recentSellingProductList = json['recentselling'] != null
          ? List<Product>.from(
              json["recentselling"].map((x) => Product.fromJson(x)))
          : [];
      whatsnewProductList = json['whatsnew'] != null
          ? List<Product>.from(json["whatsnew"].map((x) => Product.fromJson(x)))
          : [];
      spotLightProductList = json['spotlight'] != null
          ? List<Product>.from(
              json["spotlight"].map((x) => Product.fromJson(x)))
          : [];
      catProdList = json['category'] != null
          ? List<CategoryProdList>.from(
          json["category"].map((x) => CategoryProdList.fromJson(x)))
          : [];
    } catch (e) {
      print(
          "Exception - homeScreenDataModel.dart - HomeScreenData.fromJson():" +
              e.toString());
    }
  }
}

class CategoryProdList {
  int cat_id;
  String cat_title;
  String description;
  List<Product> products = [];

  CategoryProdList();

  CategoryProdList.fromJson(Map<String, dynamic> json) {
    try {
      cat_id = json["cat_id"] != null ? int.parse('${json["cat_id"]}') : null;
      cat_title = json["cat_title"] != null ? '${json["cat_title"]}' : null;
      description =
          json["description"] != null ? '${json["description"]}' : null;
      products = json['products'] != null
          ? List<Product>.from(json["products"].map((x) => Product.fromJson(x)))
          : [];
    } catch (e) {
      print("Exception - CategoryProdList.dart - CategoryProdList.fromJson():" +
          e.toString());
    }
  }
}
