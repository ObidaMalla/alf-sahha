import { asyncHandler } from "../utils/asyncHandler.js";
import { successHandler } from "../handlers/successHandler.js";
import { ApiError } from "../utils/ApiError.js";
import { createInviteCode, redeemInviteCode } from "../services/inviteCodeService.js";

export const create = asyncHandler(async (req, res) => {
  const inviteCode = await createInviteCode(req.user.id, req.params.id);
  return successHandler(res, 201, "تم توليد الكود بنجاح", inviteCode);
});

export const redeem = asyncHandler(async (req, res) => {
  const { code } = req.body;
  if (!code) throw new ApiError(400, "الكود مطلوب");

  const result = await redeemInviteCode(req.user.id, code);
  return successHandler(res, 200, "👌💯تم قبول الكود، صرت موظف بالمطعم", result);
});