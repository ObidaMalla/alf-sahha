import "dotenv/config"; // يجب أن يكون في السطر الأول تماماً قبل أي import آخر
import express from "express";
import router from "./routes/index.js";
import { errorHandler } from "./handlers/errorHandler.js";


const app = express();

app.use(express.json());
app.use("/", router);

app.use(errorHandler);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(` done the Server is running on http://localhost:${PORT}`);
});