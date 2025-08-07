
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Category {
  final String name;
  final String imagePath;
  Category({required this.name, required this.imagePath});
}

class CategoryController extends GetxController {
  var name = ''.obs;
  var imagePath = ''.obs;

  // Dummy data
  var categories = <Category>[
    Category(name: 'T-Shirts', imagePath: 'assets/images/visa.png'),
    Category(name: 'Hoodies', imagePath: 'assets/images/visa.png'),
    Category(name: 'Accessories', imagePath: 'assets/images/visa.png'),
  ].obs;

  void setName(String value) => name.value = value;
  void setImagePath(String value) => imagePath.value = value;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setImagePath(pickedFile.path);
    }
  }

  void addCategory() {
    if (name.value.isNotEmpty && imagePath.value.isNotEmpty) {
      categories.add(Category(name: name.value, imagePath: imagePath.value));
      clear();
    }
  }

  void clear() {
    name.value = '';
    imagePath.value = '';
  }
}