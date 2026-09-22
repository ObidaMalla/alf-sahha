import express from "express";
import { getMe, updateMe } from "../controllers/profileController.js";
import { protect } from "../middlewares/authMiddleware.js";

const router = express.Router();

router.get("/", protect, getMe);
router.patch("/", protect, updateMe);

export default router;