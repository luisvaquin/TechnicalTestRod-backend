import { pool } from "../services/db/db.js";

export const getAccount = async (req, res) => {
    const [rows] = await pool.query('select * from Accounts AS Cuentas')
    res.send(rows)
}