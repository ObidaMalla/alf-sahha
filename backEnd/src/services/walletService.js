import { prisma } from "../config/prisma.js";
import { ApiError } from "../utils/ApiError.js";

// دالة لجلب رصيد محفظة المستخدم مع سجل المعاملات المالية الخاصة به
export const getWallet = async (userId) => {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: { walletBalance: true },
  });

  if (!user) {
    throw new ApiError(404, "المستخدم الذي تبحث عنه غير موجود");
  }

  const transactions = await prisma.transaction.findMany({
    where: {
      OR: [{ fromUserId: userId }, { toUserId: userId }],
    },
    orderBy: { createdAt: "desc" },
  });

  const enrichedTransactions = transactions.map((tx) => {
    const isSender = tx.fromUserId === userId;
    return {
      ...tx,
      direction: isSender ? "DEBIT" : "CREDIT",
      signedAmount: isSender ? `-${tx.amount}` : `+${tx.amount}`,
    };
  });

  return {
    balance: user.walletBalance,
    transactions: enrichedTransactions,
  };
};