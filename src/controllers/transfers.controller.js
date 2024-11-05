import { pool } from "../services/db/db.js";

export const postTransfers = async (req, res) => {
    const { from_user_id, to_user_id, transfer_amount, comment } = req.body;

    try {
        if (!from_user_id || !to_user_id || !transfer_amount) {
            return res.status(400).json({ message: 'Faltan datos necesarios para la transferencia.' });
        }

        const query = `CALL TransferFunds(?, ?, ?, ?)`;

        const [results] = await pool.query(query, [from_user_id, to_user_id, transfer_amount, comment]);

        res.status(200).json({ message: 'Transferencia realizada con éxito' });
    } catch (error) {
        console.error('Error en la transferencia:', error);
        res.status(500).json({ message: 'Error en la transferencia', error: error.message });
    }
}

export const getTransfers = async (req, res) => {
    const [rows] = await pool.query('SELECT * FROM Transactions')
    res.send(rows)
    console.log('resgistros de transferencias', rows)
}