
-- Football Ticket Booking System - Database Design & SQL Queries

-- SCHEMA CREATION

DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

--- users table

CREATE TABLE Users (
    user_id      SERIAL PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(150) UNIQUE NOT NULL,
    role         VARCHAR(20) NOT NULL CHECK (role IN ('Ticket Manager', 'Football Fan')),
    phone_number VARCHAR(20)
);

 --- matches table
CREATE TABLE Matches (
    match_id            SERIAL PRIMARY KEY,
    fixture             VARCHAR(150) NOT NULL,
    tournament_category VARCHAR(100) NOT NULL,
    base_ticket_price   NUMERIC(10, 2) NOT NULL,
    match_status        VARCHAR(20) NOT NULL, 
    
    CONSTRAINT chk_positive_price CHECK (base_ticket_price >= 0),
    CONSTRAINT chk_match_status CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);