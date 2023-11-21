-- Crear tabla Vehicle
CREATE TABLE Vehicle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license_plate VARCHAR(20) NOT NULL,
    vehicle_type ENUM('car', 'motorcycle') NOT NULL
);

-- Crear tabla TariffType
CREATE TABLE tariff_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    rate FLOAT NOT NULL
);

-- Crear tabla Transaction
CREATE TABLE Transaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    entry_time DATETIME NOT NULL,
    exit_time DATETIME,
    tariff_id INT,
    total_amount FLOAT,
    status VARCHAR(20) DEFAULT 'PENDING',
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id),
    FOREIGN KEY (tariff_id) REFERENCES tariff_type(id)
);