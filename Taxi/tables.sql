CREATE TABLE Account
(
  id         INT,
  first_name VARCHAR(255),
  last_name  VARCHAR(255),
  email      VARCHAR(255) UNIQUE,
  phone      VARCHAR(128) NOT NULL UNIQUE,
  password   VARCHAR(255),
  PRIMARY KEY (id)
);

CREATE TABLE Rider
(
  rider_id     INT,
  x_coordinate FLOAT,
  y_coordinate FLOAT,
  PRIMARY KEY (rider_id),
  FOREIGN KEY (rider_id) REFERENCES Account (id)
);

CREATE TABLE Driver
(
  driver_id    INT,
  is_active    BOOLEAN,
  x_coordinate FLOAT NOT NULL,
  y_coordinate FLOAT NOT NULL,
  PRIMARY KEY (driver_id),
  FOREIGN KEY (driver_id) REFERENCES Account (id)
);

CREATE TABLE Car
(
  driver_id  INT,
  color      VARCHAR(255),
  tag_number VARCHAR(128),
  type       VARCHAR(255),
  model      VARCHAR(255),
  PRIMARY KEY (tag_number),
  FOREIGN KEY (driver_id) REFERENCES Driver (driver_id)

);

CREATE TABLE RideRequest
(
  ride_req_id              INT,
  rider_id                 INT,
  origin_x_coordinate      FLOAT NOT NULL,
  origin_y_coordinate      FLOAT NOT NULL,
  destination_x_coordinate FLOAT NOT NULL,
  destination_y_coordinate FLOAT NOT NULL,
  car_type                 VARCHAR(255),
  PRIMARY KEY (ride_req_id),
  FOREIGN KEY (rider_id) REFERENCES Rider (rider_id)
);

CREATE TABLE Ride
(
  car_id        VARCHAR(128),
  ride_req_id   INT,
  pickup_time   DATETIME,
  dropoff_time  DATETIME,
  rider_rating  FLOAT,
  driver_rating FLOAT,
  PRIMARY KEY (ride_req_id),
  FOREIGN KEY (car_id) REFERENCES Car (tag_number),
  FOREIGN KEY (ride_req_id) REFERENCES RideRequest (ride_req_id)
);

CREATE TABLE Payment
(
  id               INT,
  ride_id          INT,
  status           VARCHAR(64),
  amount           INT,
  transaction_code VARCHAR(64),
  is_cash          BOOLEAN,
  PRIMARY KEY (id),
  FOREIGN KEY (ride_id) REFERENCES Ride (ride_req_id)
);
