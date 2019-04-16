-- Section1
SELECT DISTINCT driver_acc.id, driver_acc.first_name, driver_acc.last_name
FROM Account AS driver_acc
         JOIN Driver D ON driver_acc.id = D.driver_id
         JOIN Car C ON D.driver_id = C.driver_id
         JOIN Ride R ON C.tag_number = R.car_id
         JOIN RideRequest RR ON R.ride_req_id = RR.ride_req_id
         JOIN Rider R2 ON RR.rider_id = R2.rider_id
         JOIN Account AS rider_acc ON R2.rider_id = rider_acc.id
WHERE rider_acc.last_name = driver_acc.last_name;

-- Section2
SELECT Account.phone
FROM Account
         JOIN Driver D ON Account.id = D.driver_id
         JOIN Car C ON D.driver_id = C.driver_id
         JOIN Ride R ON C.tag_number = R.car_id
         JOIN Payment P ON R.ride_req_id = P.ride_id
WHERE P.is_cash = TRUE
GROUP BY Account.phone, Account.id
ORDER BY SUM(P.amount) DESC, Account.id
LIMIT 5;

-- Section3
SELECT driver_acc.first_name, rider_acc.first_name, COUNT(*) as c
FROM Account AS driver_acc
         JOIN Driver D ON driver_acc.id = D.driver_id
         JOIN Car C ON D.driver_id = C.driver_id
         JOIN Ride R ON C.tag_number = R.car_id
         JOIN RideRequest RR ON R.ride_req_id = RR.ride_req_id
         JOIN Rider R2 ON RR.rider_id = R2.rider_id
         JOIN Account AS rider_acc ON R2.rider_id = rider_acc.id
GROUP BY driver_acc.id, rider_acc.id
HAVING c = (SELECT MAX(c1)
            FROM (SELECT COUNT(*) AS c1
                  FROM Account as driver_acc
                           join Driver D on driver_acc.id = D.driver_id
                           join Car C on D.driver_id = C.driver_id
                           JOIN Ride R on C.tag_number = R.car_id
                           join RideRequest RR on R.ride_req_id = RR.ride_req_id
                           join Rider R2 on RR.rider_id = R2.rider_id
                           JOIN Account as rider_acc On R2.rider_id = rider_acc.id
                  GROUP BY driver_acc.first_name, rider_acc.first_name) AS v)
ORDER BY driver_acc.id, rider_acc.id;

-- Section4
SELECT FLOOR(SUM(SQRT(
            POWER((destination_x_coordinate - origin_x_coordinate), 2)
            + POWER((destination_y_coordinate - origin_y_coordinate), 2))))
FROM RideRequest
WHERE ride_req_id IN (SELECT Ride.ride_req_id FROM Ride);

-- Section5
SELECT Driver.driver_id
FROM Driver
         JOIN Car C ON Driver.driver_id = C.driver_id
         JOIN Ride R ON C.tag_number = R.car_id
GROUP BY Driver.driver_id
HAVING AVG(driver_rating) < 3.5
   AND COUNT(*) > 5;

-- Section6
-- MySQL versions less than 8 don't support WITH clause
WITH star as (SELECT Driver.driver_id, AVG(driver_rating) AS avg
              FROM Driver
                       JOIN Car C ON Driver.driver_id = C.driver_id
                       JOIN Ride R ON C.tag_number = R.car_id
              GROUP BY Driver.driver_id)
SELECT '*', count(*)
FROM star
WHERE star.avg < 2
UNION
SELECT '***', count(*)
FROM star
WHERE star.avg >= 2
  AND star.avg < 4
UNION
SELECT '*****', count(*)
FROM star
WHERE star.avg >= 4;

-- Query for MySQL version < 8
SELECT '*', COUNT(*)
FROM (SELECT Driver.driver_id, AVG(driver_rating) AS avg
      FROM Driver
               JOIN Car C ON Driver.driver_id = C.driver_id
               JOIN Ride R ON C.tag_number = R.car_id
      GROUP BY Driver.driver_id) as V
WHERE V.avg < 2
UNION
SELECT '***', COUNT(*)
FROM (SELECT Driver.driver_id, AVG(driver_rating) AS avg
      FROM Driver
               JOIN Car C ON Driver.driver_id = C.driver_id
               JOIN Ride R ON C.tag_number = R.car_id
      GROUP BY Driver.driver_id) As V1
WHERE V1.avg >= 2
  AND V1.avg < 4
UNION
SELECT '*****', COUNT(*)
FROM (SELECT Driver.driver_id, AVG(driver_rating) AS avg
      FROM Driver
               JOIN Car C ON Driver.driver_id = C.driver_id
               JOIN Ride R ON C.tag_number = R.car_id
      GROUP BY Driver.driver_id) AS V2
WHERE V2.avg >= 4;

-- Section7
SELECT Driver.driver_id
FROM Driver
         JOIN Car C ON Driver.driver_id = C.driver_id
         JOIN Ride R ON C.tag_number = R.car_id
         JOIN RideRequest RR ON R.ride_req_id = RR.ride_req_id
         JOIN Payment P ON R.ride_req_id = P.ride_id
WHERE RR.car_type = 'Eco'
  AND TIMESTAMPDIFF(MINUTE, R.pickup_time, R.dropoff_time) < 10
  AND P.amount > 20000
  AND P.is_cASh = true;

-- Section8
SELECT AVG(rider_rating)
FROM Rider
         JOIN RideRequest RR ON Rider.rider_id = RR.rider_id
         JOIN Ride R ON RR.ride_req_id = R.ride_req_id
GROUP BY Rider.rider_id
ORDER BY COUNT(*) DESC, Rider.rider_id
LIMIT 5;

-- Section9
SELECT DISTINCT Account.first_name, Account.lASt_name
FROM Account
         JOIN Rider R ON Account.id = R.rider_id
         JOIN RideRequest RR ON R.rider_id = RR.rider_id,
     Car C
         JOIN Driver D ON C.driver_id = D.driver_id
where RR.ride_req_id NOT IN (SELECT Ride.ride_req_id FROM Ride)
  AND D.is_active = true
  AND SQRT(
                  POWER((D.x_coordinate - origin_x_coordinate), 2)
                  + POWER((D.y_coordinate - origin_y_coordinate), 2)) < 1.0;
-- Section10
SELECT A.id, A.first_name, A.last_name
FROM Account A
         JOIN Driver D ON A.id = D.driver_id
         JOIN Car C ON D.driver_id = C.driver_id
         JOIN Ride R ON C.tag_number = R.car_id
         JOIN Payment P ON R.ride_req_id = P.ride_id
GROUP BY A.id, A.first_name, A.last_name
HAVING SUM(amount) > (SELECT AVG(s)
                      FROM (SELECT SUM(amount) AS s
                            FROM Account A
                                     JOIN Driver D ON A.id = D.driver_id
                                     JOIN Car C ON D.driver_id = C.driver_id
                                     JOIN Ride R ON C.tag_number = R.car_id
                                     JOIN Payment P ON R.ride_req_id = P.ride_id
                            GROUP BY A.id, A.first_name, A.lASt_name) AS v);

-- Section11
-- MySQL versions less than 8 don't support WITH clause
WITH eco_type as (SELECT COUNT(*) AS c
                  FROM RideRequest RR
                  WHERE RR.ride_req_id NOT IN (SELECT R.ride_req_id FROM Ride R)
                    AND RR.car_type = 'eco'),
     luxury_type AS (SELECT COUNT(*) AS c
                     FROM RideRequest RR
                     WHERE RR.ride_req_id NOT IN (SELECT R.ride_req_id FROM Ride R)
                       AND RR.car_type = 'Luxury')
SELECT CASE
           WHEN luxury_type.c > eco_type.c THEN 'Luxury'
           ELSE 'Eco'
           END,
       ABS(luxury_type.c - eco_type.c);

-- Query for MySQL version < 8
SELECT CASE
           WHEN (SELECT count(*)
                 FROM RideRequest RR
                 WHERE RR.ride_req_id NOT IN (SELECT R.ride_req_id FROM Ride R)
                   AND RR.car_type = 'Luxury') > (SELECT count(*)
                                                  FROM RideRequest RR
                                                  WHERE RR.ride_req_id NOT IN (SELECT R.ride_req_id FROM Ride R)
                                                    AND RR.car_type = 'Eco') THEN 'Luxury'
           ELSE 'Eco'
           END,
       ABS((SELECT count(*)
            FROM RideRequest RR
            WHERE RR.ride_req_id NOT IN (SELECT R.ride_req_id FROM Ride R)
              AND RR.car_type = 'Luxury') - (SELECT count(*)
                                             FROM RideRequest RR
                                             WHERE RR.ride_req_id NOT IN (SELECT R.ride_req_id FROM Ride R)
                                               AND RR.car_type = 'Eco'));

-- Section12
SELECT C.model, COUNT(*)
FROM Car C
         JOIN Driver D ON C.driver_id = D.driver_id
WHERE D.is_active = true
  AND C.tag_number LIKE '__T%'
GROUP BY C.model;

-- Section13
SELECT ride_id
FROM Ride R
         JOIN Payment P ON R.ride_req_id = P.ride_id
WHERE P.amount / (TIMESTAMPDIFF(MINUTE, R.pickup_time, R.dropoff_time) * 1000) > 5
  AND P.amount % 2000 = 0;



