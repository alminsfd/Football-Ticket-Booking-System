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