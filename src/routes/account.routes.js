import { Router } from "express";
import { getAccount, getInfAccounts, isAuthenticated } from "../controllers/account.controller.js";

const router = Router()

router.get('/account', getAccount)
router.get('/InfoAccount', isAuthenticated, getInfAccounts);

export default router