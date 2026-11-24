CREATE DATABASE ride_sharing_project;

USE ride_sharing_project;

-- 1. Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(255),
    phone_number VARCHAR(20),
    registration_date DATETIME,
    age INT,
    gender VARCHAR(20),
    location VARCHAR(100)
);

-- 2. Vehicles table
CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY,
    make VARCHAR(100),
    model VARCHAR(100),
    `year` SMALLINT,
    capacity INT
);

-- 3. Drivers table
CREATE TABLE drivers (
    driver_id INT PRIMARY KEY,
    name VARCHAR(100),
    vehicle_id INT,
    rating DECIMAL(3,2),
    total_rides INT,
    available BOOLEAN,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- 4. Rides table
CREATE TABLE rides (
    ride_id INT PRIMARY KEY,
    user_id INT,
    start_location VARCHAR(100),
    end_location VARCHAR(100),
    ride_start_time DATETIME,
    ride_end_time DATETIME,
    distance_km DECIMAL(10,2),
    fare_amount DECIMAL(10,2),
    driver_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

-- 5. Ratings table
CREATE TABLE ratings (
    rating_id INT PRIMARY KEY,
    ride_id INT,
    user_id INT,
    rating_value INT,
    comments TEXT,
    rating_date DATETIME,
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

SHOW TABLES;

USE ride_sharing_project;

-- Check imported row counts
SELECT 'users' AS table_name, COUNT(*) AS total FROM users
UNION ALL
SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL
SELECT 'drivers', COUNT(*) FROM drivers
UNION ALL
SELECT 'rides', COUNT(*) FROM rides;


-- Check missing user references
SELECT COUNT(*) AS missing_user_ids
FROM rides r
LEFT JOIN users u ON r.user_id = u.user_id
WHERE u.user_id IS NULL;

-- Check missing driver references
SELECT COUNT(*) AS missing_driver_ids
FROM rides r
LEFT JOIN drivers d ON r.driver_id = d.driver_id
WHERE d.driver_id IS NULL;

USE ride_sharing_project;

-- Check imported row counts
SELECT 'users' AS table_name, COUNT(*) AS total FROM users
UNION ALL
SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL
SELECT 'drivers', COUNT(*) FROM drivers
UNION ALL
SELECT 'rides', COUNT(*) FROM rides;

-- Check missing user IDs
SELECT COUNT(*) AS missing_user_ids
FROM rides r
LEFT JOIN users u ON r.user_id = u.user_id
WHERE u.user_id IS NULL;

-- Check missing driver IDs
SELECT COUNT(*) AS missing_driver_ids
FROM rides r
LEFT JOIN drivers d ON r.driver_id = d.driver_id
WHERE d.driver_id IS NULL;

USE ride_sharing_project;

SELECT COUNT(*) AS total_drivers FROM drivers;

SELECT COUNT(*) AS total_rides FROM rides;

SELECT COUNT(*) AS missing_user_ids
FROM rides r
LEFT JOIN users u ON r.user_id = u.user_id
WHERE u.user_id IS NULL;

USE ride_sharing_project;

SELECT
    (SELECT COUNT(*) FROM users) AS total_users,
    (SELECT COUNT(*) FROM drivers) AS total_drivers,
    (SELECT COUNT(*) FROM rides) AS total_rides,
    (SELECT COUNT(*) FROM vehicles) AS total_vehicles;
    
    
SHOW CREATE TABLE drivers;
SELECT COUNT(*) FROM drivers;
USE ride_sharing_project;

DELETE FROM users;
USE ride_sharing_project;

DELETE FROM users
WHERE user_id > 0;

USE ride_sharing_project;

SELECT 'users' AS table_name, COUNT(*) AS total FROM users
UNION ALL
SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL
SELECT 'drivers', COUNT(*) FROM drivers
UNION ALL
SELECT 'rides', COUNT(*) FROM rides
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings;

USE ride_sharing_project;

-- Clear dependent records first
DELETE FROM ratings
WHERE rating_id > 0;

DELETE FROM rides
WHERE ride_id > 0;

-- Now clear incomplete users
DELETE FROM users
WHERE user_id > 0;

SELECT COUNT(*) FROM users;

DELETE FROM users
WHERE user_id > 0;

USE ride_sharing_project;

ALTER TABLE users
MODIFY COLUMN phone_number VARCHAR(50);

DELETE FROM users
WHERE user_id > 0;

SELECT COUNT(*) FROM users;

USE ride_sharing_project;

SELECT 'users' AS table_name, COUNT(*) AS total FROM users
UNION ALL
SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL
SELECT 'drivers', COUNT(*) FROM drivers
UNION ALL
SELECT 'rides', COUNT(*) FROM rides;

SELECT COUNT(*) FROM rides;

USE ride_sharing_project;

SELECT 'users' AS table_name, COUNT(*) AS total FROM users
UNION ALL
SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL
SELECT 'drivers', COUNT(*) FROM drivers
UNION ALL
SELECT 'rides', COUNT(*) FROM rides
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings;

USE ride_sharing_project;

-- 1. Total number of rides
SELECT COUNT(*) AS total_rides
FROM rides;

-- 2. Total revenue
SELECT ROUND(SUM(fare_amount), 2) AS total_revenue
FROM rides;

-- 3. Average fare
SELECT ROUND(AVG(fare_amount), 2) AS average_fare
FROM rides;

-- 4. Average trip distance
SELECT ROUND(AVG(distance_km), 2) AS average_distance
FROM rides;

-- 5. Total users
SELECT COUNT(*) AS total_users
FROM users;

-- 6. Total drivers
SELECT COUNT(*) AS total_drivers
FROM drivers;

-- 7. Average customer rating
SELECT ROUND(AVG(rating_value), 2) AS average_customer_rating
FROM ratings;

-- 8. Total vehicles
SELECT COUNT(*) AS total_vehicles
FROM vehicles;

-- 9. Top 10 pickup locations
SELECT
    start_location,
    COUNT(*) AS total_rides
FROM rides
GROUP BY start_location
ORDER BY total_rides DESC
LIMIT 10;

-- 10. Top 10 popular routes
SELECT
    start_location,
    end_location,
    COUNT(*) AS total_rides
FROM rides
GROUP BY start_location, end_location
ORDER BY total_rides DESC
LIMIT 10;

-- 11. Revenue by pickup location
SELECT
    start_location,
    ROUND(SUM(fare_amount), 2) AS total_revenue
FROM rides
GROUP BY start_location
ORDER BY total_revenue DESC
LIMIT 10;

-- 12. Rides by booking hour
SELECT
    HOUR(ride_start_time) AS booking_hour,
    COUNT(*) AS total_rides
FROM rides
GROUP BY HOUR(ride_start_time)
ORDER BY booking_hour;

USE ride_sharing_project;

-- 1. Ride details with customer and driver information
SELECT
    r.ride_id,
    u.name AS customer_name,
    d.name AS driver_name,
    r.start_location,
    r.end_location,
    r.distance_km,
    r.fare_amount
FROM rides r
JOIN users u ON r.user_id = u.user_id
JOIN drivers d ON r.driver_id = d.driver_id
LIMIT 10;


-- 2. Top 10 drivers by actual completed rides
SELECT
    d.driver_id,
    d.name AS driver_name,
    COUNT(r.ride_id) AS actual_rides,
    ROUND(SUM(r.fare_amount), 2) AS total_revenue
FROM drivers d
JOIN rides r ON d.driver_id = r.driver_id
GROUP BY d.driver_id, d.name
ORDER BY actual_rides DESC
LIMIT 10;


-- 3. Vehicle-wise ride performance
SELECT
    v.make,
    v.model,
    COUNT(r.ride_id) AS total_rides,
    ROUND(AVG(r.fare_amount), 2) AS average_fare
FROM vehicles v
JOIN drivers d ON v.vehicle_id = d.vehicle_id
JOIN rides r ON d.driver_id = r.driver_id
GROUP BY v.vehicle_id, v.make, v.model
ORDER BY total_rides DESC
LIMIT 10;


-- 4. Customer rating analysis by driver
SELECT
    d.driver_id,
    d.name AS driver_name,
    COUNT(rt.rating_id) AS total_ratings,
    ROUND(AVG(rt.rating_value), 2) AS average_rating
FROM drivers d
JOIN rides r ON d.driver_id = r.driver_id
JOIN ratings rt ON r.ride_id = rt.ride_id
GROUP BY d.driver_id, d.name
ORDER BY average_rating DESC
LIMIT 10;


-- 5. Customer-wise ride and spending analysis
SELECT
    u.user_id,
    u.name AS customer_name,
    COUNT(r.ride_id) AS total_rides,
    ROUND(SUM(r.fare_amount), 2) AS total_spending
FROM users u
JOIN rides r ON u.user_id = r.user_id
GROUP BY u.user_id, u.name
ORDER BY total_spending DESC
LIMIT 10;






USE ride_sharing_project;

-- 1. Rank drivers by completed rides
WITH driver_performance AS (
    SELECT
        d.driver_id,
        d.name,
        COUNT(r.ride_id) AS actual_rides,
        ROUND(SUM(r.fare_amount), 2) AS revenue
    FROM drivers d
    JOIN rides r ON d.driver_id = r.driver_id
    GROUP BY d.driver_id, d.name
)
SELECT
    *,
    RANK() OVER (ORDER BY actual_rides DESC) AS ride_rank
FROM driver_performance
LIMIT 10;


-- 2. Rank pickup locations by number of rides
WITH location_analysis AS (
    SELECT
        start_location,
        COUNT(*) AS total_rides,
        ROUND(SUM(fare_amount), 2) AS revenue
    FROM rides
    GROUP BY start_location
)
SELECT
    *,
    DENSE_RANK() OVER (ORDER BY total_rides DESC) AS location_rank
FROM location_analysis
ORDER BY location_rank
LIMIT 10;


-- 3. Monthly ride and revenue trend
SELECT
    DATE_FORMAT(ride_start_time, '%Y-%m') AS ride_month,
    COUNT(*) AS total_rides,
    ROUND(SUM(fare_amount), 2) AS total_revenue,
    ROUND(AVG(fare_amount), 2) AS average_fare
FROM rides
GROUP BY ride_month
ORDER BY ride_month;


-- 4. Customer segmentation based on ride count
WITH customer_summary AS (
    SELECT
        u.user_id,
        u.name,
        COUNT(r.ride_id) AS total_rides,
        ROUND(SUM(r.fare_amount), 2) AS total_spending
    FROM users u
    JOIN rides r ON u.user_id = r.user_id
    GROUP BY u.user_id, u.name
)
SELECT
    *,
    CASE
        WHEN total_rides >= 10 THEN 'Frequent Customer'
        WHEN total_rides >= 5 THEN 'Regular Customer'
        ELSE 'Occasional Customer'
    END AS customer_segment
FROM customer_summary
ORDER BY total_spending DESC
LIMIT 20;


-- 5. Driver rating and ride performance
SELECT
    d.driver_id,
    d.name,
    COUNT(DISTINCT r.ride_id) AS total_rides,
    COUNT(rt.rating_id) AS total_ratings,
    ROUND(AVG(rt.rating_value), 2) AS average_rating
FROM drivers d
JOIN rides r ON d.driver_id = r.driver_id
JOIN ratings rt ON r.ride_id = rt.ride_id
GROUP BY d.driver_id, d.name
HAVING COUNT(rt.rating_id) >= 50
ORDER BY average_rating DESC
LIMIT 10;


-- 6. Compare recorded driver rides with actual rides
SELECT
    d.driver_id,
    d.name,
    d.total_rides AS recorded_rides,
    COUNT(r.ride_id) AS actual_rides,
    d.total_rides - COUNT(r.ride_id) AS ride_difference
FROM drivers d
LEFT JOIN rides r ON d.driver_id = r.driver_id
GROUP BY d.driver_id, d.name, d.total_rides
HAVING ride_difference <> 0
ORDER BY ABS(ride_difference) DESC
LIMIT 20;



USE ride_sharing_project;

-- 1. Check the complete date range
SELECT
    MIN(ride_start_time) AS first_ride,
    MAX(ride_start_time) AS last_ride,
    COUNT(*) AS total_rides
FROM rides;


-- 2. Check monthly data coverage
SELECT
    DATE_FORMAT(ride_start_time, '%Y-%m') AS ride_month,
    MIN(DATE(ride_start_time)) AS first_date,
    MAX(DATE(ride_start_time)) AS last_date,
    COUNT(*) AS total_rides
FROM rides
GROUP BY ride_month
ORDER BY ride_month;


-- 3. Average trip duration in minutes
SELECT
    ROUND(AVG(TIMESTAMPDIFF(
        MINUTE, ride_start_time, ride_end_time
    )), 2) AS avg_duration_minutes
FROM rides;


-- 4. Rides by day of the week
SELECT
    DAYNAME(ride_start_time) AS weekday,
    COUNT(*) AS total_rides
FROM rides
GROUP BY DAYOFWEEK(ride_start_time), DAYNAME(ride_start_time)
ORDER BY DAYOFWEEK(ride_start_time);


-- 5. Average fare per kilometre
SELECT
    ROUND(AVG(fare_amount / distance_km), 2) AS avg_fare_per_km
FROM rides;


-- 6. Driver availability
SELECT
    available,
    COUNT(*) AS total_drivers
FROM drivers
GROUP BY available;


