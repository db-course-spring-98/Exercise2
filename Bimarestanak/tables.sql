CREATE DATABASE Bimarestanak;
USE Bimarestanak;

CREATE TABLE Patient
(
    patient_id   INT AUTO_INCREMENT,
    name         VARCHAR(255) NOT NULL,
    gender       VARCHAR(16)  NOT NULL,
    address      TEXT,
    phone        VARCHAR(255) NOT NULL UNIQUE,
    disease      VARCHAR(255),
    insurance_id VARCHAR(255) UNIQUE,
    PRIMARY KEY (patient_id)
);


CREATE TABLE Doctor
(
    dr_id      INT AUTO_INCREMENT,
    name       VARCHAR(255),
    position   VARCHAR(255),
    department VARCHAR(128),
    PRIMARY KEY (dr_id)
);
CREATE TABLE Room
(
    room_id     INT AUTO_INCREMENT,
    room_number INT          NOT NULL UNIQUE,
    status      VARCHAR(128) NOT NULL DEFAULT 'empty',
    type        VARCHAR(128),
    PRIMARY KEY (room_id)
);

CREATE TABLE Stay
(
    stay_id    INT AUTO_INCREMENT,
    patient_id INT,
    room_id    INT,
    start_date DATE NOT NULL,
    end_date   DATE,
    PRIMARY KEY (stay_id),
    FOREIGN KEY (patient_id) REFERENCES Patient (patient_id),
    FOREIGN KEY (room_id) REFERENCES Room (room_id)
);


CREATE TABLE Nurse
(
    nurse_id INT AUTO_INCREMENT,
    name     VARCHAR(255),
    PRIMARY KEY (nurse_id)
);

CREATE TABLE Appointment
(
    dr_id      INT,
    patient_id INT,
    room_id    INT,
    nurse_id   INT,
    datetime   DATETIME NOT NULL DEFAULT NOW(),
    FOREIGN KEY (patient_id) REFERENCES Patient (patient_id),
    FOREIGN KEY (room_id) REFERENCES Room (room_id),
    FOREIGN KEY (nurse_id) REFERENCES Nurse (nurse_id),
    FOREIGN KEY (dr_id) REFERENCES Doctor (dr_id)
);