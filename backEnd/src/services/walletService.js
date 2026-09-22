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

  // جلب جميع المعاملات المالية التي يكون فيها المستخدم مرسلاً أو مستلماً مرتبة من الأحدث للأقدم
  const transactions = await prisma.transaction.findMany({
    ///هاد بيرجع كل الحركات المالية يلي أنت طرف فيها، سواء كنت المرسل (دفعت طلبية) أو المستقبل (استلمت منحة التسجيل، أو استلمت فلوس كمالك مطعم).
    ///////////////////
    /////////////////////
    //impooooooooortant
    /*نقطة صغيرة بس مهمة تلاحظها: بالـ OR: [{ fromUserId: userId }, { toUserId: userId }] — هاد بيرجع كل الحركات المالية يلي أنت طرف فيها، سواء كنت المرسل (دفعت طلبية) أو المستقبل (استلمت منحة التسجيل، أو استلمت فلوس كمالك مطعم). جرب لما توصل لـ Sprint 5 (الدفع) ترجع تشوف هاد الـ endpoint وتتأكد إنه عم يورجيك الحركتين (خصم من الزبون + إيداع للمالك) بشكل صحيح. */
    where: {
      OR: [{ fromUserId: userId }, { toUserId: userId }],
    },
    orderBy: { createdAt: "desc" },
  });

  // إرجاع الرصيد الحالي مع قائمة المعاملات
  return {
    balance: user.walletBalance,
    transactions,
  };
};