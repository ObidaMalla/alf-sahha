// src/routes/restaurantRoutes.js
import express from "express";
import { create, list, getOne } from "../controllers/restaurantController.js";
import { create as createCode } from "../controllers/inviteCodeController.js";
import { protect } from "../middlewares/authMiddleware.js";
import { authorizeRole, authorizeOwnRestaurant } from "../middlewares/roleMiddleware.js";
import { create as createMenuItem, list as listMenuItems } from "../controllers/menuItemController.js";
import { listForRestaurant } from "../controllers/orderController.js";

import { stats } from "../controllers/restaurantController.js";

 import { upload } from "../middlewares/upload.middleware.js";
 
import { list as listStaffCtrl, remove as removeStaffCtrl } from "../controllers/staffController.js";

const router = express.Router();

router.get("/", list);
router.get("/:id", getOne);
 router.post("/", protect, upload.single("image"), create);
router.post(
  "/:id/invite-codes",
  protect,
  authorizeRole("OWNER"),
  authorizeOwnRestaurant("id"),
  createCode
);


//sprint 3

router.get("/:id/menu-items", protect, listMenuItems);
router.post(
  "/:id/menu-items",
  protect,
  authorizeRole("EMPLOYEE"),
  authorizeOwnRestaurant("id"),
  upload.single("image"),
  createMenuItem
);

//sprint 4
router.get(
  "/:id/orders",
  protect,
  authorizeRole("EMPLOYEE"),
  authorizeOwnRestaurant("id"),
  listForRestaurant
);

//Sprint 7

router.get("/:id/stats", protect, authorizeRole("OWNER"), authorizeOwnRestaurant("id"), stats);



//Get and delete staff 

router.get("/:id/staff", protect, authorizeRole("OWNER"), authorizeOwnRestaurant("id"), listStaffCtrl);
router.delete("/:id/staff/:staffId", protect, authorizeRole("OWNER"), authorizeOwnRestaurant("id"), removeStaffCtrl);
export default router;