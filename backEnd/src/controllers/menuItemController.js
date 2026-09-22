// استيراد دالة لتغليف العمليات غير المتزامنة والتقاط الأخطاء تلقائياً
import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js";
import { successHandler } from "../handlers/successHandler.js";
import {
  createMenuItem,
  updateMenuItem,
  deleteMenuItem,
  listMenuItems,
} from "../services/menuItemService.js";
import { uploadImageBuffer } from "../services/upload.service.js";
export const create = asyncHandler(async (req, res) => {
  const { name, description, price, category } = req.body;
  if (!name || !description || !price || !category) {
    throw new ApiError(400, "الاسم والوصف والسعر والفئة مطلوبين");
  } 

  // رفع الصورة إذا وجِدت في الطلب
  let imageUrl = null;
  if (req.file) {
    imageUrl = await uploadImageBuffer(req.file.buffer, "menu-items");
  }

  // استدعاء خدمة إنشاء الصنف وتمرير رابط الصورة الناتج
  const item = await createMenuItem(req.params.id, { 
    name, 
    description, 
    price, 
    category, 
    imageUrl 
  });
  
  return successHandler(res, 201, "👌تم إضافة الصنف بنجاح", item);
});

export const update = asyncHandler(async (req, res) => {
  const item = await updateMenuItem(req.params.itemId, req.user.restaurantId, req.body);
  return successHandler(res, 200, "👌تم تعديل الصنف بنجاح", item);

});
export const remove = asyncHandler(async (req, res) => {
  await deleteMenuItem(req.params.itemId, req.user.restaurantId);
  return successHandler(res, 200, "👌تم حذف الصنف بنجاح");

}); // إغلاق دالة remove

export const list = asyncHandler(async (req, res) => {
  const items = await listMenuItems(req.params.id);
  return successHandler(res, 200, "👌تم جلب المنيو بنجاح", items);

}); 