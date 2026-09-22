import 'dotenv/config'; // تحميل متغيرات البيئة من ملف .env تلقائياً إلى process.env

/*ما هو process.env؟
هو عبارة عن "مخزن" أو كائن (Object) مؤقت داخل ذاكرة الجهاز (RAM) أثناء تشغيل تطبيق الـ Node.js، وظيفته يحتفظ بكل الإعدادات والمتغيرات الخاصة بمشروعك (مثل رقم البورت، ورابط قاعدة البيانات، والمفاتيح السرية). */
import { PrismaClient } from "../../generated/prisma/client.js"; // استيراد PrismaClient من المسار المخصص المولد
import { PrismaPg } from "@prisma/adapter-pg"; // استيراد الـ Driver Adapter الخاص بقاعدة بيانات PostgreSQL

const adapter = new PrismaPg({ // إنشاء كائن adapter جديد لتوصيل قاعدة البيانات
    connectionString: process.env.DATABASE_URL // تمرير رابط الاتصال بقاعدة البيانات من متغيرات البيئة
});

export const prisma = new PrismaClient({ // تهيئة وتصدير PrismaClient مع استخدام الـ adapter المعرّف أعلاه
    adapter
});