import { pool } from "../services/db/db.js";

export const postLogin = async (req, res) => {
    const { userLog, passLog, codLog } = req.body;

    try {
        // Imprimir las credenciales recibidas para depuración
        console.log('Credenciales recibidas:', { userLog, passLog, codLog });

        // Consulta a la base de datos para verificar las credenciales
        const [rows] = await pool.query(
            'SELECT id FROM UserLogin WHERE userLog = ? AND passLog = ? AND codLog = ?',
            [userLog, passLog, codLog]
        );

        // Verificar si se encontró un usuario
        if (rows.length > 0) {
            res.status(200).json({ message: 'Login exitoso', userId: rows[0].id });
            console.log('Logeado correctamente')
        } else {
            // Si no se encontró el usuario, enviar un mensaje de error
            console.log('Credenciales no válidas para:', { userLog, passLog, codLog });
            res.status(401).json({ message: 'Credenciales incorrectas' });
        }
    } catch (error) {
        console.error('Error en la consulta:', error);
        res.status(500).json({ message: 'Error and server' });
    }
};
