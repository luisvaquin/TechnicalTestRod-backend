import { Router } from 'express'
import { getTasks, getTask, postTasks, putTasks, deleteTasks, patchTasks } from '../controllers/tasks.controller.js'

const router = Router()

router.get('/task', getTasks)
router.get('/task/:id', getTask)
router.post('/task', postTasks)
router.put('/task/:id', putTasks)
router.patch('/task/:id', patchTasks)
router.delete('/task/:id', deleteTasks)


export default router