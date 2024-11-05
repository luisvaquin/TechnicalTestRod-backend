import { Router } from "express";
import { getTransfers, postTransfers } from "../controllers/transfers.controller.js";

const router = Router()

router.post('/transfer', postTransfers)
router.get('/transfer', getTransfers)

export default router