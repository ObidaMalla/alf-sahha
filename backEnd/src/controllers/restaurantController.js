// src/controllers/restaurantController.js
import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js";
import { successHandler } from "../handlers/successHandler.js";
import { createRestaurant, listRestaurants, getRestaurantById } from "../services/restaurantService.js";
import { getRestaurantStats } from "../services/statsService.js";
 import { uploadImageBuffer } from "../services/upload.service.js";


export const create = asyncHandler(async (req, res) => {
const { name, description, address } = req.body;
  if (!name) throw new ApiError(400, "اسم المطعم مطلوب");
let imageUrl = null;
  if (req.file) {
     imageUrl = await uploadImageBuffer(req.file.buffer, "restaurants");
 }
  const result = await createRestaurant(req.user.id, { name, description, address, imageUrl });
  return successHandler(res, 201, "تم إنشاء المطعم بنجاح", result);
});

export const list = asyncHandler(async (req, res) => {
  const restaurants = await listRestaurants();
  return successHandler(res, 200, "تم جلب المطاعم بنجاح", restaurants);
});

export const getOne = asyncHandler(async (req, res) => {
  const restaurant = await getRestaurantById(req.params.id);
  return successHandler(res, 200, "تم جلب المطعم بنجاح", restaurant);
});

//Sprint 7

export const stats = asyncHandler(async (req, res) => {
  const result = await getRestaurantStats(req.params.id, req.user.id);
  return successHandler(res, 200, "تم جلب الإحصائيات بنجاح", result);
});