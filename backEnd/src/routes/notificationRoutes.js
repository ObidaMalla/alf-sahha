import express from "express";
import { list, unreadCount, read, remove } from "../controllers/notificationController.js";
import { protect } from "../middlewares/authMiddleware.js";

const router = express.Router();

router.get("/", protect, list);

// 👇 **جديد:** مسار جلب العدد (يجب أن يكون قبل :id)
router.get("/unread-count", protect, unreadCount);

router.patch("/:id/read", protect, read);

// 👇 **جديد:** مسار حذف إشعار
router.delete("/:id", protect, remove);

export default router;