import { pool } from "../services/db/db.js";

export const postLogin = async (req, res) => {
    const { userLog, passLog, codLog } = req.body;

    try {
        console.log('Credenciales recibidas:', { userLog, passLog, codLog });

        const [rows] = await pool.query(
            'SELECT id FROM UserLogin WHERE userLog = ? AND passLog = ? AND codLog = ?',
            [userLog, passLog, codLog]
        );

        if (rows.length > 0) {
            // Guardar userId en la sesión
            req.session.userId = rows[0].id;
            res.status(200).json({ message: 'Inicio de sesión', Bienvenido: userLog, userId: rows[0].id });
            console.log('Logeado correctamente');
        } else {
            console.log('Credenciales no válidas para:', { userLog, passLog, codLog });
            res.status(401).json({ message: 'Credenciales incorrectas' });
        }
    } catch (error) {
        console.error('Error en la consulta:', error);
        res.status(500).json({ message: 'Error en el servidor' });
    }
};
