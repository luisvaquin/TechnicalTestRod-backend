USE btfafq7bks6gsbiwytmn;

show databases;
-- Tabla de usuarios para el inicio de sesión
CREATE TABLE IF NOT EXISTS UserLogin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codLog INT(10) NOT NULL,
    userLog VARCHAR(20) NOT NULL,  -- Aumentado a 20 caracteres
    passLog VARCHAR(20) NOT NULL  -- Aumentado a 20 caracteres
);

-- Agregar datos estáticos para el Login
INSERT INTO UserLogin (userLog, passLog, codLog)
	VALUES ('Luis', 'admin', 87654321);
    
INSERT INTO UserLogin (userLog, passLog, codLog)
	VALUES ('Rodri', 'rodri', 12345678);
    
INSERT INTO UserLogin (userLog, passLog, codLog)
	VALUES ('Pablo', 'pablo', 36987451);


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

-- Agregar cuentas estáticas para el usuario 'Luis'
INSERT INTO Accounts (user_id, account_number, balance, currency)
VALUES (1, 'ACCT001', 1500.00, 'GTQ'),
       (1, 'ACCT002', 200.00, 'USD');

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


-- -------------------FUNCION TRANSFERS PL/SQL-----------------
