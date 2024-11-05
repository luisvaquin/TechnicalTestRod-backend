import { Router } from 'express'
import { taskPruebe } from '../controllers/index.controller.js'

const router = Router()

router.get('/taskPruebe', taskPruebe)

export default router