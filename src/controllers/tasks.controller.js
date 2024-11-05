import { pool } from '../services/db/db.js'

//Get Tareas
export const getTasks = async (req, res) => {
    //Obtener consulta por medio de columnas
    const [rows] = await pool.query('SELECT * FROM CrudTask')
    res.send(rows)
}

//Get Tarea por ID
export const getTask = async (req, res) => {
    const [rows] = await pool.query('SELECT * FROM CrudTask WHERE idTask = ?',
        [req.params.id])

    //Manejar error al no existir registros
    if (rows.length <= 0) return res.status(404).json({
        message: "No existe algun registro con ese id"
    })
    res.json(rows[0])
}

//Post Tareas
export const postTasks = async (req, res) => {
    //Destructurar cuerpo de body
    const { nameTask, descriptionTask, dateTask } = req.body

    //Pasar objetos en arreglor de la consulta
    //Rows: guardando consulta en arreglo y row devuelve solo filas
    const [rows] = await pool.query('INSERT INTO CrudTask (nameTask, descriptionTask, dateTask) VALUES (?,?,?)',
        [nameTask, descriptionTask, dateTask])
    //Obtener objetos de arreglo
    res.send({
        id: rows.insertId,
        nameTask,
        descriptionTask,
        dateTask
    })
}

//Update affectedRows 
export const putTasks = async (req, res) => {

    const { id } = req.params
    const { nameTask, descriptionTask, dateTask } = req.body

    const updateData = await pool.query('UPDATE CrudTask SET nameTask = ?, descriptionTask = ?, dateTask = ? WHERE idTask = ?',
        [nameTask, descriptionTask, dateTask, /*ID
            que se extrajo como parametro de ROUTER*/ id]
    )

    if (updateData.affectedRows === 0) return res.status(404).json({
        message: 'No existe tarea para editar'
    })

    const [rows] = await pool.query('SELECT * FROM CrudTask WHERE idTask = ?', [id])

    console.log(updateData)
    res.send(rows[0])
}


//Add Update and function PATCH-Actualiza parcialmente 
//Control de nulls en parametros para actualizar
export const patchTasks = async (req, res) => {

    const { id } = req.params
    const { nameTask, descriptionTask, dateTask } = req.body

    const [updateData] = await pool.query('UPDATE CrudTask SET nameTask = IFNULL(?, nameTask), descriptionTask = IFNULL(?, descriptionTask), dateTask = IFNULL(?, dateTask) WHERE idTask = ?',
        [nameTask, descriptionTask, dateTask, /*ID
            que se extrajo como parametro de ROUTER*/ id]
    )

    console.log(updateData)

    if (updateData.affectedRows === 0) return res.status(404).json({
        message: 'No existe tarea para editar'
    })

    const [rows] = await pool.query('SELECT * FROM CrudTask WHERE idTask = ?', [id])
    res.send(rows[0])

}


//Eliminar registro
export const deleteTasks = async (req, res) => {
    const [resDelete] = await pool.query('DELETE FROM CrudTask WHERE idTask = ?', [req.params.id])
    console.log(resDelete)
    if (resDelete.affectedRows <= 0) return res.status(404).json({
        message: "No existe ese registro para eliminarlo"
    })
    res.sendStatus(204)
}
