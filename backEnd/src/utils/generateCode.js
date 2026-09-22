import crypto from "crypto";

export const generateInviteCode = () => {
  return crypto.randomBytes(4).toString("hex").toUpperCase(); // مثال: "A1B2C3D4"
};