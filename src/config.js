import { config } from "dotenv";
config();

export const PORT = process.env.PORT || 3000
export const DB_HOST = process.env.DB_HOST || 'btfafq7bks6gsbiwytmn-mysql.services.clever-cloud.com'
export const DB_USER = process.env.DB_USER || 'umxtdl6g8xjohzkb'
export const DB_PASSWORD = process.env.DB_PASSWORD || 'iZE8IugNocLke73b4hB3'
export const DB_DATABASE = process.env.DB_DATABASE || 'btfafq7bks6gsbiwytmn'
export const DB_PORT = process.env.DB_PORT || 3306