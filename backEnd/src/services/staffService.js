import { prisma } from "../config/prisma.js";
import { ApiError } from "../utils/ApiError.js";

export const listStaff = async (restaurantId, ownerId) => {
  const restaurant = await prisma.restaurant.findUnique({ where: { id: restaurantId } });
  if (!restaurant || restaurant.ownerId !== ownerId) {
    throw new ApiError(403, "هاد المطعم مو إلك");
  }

  return prisma.restaurantStaff.findMany({
    where: { restaurantId },
    include: { user: { select: { id: true, name: true, email: true, createdAt: true } } },
    orderBy: { joinedAt: "asc" },
  });
};

export const removeStaff = async (restaurantId, ownerId, staffId) => {
  const restaurant = await prisma.restaurant.findUnique({ where: { id: restaurantId } });
  if (!restaurant || restaurant.ownerId !== ownerId) {
    throw new ApiError(403, "هاد المطعم مو إلك");
  }

  const staff = await prisma.restaurantStaff.findUnique({ where: { id: staffId } });
  if (!staff || staff.restaurantId !== restaurantId) {
    throw new ApiError(404, "الموظف مش موجود بهاد المطعم");
  }

  const activeOrder = await prisma.order.findFirst({
    where: {
      handledByUserId: staff.userId,
      status: { in: ["ACCEPTED", "PREPARING"] },
    },
  });

  if (activeOrder) {
    throw new ApiError(409, "هاد الموظف عندو طلب قيد التنفيذ حاليًا — لازم يخلص أو ينحل قبل ما تطردو");
  }

  await prisma.$transaction([
    prisma.restaurantStaff.delete({ where: { id: staffId } }),
    prisma.user.update({ where: { id: staff.userId }, data: { role: "CUSTOMER" } }),
  ]);
};