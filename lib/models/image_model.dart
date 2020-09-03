class Product {
  final int id;
  final List<Image> images;

  Product({this.id, this.images});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson["images"] as List;
    List<Image> imagesList = list.map((i) => Image.fromJson(i)).toList();
    return Product(
//      id: parsedJson['id'],
      images: imagesList,
    );
  }
}

class Image {
  final String image_url;

  Image({
    this.image_url,
  });

  factory Image.fromJson(Map<String, dynamic> parsedJson) {
    return Image(
      image_url: parsedJson["image_url"],
    );
  }
}
