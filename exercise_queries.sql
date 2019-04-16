-- Section1
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

-- Section2
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

-- Section3
UPDATE Stay
SET room_id = (SELECT room_id FROM Room WHERE room_number = 25)
WHERE start_date = '2019-03-01'
  AND patient_id = (SELECT patient_id FROM Patient WHERE phone = '989123456789');

-- Section4
INSERT INTO Stay(patient_id, room_id, start_date, end_date)
VALUES ((SELECT patient_id FROM Patient WHERE phone = '989123456788'),
        (SELECT MIN(room_id) FROM Room WHERE status = 'empty'), CURDATE(), CURDATE() + INTERVAL 2 DAY);

-- Section5
UPDATE Room
SET status='full'
WHERE Room.room_id IN (SELECT room_id FROM Stay WHERE end_date IS NULL OR end_date >= CURDATE());

-- Section6
ALTER TABLE Nurse
    ADD positon VARCHAR(128) NOT NULL DEFAULT 'Informatics Nurse';

