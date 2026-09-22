import express from "express";
import { register, login, logout } from "../controllers/authController.js";
import { protect } from "../middlewares/authMiddleware.js";


const router = express.Router();
//Sprint 1

router.post("/register", register);
router.post("/login", login);
router.post("/logout", protect, logout);

export default router;