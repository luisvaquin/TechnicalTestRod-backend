import express from 'express'
import taskRoutes from './routes/tasks.routes.js'
import indexRoutes from './routes/index.routes.js'
import loginRoutes from './routes/loginUsesr.routes.js'

const app = express()

app.use(express.json()) //Fuction express y factorizar objetos tipo JSON


//Inicializacion de routes
app.use('/api', indexRoutes)
app.use('/api', loginRoutes)
app.use('/api', taskRoutes)

app.use((req, res, next) => {
    res.status(404).json({
        message: 'ROUTE NOT FOUND'
    })
})

export default app