import express from "express";
import { create, accept, reject,complete,listMyOrders } from "../controllers/orderController.js";
import { protect } from "../middlewares/authMiddleware.js";
import { authorizeRole } from "../middlewares/roleMiddleware.js";
import { pay } from "../controllers/orderController.js";


const router = express.Router();

router.post("/", protect, create);
router.patch("/:id/accept", protect, authorizeRole("EMPLOYEE"), accept);
router.patch("/:id/reject", protect, authorizeRole("EMPLOYEE"), reject);

//import { pay } from "../controllers/orderController.js";
router.post("/:id/pay", protect, pay);

//Sprint 6
router.patch("/:id/complete", protect, authorizeRole("EMPLOYEE"), complete);


//فكرة اثناء التطوير
router.get("/my", protect, listMyOrders); //  طلبات الزبون الحالي


export default router;