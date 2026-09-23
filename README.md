# 🍽️ Alf Sahha — Restaurant Order & Management System

نظام متكامل لإدارة طلبات المطاعم، يربط بين **مالك المطعم**، **الموظفين**، و**الزبائن** عبر REST API كامل بالباك إند وتطبيق موبايل بـ Flutter.

> 🔗 **Backend Live:** [alf-sahha.onrender.com](https://alf-sahha.onrender.com)

---

## 📋 نظرة عامة

تطبيق يحاكي دورة عمل مطعم حقيقي بالكامل: من تصفح المنيو، لإنشاء الطلب، لقبوله أو رفضه من الموظف، للدفع الإلكتروني عبر محفظة داخلية، وصولًا لتجهيز الطلب وإكماله — مع نظام صلاحيات متعدد الأدوار ونظام إشعارات فوري عبر Firebase.

### الأدوار الثلاثة بالنظام
| الدور | الصلاحيات |
|---|---|
| **Customer (زبون)** | تصفح المطاعم، تقديم الطلبات، الدفع من المحفظة، متابعة حالة الطلب لحظيًا |
| **Employee (موظف)** | إدارة قائمة الطعام، قبول/رفض الطلبات، تجهيزها وإكمالها |
| **Owner (مالك مطعم)** | إنشاء المطعم، توليد أكواد دعوة للموظفين، متابعة الإحصائيات والأرباح |

---

## ✨ أبرز الميزات التقنية

- **نظام صلاحيات (Role-Based Access Control)** مبني على JWT — كل مستخدم "زبون" بشكل افتراضي، ويكتسب أدوارًا إضافية (Owner / Employee) عبر أفعال داخل النظام
- **معالجة صريحة لحالات التزامن (Race Conditions)** عبر Conditional Updates — لمنع القبول أو الدفع المزدوج لنفس الطلب
- **محفظة إلكترونية داخلية** بعمليات مالية ذرية (Atomic Database Transactions) لضمان دقة وتناسق الأرصدة بين الزبائن وأصحاب المطاعم
- **Price Snapshotting** — سعر الصنف يُحفظ وقت الطلب، فتغيير الأسعار لاحقًا ما بيأثر على الطلبات القديمة
- **حساب السعر من طرف السيرفر حصرًا** (Server-side price calculation) — حماية من التلاعب بالأسعار من طرف العميل
- **مهام مجدولة (Cron Jobs)** لمعالجة الطلبات المنتهية الصلاحية تلقائيًا (بعد 5 دقائق بدون رد) وإخطار الأطراف المعنية
- **إشعارات Push فورية** عبر Firebase Cloud Messaging لكل حدث بدورة حياة الطلب
- **Blacklisted Tokens** لتسجيل خروج آمن رغم طبيعة JWT الـ Stateless

---

## 🛠️ التقنيات المستخدمة

**Backend:**
- Node.js + Express.js
- PostgreSQL + Prisma ORM
- JWT Authentication
- Firebase Admin SDK (Push Notifications)
- Cloudinary (رفع وتخزين الصور)
- node-cron (المهام المجدولة)

**Mobile:**
- Flutter + Dart
- معمارية MVVM (Cubit لإدارة الحالة، GetIt لحقن التبعيات، Dio/Retrofit للاتصال بالـ API)

---

## 🔄 دورة حياة الطلب

```
PENDING (بانتظار قرار الموظف — مهلة 5 دقائق)
   │
   ├──[قبول]──> ACCEPTED ──[دفع]──> PREPARING ──[تجهيز]──> COMPLETED
   │
   ├──[رفض مع سبب إجباري]──> REJECTED
   │
   └──[تجاوز 5 دقائق بدون رد]──> EXPIRED (تلقائيًا عبر Cron Job)
```

---

## 📡 أبرز الـ API Endpoints

| Method | Endpoint | الوصف |
|---|---|---|
| `POST` | `/api/auth/register` | إنشاء حساب جديد + رصيد 1000$ ترحيبي |
| `POST` | `/api/auth/login` | تسجيل الدخول |
| `POST` | `/api/restaurants` | إنشاء مطعم (يترقّى المستخدم لـ Owner) |
| `POST` | `/api/invite-codes/redeem` | استخدام كود دعوة (يترقّى المستخدم لـ Employee) |
| `GET/POST/PUT/DELETE` | `/api/restaurants/:id/menu-items` | إدارة قائمة الطعام |
| `POST` | `/api/orders` | إنشاء طلب جديد |
| `PATCH` | `/api/orders/:id/accept` `/reject` `/complete` | إدارة دورة حياة الطلب |
| `POST` | `/api/orders/:id/pay` | الدفع من المحفظة |
| `GET` | `/api/restaurants/:id/stats` | إحصائيات المطعم |
| `GET` | `/api/wallet` | الرصيد وسجل الحركات المالية |
| `GET` | `/api/notifications` | سجل الإشعارات |

---

## 🚀 التشغيل محليًا

### المتطلبات
- Node.js (v18+)
- PostgreSQL

### الخطوات

```bash
# 1. استنساخ المشروع
git clone https://github.com/ObidaMalla/alf-sahha.git
cd alf-sahha/backEnd

# 2. تثبيت الحزم
npm install

# 3. إعداد متغيرات البيئة
cp .env.example .env
# ثم عبّي القيم المطلوبة بملف .env (JWT_SECRET, DATABASE_URL, إلخ)

# 4. تطبيق الـ Migrations
npx prisma migrate deploy

# 5. تشغيل السيرفر
npm start
```

---

## 📂 هيكلية المشروع (Backend)

```
src/
├── config/         # إعدادات قاعدة البيانات ومتغيرات البيئة
├── routes/         # تعريف الـ endpoints
├── middlewares/    # التحقق من الهوية والصلاحيات
├── controllers/    # استقبال الطلبات وإرجاع الاستجابات
├── services/       # منطق العمل (Business Logic)
├── jobs/           # المهام المجدولة (Cron Jobs)
└── utils/          # أدوات مساعدة
```

---

## 👤 المطوّر

**عبيده عبد الفتاح ملا**
Full Stack Developer | Flutter & Node.js

📧 obidamalla@gmail.com | 📱 +963 981 674 273
