
abstract class StringFormatter{
  static String convertListItemsToString(List<String> items) {
    String result = items[0];
    if (items.length == 1) {
      return result;
    }
    for (String item in items) {
      if(item == items[0]) continue;
      result = result + ", $item";
    }
    return result;
  }
  static String getImageExtension(String imageUrl){
    List<String> names = imageUrl.split(".");
    return names[1];
  }

  

}