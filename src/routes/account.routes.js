import { Router } from "express";
import { getAccount } from "../controllers/account.controller.js";

const router = Router()
router.get('/account', getAccount)

export default router