import express from "express";
import { update, remove } from "../controllers/menuItemController.js";
import { protect } from "../middlewares/authMiddleware.js";
import { authorizeRole } from "../middlewares/roleMiddleware.js";

const router = express.Router();

router.patch("/:itemId", protect, authorizeRole("EMPLOYEE"), update);
router.delete("/:itemId", protect, authorizeRole("EMPLOYEE"), remove);

export default router;