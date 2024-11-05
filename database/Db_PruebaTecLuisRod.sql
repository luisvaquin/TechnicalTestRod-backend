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

-- Agregar cuentas estáticas para el usuario 'Luis'
INSERT INTO Accounts (user_id, account_number, balance, currency)
VALUES (1, 'ACCT001', 1500.00, 'GTQ'),
       (1, 'ACCT002', 200.00, 'USD');
       
INSERT INTO Accounts (user_id, account_number, balance, currency)
VALUES (2, 'ACCT003', 15500.00, 'GTQ');
 
select * from Accounts AS Cuentas;
       
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

select * from Transactions;

-- --------Procedimiento almacenado para transferencias------
-- DROP PROCEDURE IF EXISTS TransferFunds;

DELIMITER //

CREATE PROCEDURE TransferFunds(
    IN from_user_id INT,
    IN to_user_id INT,
    IN transfer_amount DECIMAL(18, 2),
    IN comment VARCHAR(600)
)
BEGIN
    DECLARE from_account_id INT;
    DECLARE to_account_id INT;
    DECLARE from_balance DECIMAL(18, 2);
    DECLARE from_currency CHAR(3);
    DECLARE to_currency CHAR(3);
    DECLARE exchange_rate DECIMAL(10, 4);
    DECLARE equivalent_amount DECIMAL(18, 2);

    -- Iniciar una transacción
    START TRANSACTION;

    -- Obtener el ID de la cuenta de origen, el saldo y la moneda (solo cuentas activas)
    SELECT account_id, balance, currency INTO from_account_id, from_balance, from_currency
    FROM Accounts
    WHERE user_id = from_user_id AND active = TRUE
    LIMIT 1;

    -- Verificar si se encontró la cuenta de origen
    IF from_account_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró la cuenta de origen activa para el usuario especificado.';
    END IF;

    -- Obtener el ID de la cuenta de destino (solo cuentas activas)
    SELECT account_id, currency INTO to_account_id, to_currency
    FROM Accounts
    WHERE user_id = to_user_id AND active = TRUE
    LIMIT 1;

    -- Verificar si se encontró la cuenta de destino
    IF to_account_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró la cuenta de destino activa para el usuario especificado.';
    END IF;

    -- Verificar si las cuentas son de la misma moneda
    IF from_currency = to_currency THEN
        -- La transferencia es entre cuentas de la misma moneda
        IF from_balance >= transfer_amount THEN
            -- Registrar la transferencia en la tabla Transactions
            INSERT INTO Transactions (from_account_id, to_account_id, amount, currency, equivalent_amount, status, comment)
            VALUES (from_account_id, to_account_id, transfer_amount, from_currency, transfer_amount, 'COMPLETED', comment);

            -- Actualizar el saldo de la cuenta de origen restando el monto transferido
            UPDATE Accounts
            SET balance = balance - transfer_amount
            WHERE account_id = from_account_id;

            -- Actualizar el saldo de la cuenta de destino sumando el monto recibido
            UPDATE Accounts
            SET balance = balance + transfer_amount
            WHERE account_id = to_account_id;

        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Fondos insuficientes en la cuenta de origen.';
        END IF;

    ELSEIF from_currency = 'GTQ' AND to_currency = 'USD' THEN
        -- La transferencia es de GTQ a USD
        -- Obtener la tasa de cambio
        SELECT rate INTO exchange_rate
        FROM ExchangeRates
        WHERE from_currency = 'GTQ' AND to_currency = 'USD'
        LIMIT 1;

        -- Calcular el monto equivalente en USD
        SET equivalent_amount = transfer_amount * exchange_rate;

        IF from_balance >= transfer_amount THEN
            -- Registrar la transferencia en la tabla Transactions
            INSERT INTO Transactions (from_account_id, to_account_id, amount, currency, equivalent_amount, status, comment)
            VALUES (from_account_id, to_account_id, transfer_amount, from_currency, equivalent_amount, 'COMPLETED', comment);

            -- Actualizar el saldo de la cuenta de origen restando el monto transferido
            UPDATE Accounts
            SET balance = balance - transfer_amount
            WHERE account_id = from_account_id;

            -- Actualizar el saldo de la cuenta de destino sumando el monto equivalente recibido
            UPDATE Accounts
            SET balance = balance + equivalent_amount
            WHERE account_id = to_account_id;

        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Fondos insuficientes en la cuenta de origen.';
        END IF;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transferencias solo permitidas entre cuentas de la misma moneda o de GTQ a USD.';
    END IF;

    -- Confirmar la transacción
    COMMIT;

END //

DELIMITER ;

CALL TransferFunds(2, 1, 10.00, 'Transferencia de Rodri a Luis');

SELECT * FROM Accounts;



