import { prisma } from "../config/prisma.js"; 
import { ApiError } from "../utils/ApiError.js"; 
// Defining a function to create a new item in restaurant
export const createMenuItem = async (restaurantId, { name, description, price, category, imageUrl }) => { 
  return prisma.menuItem.create({ // استخدام Prisma لإنشاء سجل جديد في جدول الأصناف
    //The data passed
    data: { restaurantId, name, description, price, category, imageUrl }, 
  });
}; 
// Defining a function to update a  item in restaurant

export const updateMenuItem = async (itemId, employeeRestaurantId, data) => { 
  const item = await prisma.menuItem.findUnique({ where: { id: itemId } }); // البحث عن الصنف في قاعدة البيانات حسب المعرف
  if (!item) throw new ApiError(404, "هذا الصنف غير موجود"); 
  if (item.restaurantId !== employeeRestaurantId) { // التأكد من أن الصنف ينتمي لنفس مطعم الموظف الحالي
    throw new ApiError(403, "هذا الصنف لا ينتمي إلى مطعمك"); 
  } 
  return prisma.menuItem.update({ where: { id: itemId }, data }); // تحديث بيانات الصنف في قاعدة البيانات وإرجاع النتيجة
}; 
// Defining a function to delete  the item  in restaurant
export const deleteMenuItem = async (itemId, employeeRestaurantId) => {
  const item = await prisma.menuItem.findUnique({ where: { id: itemId } }); 
  if (!item) throw new ApiError(404, "هذا الصنف غير موجود"); 
  if (item.restaurantId !== employeeRestaurantId) { // التأكد من أن الصنف ينتمي لنفس مطعم الموظف الحالي
    throw new ApiError(403, "هذا الصنف لا ينتمي إلى مطعمك");
  }
  await prisma.menuItem.delete({ where: { id: itemId } }); //delete the item from  the DB permanently
}; 
// Defining a function to get all the  item in restaurant

export const listMenuItems = async (restaurantId) => { 
  return prisma.menuItem.findMany({ where: { restaurantId } }); // جلب وإرجاع كل الأصناف التي تطابق معرف المطعم
};