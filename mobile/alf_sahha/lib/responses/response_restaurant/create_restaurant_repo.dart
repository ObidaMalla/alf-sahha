import 'dart:io'; // ضروري لاستيراد مكتبة File

import '../../models/restaurant/create_restaurant_model.dart';
import '../../routes/restaurant/restaurant_routes.dart';
import '../apiExceptionHandler.dart';

class CreateRestaurantRepository {
  final RestaurantService restaurantService;
  CreateRestaurantRepository(this.restaurantService);

  Future<CreateRestaurantModel> createRestaurant({
    required String name,
    String? description,
    String? address,
    File? image, // استبدلنا imageUrl بملف الصورة الفعلي
  }) {
    return ApiExceptionHandler.handle<CreateRestaurantModel>(
      // استدعاء دالة ريتروفيت بالطريقة المباشرة (Named Parameters)
      () => restaurantService.createRestaurant(
        name: name,
        description: description,
        address: address,
        image: image,
      ),
      fallbackErrorMessage: 'فشل إنشاء المطعم 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
