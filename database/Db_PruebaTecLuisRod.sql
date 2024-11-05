USE basedezzzdfqwbciu6dn;

-- Tabla de usuarios para el inicio de sesión
CREATE TABLE IF NOT EXISTS UserLogin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codLog INT(10) NOT NULL,
    userLog VARCHAR(10) NOT NULL,  -- Aumentado a 20 caracteres
    passLog VARCHAR(10) NOT NULL  -- Aumentado a 20 caracteres
);

ALTER TABLE UserLogin MODIFY userLog VARCHAR(20);
ALTER TABLE UserLogin MODIFY passLog VARCHAR(20);

-- Agregar datos estáticos para el Login
INSERT INTO UserLogin (userLog, passLog, codLog)
VALUES ('bi', 'admin', 87654321);

select * from UserLogin;

-- Tabla para la información de las cuentas de los usuarios
CREATE TABLE IF NOT EXISTS Accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    balance DECIMAL(18, 2) DEFAULT 0.00,
    currency CHAR(3) CHECK (currency IN ('GTQ', 'USD')) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES UserLogin(id)  -- Cambiado a UserLogin
);

-- Tabla de tasas de cambio
CREATE TABLE IF NOT EXISTS ExchangeRates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    from_currency CHAR(3) NOT NULL,
    to_currency CHAR(3) NOT NULL,
    rate DECIMAL(10, 4) NOT NULL,
    effective_date DATE NOT NULL
);

-- Tabla para almacenar transferencias entre cuentas
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    from_account_id INT NOT NULL,
    to_account_id INT NOT NULL,
    amount DECIMAL(18, 2) NOT NULL,
    currency CHAR(3) CHECK (currency IN ('GTQ', 'USD')) NOT NULL,
    equivalent_amount DECIMAL(18, 2), -- Monto equivalente en la moneda de destino si aplica
    exchange_rate DECIMAL(10, 4), -- Tasa de cambio usada si aplica
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comment VARCHAR(600),
    status ENUM('PENDING', 'COMPLETED', 'FAILED') DEFAULT 'PENDING',
    FOREIGN KEY (from_account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (to_account_id) REFERENCES Accounts(account_id)
);

-- Verificar que la base de datos se ha creado
SHOW DATABASES;
-- drop database Bi_pruebaTecLuisRod;