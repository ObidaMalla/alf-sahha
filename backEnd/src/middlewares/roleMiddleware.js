import { ApiError } from "../utils/ApiError.js";

export const authorizeRole = (...allowedRoles) => (req, res, next) => {
  if (!allowedRoles.includes(req.user.role)) {
    throw new ApiError(403, "ما عندك صلاحية للقيام بهذا الإجراء😊");
  }
  next();
};

export const authorizeOwnRestaurant = (paramName = "id") => (req, res, next) => {
  if (req.user.restaurantId !== req.params[paramName]) {
    throw new ApiError(403, "هذا المطعم ليس لك 😊");
  }
  next();
};