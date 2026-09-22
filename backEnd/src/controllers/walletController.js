import { asyncHandler } from "../utils/asyncHandler.js";
import { successHandler } from "../handlers/successHandler.js";
import { getWallet } from "../services/walletService.js";

export const wallet = asyncHandler(async (req, res) => {
  const result = await getWallet(req.user.id);
  return successHandler(res, 200,  "💯 تم جلب بيانات المحفظة لهذا المستخدم بنجاح ", result);
});