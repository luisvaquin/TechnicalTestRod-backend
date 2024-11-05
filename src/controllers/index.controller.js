import { pool } from '../services/db/db.js'
export const taskPruebe = async (req, res) => {
    const [resultQuery] = await pool.query('SELECT 1+5 AS RESULT')
    res.json(resultQuery)
}