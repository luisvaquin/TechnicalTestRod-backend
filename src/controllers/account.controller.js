import { pool } from "../services/db/db.js";

// controllers/account.controller.js

export const isAuthenticated = (req, res, next) => {
    const userId = req.session.userId; // Asegúrate de que el userId esté en la sesión

    if (!userId) {
        return res.status(401).json({ message: 'No estás autenticado' });
    }

    // Si el usuario está autenticado, continuamos con la siguiente ruta
    next();
};

export const getAccount = async (req, res) => {
    const [rows] = await pool.query('SELECT * FROM Accounts AS Cuentas');
    res.send(rows);
};

export const getInfAccounts = async (req, res) => {
    try {
        const userId = req.session.userId;

        const [rows] = await pool.query(
            'SELECT UL.id AS user_id, UL.userLog, A.account_id, A.account_number, A.balance, A.currency ' +
            'FROM UserLogin UL ' +
            'JOIN Accounts A ON UL.id = A.user_id ' +
            'WHERE UL.id = ?',
            [userId]
        );

        res.json(rows);
    } catch (error) {
        console.error('Error fetching account info:', error);
        res.status(500).json({ error: 'Error en el servidor' });
    }
};
