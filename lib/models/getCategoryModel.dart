import 'package:user/models/categoryListModel.dart';

class Categories {
  int currentPage;
  List<CategoryList> categoryList = [];

  Categories();
  Categories.fromJson(Map<String, dynamic> json) {
    try {
      currentPage = json['current_page'] != null ? int.parse(json['current_page'].toString()) : null;
      categoryList = json['data'] != null ? List<CategoryList>.from(json['data'].map((x) => CategoryList.fromJson(x))) : [];
    } catch (e) {
      print("Exception - CategoriesModel.dart - Categories.fromJson():" + e.toString());
    }
  }
}
