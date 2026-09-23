import { prisma } from "../config/prisma.js";
import { ApiError } from "../utils/ApiError.js";

// دالة لجلب رصيد محفظة المستخدم مع سجل المعاملات المالية الخاصة به
export const getWallet = async (userId) => {
  // البحث عن المستخدم في قاعدة البيانات وجلب رصيد المحفظة فقط (Optimization)
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: { walletBalance: true },
  });

  // التحقق من وجود المستخدم، وفي حال عدم العثور عليه يتم رمي خطأ 404
  if (!user) {
    throw new ApiError(404, "المستخدم الذي تبحث عنه غير موجود");
  }
const transactions = await prisma.transaction.findMany({
  where: {
    OR: [{ fromUserId: userId }, { toUserId: userId }],
  },
  orderBy: { createdAt: "desc" },
});

// إضافة الاتجاه والإشارة بالنسبة للمستخدم الحالي
const enrichedTransactions = transactions.map((tx) => {
  const isSender = tx.fromUserId === userId;
  return {
    ...tx,
    direction: isSender ? "DEBIT" : "CREDIT", // دفع أو استلام
    signedAmount: isSender ? -tx.amount : tx.amount,
  };
});

return {
  balance: user.walletBalance,
  transactions: enrichedTransactions,
};
};