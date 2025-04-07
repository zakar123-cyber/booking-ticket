-- Create Stations table with additional attributes (e.g., parking, wifi)
CREATE TABLE Stations (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    station_name VARCHAR(255) NOT NULL,
    has_parking BOOLEAN DEFAULT FALSE,
    has_wifi BOOLEAN DEFAULT FALSE
);

-- Create Trains table with train status
CREATE TABLE Trains (
    train_id INT AUTO_INCREMENT PRIMARY KEY,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    train_name VARCHAR(255) NOT NULL,
    train_type VARCHAR(100),
    status VARCHAR(50) DEFAULT 'Operating'
);

-- Create Routes table with improvements
CREATE TABLE Routes (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    train_id INT NOT NULL,
    starting_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    route_type VARCHAR(50) DEFAULT 'One-way', -- e.g., One-way or Round-trip
    FOREIGN KEY (train_id) REFERENCES Trains(train_id),
    FOREIGN KEY (starting_station_id) REFERENCES Stations(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES Stations(station_id)
);

-- Create Clients table
CREATE TABLE Clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique client identifier
    first_name VARCHAR(100) NOT NULL,           -- Client's first name
    last_name VARCHAR(100) NOT NULL,            -- Client's last name
    email VARCHAR(255) UNIQUE NOT NULL,         -- Client's email (must be unique)
    phone_number VARCHAR(15),                   -- Client's phone number
    date_of_birth DATE,                         -- Client's date of birth
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- Timestamp of when the client was added
);

-- Create Bookings table to track reservations
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique booking identifier
    client_id INT NOT NULL,                     -- Reference to the client who made the booking
    train_id INT NOT NULL,                      -- Reference to the train the client has booked
    seat_number VARCHAR(10),                    -- Seat number assigned to the client
    booking_date DATETIME NOT NULL,             -- Date and time when the booking was made
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),  -- Foreign key to Clients table
    FOREIGN KEY (train_id) REFERENCES Trains(train_id)      -- Foreign key to Trains table
);

-- Create Payments table to track payment status
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique payment identifier
    booking_id INT NOT NULL,                    -- Reference to the booking
    payment_amount DECIMAL(10, 2) NOT NULL,     -- The amount paid by the client
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- Date and time of the payment
    payment_status VARCHAR(50) DEFAULT 'Pending', -- Payment status: Pending, Completed, Failed
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) -- Foreign key to Bookings table
);

-- Sample Inserts for Stations
INSERT INTO Stations (station_name, has_parking, has_wifi) VALUES
('Casablanca', TRUE, TRUE),
('Marrakesh', TRUE, FALSE),
('Rabat', TRUE, TRUE);

-- Sample Inserts for Trains
INSERT INTO Trains (departure_time, arrival_time, train_name, train_type) VALUES
('2025-04-07 08:00:00', '2025-04-07 10:30:00', 'Train A Casablanca - Marrakesh', 'Express');

-- Sample Inserts for Routes
INSERT INTO Routes (train_id, starting_station_id, destination_station_id, route_type) VALUES
(1, (SELECT station_id FROM Stations WHERE station_name = 'Casablanca'), 
    (SELECT station_id FROM Stations WHERE station_name = 'Marrakesh'), 'One-way');

-- Sample Inserts for Clients
INSERT INTO Clients (first_name, last_name, email, phone_number, date_of_birth) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', '1985-01-15'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321', '1990-05-25');

-- Sample Inserts for Bookings
INSERT INTO Bookings (client_id, train_id, seat_number, booking_date) VALUES
(1, 1, 'A1', '2025-04-05 10:00:00'),  -- Client 1 (John) books Train 1
(2, 1, 'A2', '2025-04-06 11:00:00');  -- Client 2 (Jane) books Train 1

-- Sample Inserts for Payments
INSERT INTO Payments (booking_id, payment_amount, payment_date, payment_status) VALUES
(1, 50.00, '2025-04-05 10:30:00', 'Completed'),  -- Payment for Client 1 (John)
(2, 60.00, '2025-04-06 11:30:00', 'Pending');     -- Payment for Client 2 (Jane)

-- Query to view all bookings with payment status
SELECT 
    c.first_name, 
    c.last_name, 
    t.train_name, 
    b.seat_number, 
    b.booking_date, 
    p.payment_status
FROM Bookings b
JOIN Clients c ON b.client_id = c.client_id
JOIN Trains t ON b.train_id = t.train_id
JOIN Payments p ON b.booking_id = p.booking_id;

-- Query to view payment status for a specific client (e.g., Client 1)
SELECT 
    c.first_name, 
    c.last_name, 
    t.train_name, 
    b.seat_number, 
    p.payment_amount, 
    p.payment_status
FROM Payments p
JOIN Bookings b ON p.booking_id = b.booking_id
JOIN Clients c ON b.client_id = c.client_id
JOIN Trains t ON b.train_id = t.train_id
WHERE c.client_id = 1;  -- View bookings and payments for Client 1 (John)
