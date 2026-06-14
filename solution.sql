-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE IF NOT EXISTS Users (
  user_id serial,
  full_name varchar(255) NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  role varchar(20) DEFAULT 'Football Fan',
  phone_number varchar(20) NOT NULL,
  -- Write your constraint to make 'user_id' the Primary Key
  CONSTRAINT pk_users PRIMARY KEY (user_id),
  -- Write your constraint to ensure 'email' values are never duplicated
  CONSTRAINT uq_users_email UNIQUE (email),
  -- Write your check constraint to restrict 'role' to specific allowed strings
  CONSTRAINT chk_users_role CHECK (role IN ('Ticket Manager', 'Football Fan'))
);


-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE IF NOT EXISTS Matches (
  match_id serial,
  fixture varchar(255) NOT NULL,
  tournament_category varchar(100) NOT NULL,
  base_ticket_price int NOT NULL,
  match_status varchar(15) DEFAULT 'Available',
  -- Write your constraint to make 'match_id' the Primary Key
  CONSTRAINT pk_matches PRIMARY KEY (match_id),
  -- Write your check constraint to prevent negative ticket prices
  CONSTRAINT chk_matches_price CHECK (base_ticket_price >= 0),
  -- Write your check constraint to restrict 'match_status' values
  CONSTRAINT chk_matches_status CHECK (
    match_status IN (
      'Available',
      'Selling Fast',
      'Sold Out',
      'Postponed'
    )
  )
);


-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE IF NOT EXISTS Bookings (
  booking_id serial,
  user_id int NOT NULL,
  match_id int NOT NULL,
  seat_number varchar(10) NOT NULL,
  payment_status varchar(10) DEFAULT 'Pending',
  total_cost int NOT NULL,
  -- Write your constraint to make 'booking_id' the Primary Key
  CONSTRAINT pk_bookings PRIMARY KEY (booking_id),
  -- Write your Foreign Key constraint linking 'user_id' to the Users table
  CONSTRAINT fk_bookings_user_id FOREIGN key (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
  -- Write your Foreign Key constraint linking 'match_id' to the Matches table
  CONSTRAINT fk_bookings_match_id FOREIGN key (match_id) REFERENCES Matches (match_id) ON DELETE CASCADE,
  -- Write your check constraint to restrict 'payment_status' values
  CONSTRAINT chk_bookings_pay_status CHECK (
    payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
  ),
  -- Write your check constraint to ensure 'total_cost' is non-negative
  CONSTRAINT chk_bookings_total_cost CHECK (total_cost >= 0)
);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
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


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
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
    150.00,
    'Available'
  ),
  (
    102,
    'Man City vs Liverpool',
    'Premier League',
    120.00,
    'Selling Fast'
  ),
  (
    103,
    'Bayern Munich vs PSG',
    'Champions League',
    130.00,
    'Available'
  ),
  (
    104,
    'AC Milan vs Inter Milan',
    'Serie A',
    90.00,
    'Sold Out'
  ),
  (
    105,
    'Juventus vs Roma',
    'Serie A',
    80.00,
    'Available'
  );


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
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
  (501, 1, 101, 'A-12', 'Confirmed', 150.00),
  (502, 1, 102, 'B-04', 'Confirmed', 120.00),
  (503, 2, 101, 'A-13', 'Confirmed', 150.00),
  (504, 2, 101, NULL, NULL, 150.00),
  (505, 3, 102, 'C-20', 'Pending', 120.00);


-- =========================================================================
-- Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.
-- =========================================================================
SELECT
  match_id,
  fixture,
  base_ticket_price
FROM
  matches
WHERE
  tournament_category = 'Champions League'
  AND match_status = 'Available';