import { Router } from "express";
import { getAccount, getInfAccounts } from "../controllers/account.controller.js";

const router = Router()
router.get('/account', getAccount)
router.get('/InfoAccount', getInfAccounts)

export default router