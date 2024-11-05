import { config } from "dotenv";
config();

export const PORT = process.env.PORT || 3000
export const DB_HOST = process.env.DB_HOST || 'basedezzzdfqwbciu6dn-mysql.services.clever-cloud.com'
export const DB_USER = process.env.DB_USER || 'u5xy7eorwnmv6pnr'
export const DB_PASSWORD = process.env.DB_PASSWORD || 'Vm3lRTw6CaQG3mixTAxF'
export const DB_DATABASE = process.env.DB_DATABASE || 'basedezzzdfqwbciu6dn'
export const DB_PORT = process.env.DB_PORT || 3306