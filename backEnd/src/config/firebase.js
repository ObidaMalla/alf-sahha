import { initializeApp, cert } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";

// 👇 هون الفرق عن مشاريعي السابقة  — نقرأ من process.env مباشرة، مش من ملف
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

initializeApp({ credential: cert(serviceAccount) });

const messaging = getMessaging();
export default messaging;