import express from "express";
import authRoutes from "./authRoutes.js"; 
import walletRoutes from "./walletRoutes.js"; // 1. استيراد مسارات المحفظة

import restaurantRoutes from "./restaurantRoutes.js";
import inviteCodeRoutes from "./inviteCodeRoutes.js";

import menuItemRoutes from "./menuItemRoutes.js";

import orderRoutes from "./orderRoutes.js";

import notificationRoutes from "./notificationRoutes.js";
import { startOrderExpiryJob } from "../jobs/orderExpiry.job.js"; // 👈 احذف .job من المنتصف لتصبح .js فقط


import profileRoutes from "./profileRoutes.js";
const router = express.Router();


// Health Check Endpoint
router.get("/", (req, res) => {
  res.json({
    success: true,
    statusCode: 200,
    message: "API is Running",
    data: null,
  });
});
router.use("/api/auth", authRoutes); 
router.use("/api/wallet", walletRoutes); 

router.use("/api/restaurants", restaurantRoutes);
router.use("/api/invite-codes", inviteCodeRoutes);
router.use("/api/menu-items", menuItemRoutes);

// Import and register your routes here
// Example:
// import authRoutes from "./authRoutes.js";
// router.use("/auth", authRoutes);

//sprint 4
router.use("/api/orders", orderRoutes);

//Sprint 6
router.use("/api/notifications", notificationRoutes);

// ==========================================
// ⏱️ تشغيل الـ Cron Job هنا لكي يتم استخدامه ويختفي التحذير
// ==========================================
startOrderExpiryJob();



//Profile Sprint
router.use("/api/profile", profileRoutes);

export default router;