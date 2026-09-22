import multer from "multer";

const storage = multer.memoryStorage(); // بافر مؤقت بالذاكرة، مش عالقرص

const fileFilter = (req, file, cb) => {
  const allowedTypes = ["image/jpeg", "image/png", "image/webp"];
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error("نوع الصورة غير مدعوم — بس JPEG أو PNG أو WEBP"), false);
  }
};

export const upload = multer({
  storage,
  fileFilter,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB
});