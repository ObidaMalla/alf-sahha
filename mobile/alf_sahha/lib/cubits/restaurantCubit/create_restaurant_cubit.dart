import 'dart:io'; // 1. استيراد مكتبة File

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/restaurant/create_restaurant_model.dart';
import '../../responses/response_restaurant/create_restaurant_repo.dart';
import '../../token/token_storage.dart';
import '../results_state.dart';

class CreateRestaurantCubit extends Cubit<ResultState<CreateRestaurantModel>> {
  final CreateRestaurantRepository createRestaurantRepo;
  CreateRestaurantCubit(this.createRestaurantRepo)
    : super(const ResultState.idle());

  Future<void> createRestaurant({
    required String name,
    String? description,
    String? address,
    File? image, // 2. استقبال ملف الصورة بدل imageUrl
  }) async {
    emit(const ResultState.loading());
    try {
      final response = await createRestaurantRepo.createRestaurant(
        name: name,
        description: description,
        address: address,
        image: image, // 3. تمرير ملف الصورة للريبوسيتوري
      );

      // تحديث التوكن والصلاحية محلياً
      final newToken = response.data?.token;
      if (newToken != null) {
        await TokenStorage.saveToken(newToken);
        await TokenStorage.saveRole('OWNER');
      }

      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }
}
