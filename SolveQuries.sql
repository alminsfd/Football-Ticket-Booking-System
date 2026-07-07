-- Football Ticket Booking System - Database Design & SQL Queries
-- SCHEMA CREATION
DROP TABLE IF EXISTS Bookings;

DROP TABLE IF EXISTS Matches;

DROP TABLE IF EXISTS Users;

--- users table
CREATE TABLE Users (
     user_id SERIAL PRIMARY KEY,
     full_name VARCHAR(100) NOT NULL,
     email VARCHAR(150) UNIQUE NOT NULL,
     role VARCHAR(20) NOT NULL CHECK (role IN ('Ticket Manager', 'Football Fan')),
     phone_number VARCHAR(20)
);

--- matches table
CREATE TABLE Matches (
     match_id SERIAL PRIMARY KEY,
     fixture VARCHAR(150) NOT NULL,
     tournament_category VARCHAR(100) NOT NULL,
     base_ticket_price NUMERIC(10, 2) NOT NULL,
     match_status VARCHAR(20) NOT NULL,
     CONSTRAINT chk_positive_price CHECK (base_ticket_price >= 0),
     CONSTRAINT chk_match_status CHECK (
          match_status IN (
               'Available',
               'Selling Fast',
               'Sold Out',
               'Postponed'
          )
     )
);

--- bookings table
CREATE TABLE Bookings (
     booking_id SERIAL PRIMARY KEY,
     user_id INT NOT NULL REFERENCES Users(user_id),
     match_id INT NOT NULL REFERENCES Matches(match_id),
     seat_number VARCHAR(10),
     payment_status VARCHAR(20),
     total_cost NUMERIC(10, 2) NOT NULL,
     CONSTRAINT chk_payment_status CHECK (
          payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
     ),
     CONSTRAINT chk_positive_cost CHECK (total_cost >= 0)
);

-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
INSERT INTO
     Users (user_id, full_name, email, role, phone_number)
VALUES
     (
          1,
          'Tanvir Rahman',
          'tanvir@mail.com',
          'Football Fan',
          '+8801711111111'
     ),
     (
          2,
          'Asif Haque',
          'asif@mail.com',
          'Football Fan',
          '+8801722222222'
     ),
     (
          3,
          'Sajjad Rahman',
          'sajjad@mail.com',
          'Ticket Manager',
          '+8801733333333'
     ),
     (
          4,
          'Jannat Ara',
          'jannat@mail.com',
          'Football Fan',
          NULL
     );

-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
INSERT INTO
     Matches (
          match_id,
          fixture,
          tournament_category,
          base_ticket_price,
          match_status
     )
VALUES
     (
          101,
          'Real Madrid vs Barcelona',
          'Champions League',
          150,
          'Available'
     ),
     (
          102,
          'Man City vs Liverpool',
          'Premier League',
          120,
          'Selling Fast'
     ),
     (
          103,
          'Bayern Munich vs PSG',
          'Champions League',
          130,
          'Available'
     ),
     (
          104,
          'AC Milan vs Inter Milan',
          'Serie A',
          90,
          'Sold Out'
     ),
     (
          105,
          'Juventus vs Roma',
          'Serie A',
          80,
          'Available'
     );

-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
INSERT INTO
     Bookings (
          booking_id,
          user_id,
          match_id,
          seat_number,
          payment_status,
          total_cost
     )
VALUES
     (501, 1, 101, 'A-12', 'Confirmed', 150),
     (502, 1, 102, 'B-04', 'Confirmed', 120),
     (503, 2, 101, 'A-13', 'Confirmed', 150),
     (504, 2, 101, NULL, NULL, 150),
     (505, 3, 102, 'C-20', 'Pending', 120);

-- QUERY 1: Available Champions League matches
SELECT
     match_id,
     fixture,
     base_ticket_price
FROM
     Matches
WHERE
     tournament_category = 'Champions League'
     AND match_status = 'Available';

-- QUERY 2: Users whose name starts with 'Tanvir' OR contains 'Haque'
SELECT
     user_id,
     full_name,
     email
FROM
     Users
WHERE
     full_name ILIKE 'Tanvir%'
     OR full_name ILIKE '%Haque%';

-- QUERY 3: Bookings with missing payment_status 
SELECT
     booking_id,
     user_id,
     match_id,
     COALESCE(payment_status, 'Action Required') AS systematic_status
FROM
     Bookings
WHERE
     payment_status IS NULL;

-- QUERY 4: Booking details with user 's name and match fixture
SELECT
     b.booking_id,
     u.full_name,
     m.fixture,
     b.total_cost
FROM
     Bookings b
     INNER JOIN Users u ON b.user_id = u.user_id
     INNER JOIN Matches m ON b.match_id = m.match_id
ORDER BY
     b.booking_id;

-- QUERY 5: All users and their bookings (fans with no booking included)
SELECT
     u.user_id,
     u.full_name,
     b.booking_id
FROM
     Users u
     LEFT JOIN Bookings b ON u.user_id = b.user_id
ORDER BY
     u.user_id;

-- QUERY 6: Bookings costing more than the average booking cost
SELECT
     booking_id,
     match_id,
     total_cost
FROM
     Bookings
WHERE
     total_cost > (
          SELECT
               AVG(total_cost)
          FROM
               Bookings
     )
ORDER BY
     total_cost DESC;

--- QUERY 7 : Top 2 most expensive matches,skipping the highest one
SELECT
     match_id,
     fixture,
     base_ticket_price
FROM
     Matches
ORDER BY
     base_ticket_price DESC
LIMIT
     2 OFFSET 1;