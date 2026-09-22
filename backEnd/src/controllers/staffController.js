import { asyncHandler } from "../utils/asyncHandler.js";
import { successHandler } from "../handlers/successHandler.js";
import { listStaff, removeStaff } from "../services/staffService.js";

export const list = asyncHandler(async (req, res) => {
  const staff = await listStaff(req.params.id, req.user.id);
  return successHandler(res, 200, "تم جلب الموظفين بنجاح", staff);
});

export const remove = asyncHandler(async (req, res) => {
  await removeStaff(req.params.id, req.user.id, req.params.staffId);
  return successHandler(res, 200, "تم طرد الموظف بنجاح");
});