import { asyncHandler } from "../utils/asyncHandler.js";
import { successHandler } from "../handlers/successHandler.js";
import { getProfile, updateProfile } from "../services/profileService.js";

export const getMe = asyncHandler(async (req, res) => {
  const profile = await getProfile(req.user.id);
  return successHandler(res, 200, "تم جلب البروفايل بنجاح", profile);
});

export const updateMe = asyncHandler(async (req, res) => {
  const { email, currentPassword, newPassword } = req.body;
  const profile = await updateProfile(req.user.id, { email, currentPassword, newPassword });
  return successHandler(res, 200, "تم تحديث البيانات الشخصية بنجاح", profile);
});