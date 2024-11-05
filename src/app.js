import express from 'express';
import cors from 'cors'; // Importa el paquete CORS

import taskRoutes from './routes/tasks.routes.js';
import indexRoutes from './routes/index.routes.js';
import loginRoutes from './routes/loginUsesr.routes.js';
import transferRoutes from './routes/transfers.routes.js';
import accountRoutes from './routes/account.routes.js';

const app = express();

// Configura CORS para permitir solicitudes desde el frontend
app.use(cors({
    origin: 'http://localhost:5173', // Permite solicitudes desde localhost:5173
}));

app.use(express.json()); // Middleware para parsear JSON

// Inicialización de rutas
app.use('/api', indexRoutes);
app.use('/api', loginRoutes);
app.use('/api', accountRoutes);
app.use('/api', transferRoutes);
app.use('/api', taskRoutes);

// Middleware para manejar rutas no encontradas
app.use((req, res, next) => {
    res.status(404).json({
        message: 'ROUTE NOT FOUND'
    });
});

export default app;