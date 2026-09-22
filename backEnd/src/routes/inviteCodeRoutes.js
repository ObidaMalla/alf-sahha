// src/routes/inviteCodeRoutes.js
import express from "express";
import { redeem } from "../controllers/inviteCodeController.js";
import { protect } from "../middlewares/authMiddleware.js";

const router = express.Router();

//"تفعيل" (تفعيل الكود):redeem
router.post("/redeem", protect, redeem);

export default router;