BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Test CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Bill CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Medicine CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Treatment CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Prescription CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Appointment CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Patient CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Administrators CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Secretary CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Laborant CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Doctor CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Room CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Nurse CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Staff CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Person CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Price CASCADE CONSTRAINTS';
   EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Person table
CREATE TABLE Person (
    ID NUMBER(10) NOT NULL,
    first_name VARCHAR2(255),
    middle_name VARCHAR2(255),
    last_name VARCHAR2(255),
    address_name VARCHAR2(255),
    street VARCHAR2(255),
    city VARCHAR2(255),
    apt_number VARCHAR2(255),
    country VARCHAR2(255),
    phone_number VARCHAR2(20),
    email VARCHAR2(255) UNIQUE,
    password VARCHAR2(255),
    CONSTRAINT person_pk PRIMARY KEY (ID)
);
/

-- Staff table
CREATE TABLE Staff (
    ID NUMBER(10) NOT NULL,
    department VARCHAR2(255),
    date_started DATE,
    social_sec_number VARCHAR2(20) UNIQUE,
    salary NUMBER(10, 2),
    person_id NUMBER(10) NOT NULL,
    role VARCHAR2(50) CHECK (role IN ('Doctor', 'Nurse', 'Laborant', 'Secretary', 'Administrator')),
    CONSTRAINT staff_pk PRIMARY KEY (ID),
    CONSTRAINT fk_staff_person FOREIGN KEY (person_id) REFERENCES Person(ID)
);
/
-- Administrator table
CREATE TABLE Administrators (
    ID NUMBER(10) NOT NULL,
    staff_id NUMBER(10) UNIQUE NOT NULL,
    rank VARCHAR2(255),
    CONSTRAINT admin_pk PRIMARY KEY (ID),
    CONSTRAINT fk_admin_staff FOREIGN KEY (staff_id) REFERENCES Staff(ID)
);
/
-- Doctor table
CREATE TABLE Doctor (
    ID NUMBER(10) NOT NULL,
    staff_id NUMBER(10) UNIQUE NOT NULL,
    rank VARCHAR2(255),
    CONSTRAINT doctor_pk PRIMARY KEY (ID),
    CONSTRAINT fk_doctor_staff FOREIGN KEY (staff_id) REFERENCES Staff(ID)
);
/
-- Nurse table
CREATE TABLE Nurse (
    ID NUMBER(10) NOT NULL,
    staff_id NUMBER(10) UNIQUE NOT NULL,
    rank VARCHAR2(255),
    CONSTRAINT nurse_pk PRIMARY KEY (ID),
    CONSTRAINT fk_nurse_staff FOREIGN KEY (staff_id) REFERENCES Staff(ID)
);
/

-- Laborant table
CREATE TABLE Laborant (
    ID NUMBER(10) NOT NULL,
    staff_id NUMBER(10) UNIQUE NOT NULL,
    rank VARCHAR2(255),
    CONSTRAINT laborant_pk PRIMARY KEY (ID),
    CONSTRAINT fk_laborant_staff FOREIGN KEY (staff_id) REFERENCES Staff(ID)
);
/
-- Secretary table
CREATE TABLE Secretary (
    ID NUMBER(10) NOT NULL,
    staff_id NUMBER(10) UNIQUE NOT NULL,
    rank VARCHAR2(255),
    CONSTRAINT secretary_pk PRIMARY KEY (ID),
    CONSTRAINT fk_secretary_staff FOREIGN KEY (staff_id) REFERENCES Staff(ID)
);
/

-- Medicine table
CREATE TABLE Medicine (
    ID NUMBER(10) NOT NULL,
    name VARCHAR2(255),
    dose VARCHAR2(255),
    stock INT,
    CONSTRAINT medicine_pk PRIMARY KEY (ID)
);
/

-- Room table
CREATE TABLE Room (
    ID NUMBER(10) NOT NULL,
    max_capacity NUMBER(5),
    current_patient_count NUMBER(5) DEFAULT 0,
    availability CHAR(1) CHECK (availability IN ('Y', 'N')),
    nurse_id NUMBER(10),
    CONSTRAINT room_pk PRIMARY KEY (ID),
    CONSTRAINT fk_room_nurse FOREIGN KEY (nurse_id) REFERENCES Nurse(ID)
);
/

-- Patient table
CREATE TABLE Patient (
    soc_sec_no VARCHAR2(20) NOT NULL,
    person_id NUMBER(10) NOT NULL,
    room_id NUMBER(10),
    discharge_date DATE,
    insurance CHAR(1) CHECK (insurance IN ('Y', 'N')),
    CONSTRAINT patient_pk PRIMARY KEY (soc_sec_no, person_id),
    CONSTRAINT fk_patient_person FOREIGN KEY (person_id) REFERENCES Person(ID),
    CONSTRAINT fk_patient_room FOREIGN KEY (room_id) REFERENCES Room(ID)
);
/

-- Prescription table
CREATE TABLE Prescription (
    ID NUMBER(10) NOT NULL,
    datetime DATE,
    patient_soc_sec_no VARCHAR2(20) NOT NULL,
    medicine_ID NUMBER(10) NOT NULL,
    patient_id NUMBER(10) NOT NULL,
    doctor_id NUMBER(10) NOT NULL,
    CONSTRAINT prescription_pk PRIMARY KEY (ID),
    CONSTRAINT fk_treatment_patient FOREIGN KEY (patient_soc_sec_no, patient_id) REFERENCES Patient(soc_sec_no, person_id),
    CONSTRAINT fk_treatment_medicine FOREIGN KEY (medicine_ID) REFERENCES Medicine(ID),
    CONSTRAINT fk_prescription_doctor FOREIGN KEY (doctor_id) REFERENCES Staff(ID)
);
/
-- Treatment table
CREATE TABLE Treatment (
    ID NUMBER(10) NOT NULL,
    name VARCHAR2(255),
    patient_soc_sec_no VARCHAR2(20) NOT NULL,
    patient_id NUMBER(10) NOT NULL,
    admission_days NUMBER(3),
    medicine_ID NUMBER(10) NOT NULL,
    doctor_id NUMBER(10) NOT NULL,
    CONSTRAINT treatment_pk PRIMARY KEY (ID),
    CONSTRAINT fk_treatment_patient_ssn FOREIGN KEY (patient_soc_sec_no, patient_id) REFERENCES Patient(soc_sec_no, person_id),
    CONSTRAINT fk_treatment_med FOREIGN KEY (medicine_ID) REFERENCES Medicine(ID),
    CONSTRAINT fk_treatment_doctor FOREIGN KEY (doctor_id) REFERENCES Doctor(ID)
);
/
-- Test table
CREATE TABLE Test (
    ID NUMBER(10) NOT NULL,
    datetime DATE,
    name VARCHAR2(255),
    result VARCHAR2(255),
    patient_soc_sec_no VARCHAR2(20) NOT NULL,
    patient_id NUMBER(10) NOT NULL,
    laborant_id NUMBER(10) NOT NULL,
    CONSTRAINT test_pk PRIMARY KEY (ID),
    CONSTRAINT fk_test_patient FOREIGN KEY (patient_soc_sec_no, patient_id) REFERENCES Patient(soc_sec_no, person_id),
    CONSTRAINT fk_test_laborant FOREIGN KEY (laborant_id) REFERENCES Laborant(ID)
);
/

-- Appointment table
CREATE TABLE Appointment (
    ID NUMBER(10) NOT NULL,
    datetime DATE,
    time VARCHAR2(5),
    status VARCHAR2(50) CHECK (status IN ('scheduled', 'completed', 'cancelled', 'no_show')),
    patient_soc_sec_no VARCHAR2(20) NOT NULL,
    doctor_id NUMBER(10) NOT NULL,
    patient_id NUMBER(10) NOT NULL,
    CONSTRAINT appointment_pk PRIMARY KEY (ID),
    CONSTRAINT fk_app_patient FOREIGN KEY (patient_soc_sec_no, patient_id) REFERENCES Patient(soc_sec_no, person_id),
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) REFERENCES Doctor(ID)
);
/
-- Bill table
CREATE TABLE Bill (
    ID NUMBER(10) NOT NULL,
    total NUMBER(10, 2),
    datetime DATE,
    status VARCHAR2(50) CHECK (status IN ('completed', 'ongoing')),
    patient_soc_sec_no VARCHAR2(20) NOT NULL,
    patient_id NUMBER(10) NOT NULL,
    CONSTRAINT bill_pk PRIMARY KEY (ID),
    CONSTRAINT fk_bill_patient FOREIGN KEY (patient_soc_sec_no, patient_id) REFERENCES Patient(soc_sec_no, person_id)
);
/
-- Price Table
CREATE TABLE Price (
    ID NUMBER(10) NOT NULL,
    service_description VARCHAR2(255) NOT NULL,
    amount NUMBER(10, 2) NOT NULL,
    CONSTRAINT price_pk PRIMARY KEY (ID)
);
/

INSERT INTO Person VALUES (1, 'John', 'Michael', 'Smith', 'House Name 1', 'Street 1', 'City 1', '1', 'Turkey', '05001112233', 'john1@email.com', 'password1');
INSERT INTO Person VALUES (2, 'Emily', 'Sarah', 'Brown', 'House Name 2', 'Street 2', 'City 2', '2', 'Turkey', '05001112234', 'emily2@email.com', 'password2');
INSERT INTO Person VALUES (3, 'David', 'James', 'Wilson', 'House Name 3', 'Street 3', 'City 3', '3', 'Turkey', '05001112235', 'david3@email.com', 'password3');
INSERT INTO Person VALUES (4, 'Sophia', 'Emma', 'Johnson', 'House Name 4', 'Street 4', 'City 4', '4', 'Turkey', '05001112236', 'sophia4@email.com', 'password4');
INSERT INTO Person VALUES (5, 'Olivia', 'Charlotte', 'Miller', 'House Name 5', 'Street 5', 'City 5', '5', 'Turkey', '05001112237', 'olivia5@email.com', 'password5');
INSERT INTO Person VALUES (6, 'John', '', 'Doe', 'House 6', 'Street 6', 'City 6', '6', 'Turkey', '05001112238', 'john6@email.com', 'password6');
INSERT INTO Person VALUES (7, 'Emily', '', 'Smith', 'House 7', 'Street 7', 'City 7', '7', 'Turkey', '05001112239', 'emily7@email.com', 'password7');
INSERT INTO Person VALUES (8, 'Michael', '', 'Brown', 'House 8', 'Street 8', 'City 8', '8', 'Turkey', '05001112240', 'michael8@email.com', 'password8');
INSERT INTO Person VALUES (9, 'Sarah', '', 'Johnson', 'House 9', 'Street 9', 'City 9', '9', 'Turkey', '05001112241', 'sarah9@email.com', 'password9');
INSERT INTO Person VALUES (10, 'David', '', 'Miller', 'House 10', 'Street 10', 'City 10', '10', 'Turkey', '05001112242', 'david10@email.com', 'password10');
INSERT INTO Person VALUES (11, 'Jessica', '', 'Davis', 'House 11', 'Street 11', 'City 11', '11', 'Turkey', '05001112243', 'jessica11@email.com', 'password11');
INSERT INTO Person VALUES (12, 'Daniel', '', 'Garcia', 'House 12', 'Street 12', 'City 12', '12', 'Turkey', '05001112244', 'daniel12@email.com', 'password12');
INSERT INTO Person VALUES (13, 'Laura', '', 'Martinez', 'House 13', 'Street 13', 'City 13', '13', 'Turkey', '05001112245', 'laura13@email.com', 'password13');
INSERT INTO Person VALUES (14, 'James', '', 'Wilson', 'House 14', 'Street 14', 'City 14', '14', 'Turkey', '05001112246', 'james14@email.com', 'password14');
INSERT INTO Person VALUES (15, 'Sophia', '', 'Anderson', 'House 15', 'Street 15', 'City 15', '15', 'Turkey', '05001112247', 'sophia15@email.com', 'password15');
INSERT INTO Person VALUES (16, 'William', '', 'Thomas', 'House 16', 'Street 16', 'City 16', '16', 'Turkey', '05001112248', 'william16@email.com', 'password16');
INSERT INTO Person VALUES (17, 'Olivia', '', 'Taylor', 'House 17', 'Street 17', 'City 17', '17', 'Turkey', '05001112249', 'olivia17@email.com', 'password17');
INSERT INTO Person VALUES (18, 'Benjamin', '', 'Moore', 'House 18', 'Street 18', 'City 18', '18', 'Turkey', '05001112250', 'benjamin18@email.com', 'password18');
INSERT INTO Person VALUES (19, 'Emma', '', 'Jackson', 'House 19', 'Street 19', 'City 19', '19', 'Turkey', '05001112251', 'emma19@email.com', 'password19');
INSERT INTO Person VALUES (20, 'Matthew', '', 'White', 'House 20', 'Street 20', 'City 20', '20', 'Turkey', '05001112252', 'matthew20@email.com', 'password20');
INSERT INTO Person VALUES (21, 'Ava', '', 'Harris', 'House 21', 'Street 21', 'City 21', '21', 'Turkey', '05001112253', 'ava21@email.com', 'password21');
INSERT INTO Person VALUES (22, 'Ethan', '', 'Martin', 'House 22', 'Street 22', 'City 22', '22', 'Turkey', '05001112254', 'ethan22@email.com', 'password22');
INSERT INTO Person VALUES (23, 'Isabella', '', 'Thompson', 'House 23', 'Street 23', 'City 23', '23', 'Turkey', '05001112255', 'isabella23@email.com', 'password23');
INSERT INTO Person VALUES (24, 'Jacob', '', 'Gonzalez', 'House 24', 'Street 24', 'City 24', '24', 'Turkey', '05001112256', 'jacob24@email.com', 'password24');
INSERT INTO Person VALUES (25, 'Mia', '', 'Hernandez', 'House 25', 'Street 25', 'City 25', '25', 'Turkey', '05001112257', 'mia25@email.com', 'password25');
INSERT INTO Person VALUES (26, 'Alexander', '', 'Lopez', 'House 26', 'Street 26', 'City 26', '26', 'Turkey', '05001112258', 'alexander26@email.com', 'password26');
INSERT INTO Person VALUES (27, 'Charlotte', '', 'Gonzalez', 'House 27', 'Street 27', 'City 27', '27', 'Turkey', '05001112259', 'charlotte27@email.com', 'password27');
INSERT INTO Person VALUES (28, 'Lucas', '', 'Perez', 'House 28', 'Street 28', 'City 28', '28', 'Turkey', '05001112260', 'lucas28@email.com', 'password28');
INSERT INTO Person VALUES (29, 'Amelia', '', 'Sanchez', 'House 29', 'Street 29', 'City 29', '29', 'Turkey', '05001112261', 'amelia29@email.com', 'password29');
INSERT INTO Person VALUES (30, 'Jack', '', 'Patel', 'House 30', 'Street 30', 'City 30', '30', 'Turkey', '05001112262', 'jack30@email.com', 'password30');
INSERT INTO Person VALUES (31, 'Alexander', '', 'Lopez', 'House 26', 'Street 26', 'City 26', '26', 'Turkey', '05101115258', 'alexander226@email.com', 'password26');
INSERT INTO Person VALUES (32, 'Charlotte', '', 'Gonzalez', 'House 27', 'Street 27', 'City 27', '27', 'Turkey', '55151112259', 'charlotte227@email.com', 'password27');
INSERT INTO Person VALUES (33, 'Lucas', '', 'Perez', 'House 28', 'Street 28', 'City 28', '28', 'Turkey', '05101112260', 'lucas228@email.com', 'password28');
INSERT INTO Person VALUES (34, 'Amelia', '', 'Sanchez', 'House 29', 'Street 29', 'City 29', '29', 'Turkey', '05101112261', 'amelia229@email.com', 'password29');
INSERT INTO Person VALUES (35, 'Jack', '', 'Patel', 'House 30', 'Street 30', 'City 30', '30', 'Turkey', '05101112262', 'jack230@email.com', 'password30');
INSERT INTO Person VALUES (36, 'Alexander', '', 'Lopez', 'House 26', 'Street 26', 'City 26', '26', 'Turkey', '05101112258', 'alexander262@email.com', 'password26');
INSERT INTO Person VALUES (37, 'Charlotte', '', 'Gonzalez', 'House 27', 'Street 27', 'City 27', '27', 'Turkey', '05101112259', 'charlotte2327@email.com', 'password27');
INSERT INTO Person VALUES (38, 'Lucas', '', 'Perez', 'House 28', 'Street 28', 'City 28', '28', 'Turkey', '05101113261', 'lucas2328@email.com', 'password28');
INSERT INTO Person VALUES (39, 'Amelia', '', 'Sanchez', 'House 29', 'Street 29', 'City 29', '29', 'Turkey', '05121112261', 'amelia3229@email.com', 'password29');
INSERT INTO Person VALUES (40, 'Jack', '', 'Patel', 'House 30', 'Street 30', 'City 30', '30', 'Turkey', '05101312262', 'jack3420@email.com', 'password30');

INSERT INTO Staff VALUES (1, 'Cardiology', TO_DATE('2023-01-01', 'YYYY-MM-DD'), '12345678926', 10000, 6, 'Doctor');
INSERT INTO Staff VALUES (2, 'Neurology', TO_DATE('2023-01-02', 'YYYY-MM-DD'), '12345678927', 12000, 7, 'Doctor');
INSERT INTO Staff VALUES (3, 'Dermatology', TO_DATE('2023-01-03', 'YYYY-MM-DD'), '12345678928', 11000, 8, 'Doctor');
INSERT INTO Staff VALUES (4, 'Orthopedics', TO_DATE('2023-01-04', 'YYYY-MM-DD'), '12345678929', 13000, 9, 'Doctor');
INSERT INTO Staff VALUES (5, 'Psychiatry', TO_DATE('2023-01-05', 'YYYY-MM-DD'), '12345678930', 9000, 10, 'Doctor');
INSERT INTO Staff VALUES (6, 'Cardiology', TO_DATE('2023-01-01', 'YYYY-MM-DD'), '12345678906', 10000, 11, 'Nurse');
INSERT INTO Staff VALUES (7, 'Neurology', TO_DATE('2023-01-02', 'YYYY-MM-DD'), '12345678907', 12000, 12, 'Nurse');
INSERT INTO Staff VALUES (8, 'Dermatology', TO_DATE('2023-01-03', 'YYYY-MM-DD'), '12345678908', 11000, 13, 'Nurse');
INSERT INTO Staff VALUES (9, 'Orthopedics', TO_DATE('2023-01-04', 'YYYY-MM-DD'), '12345678909', 13000, 14, 'Nurse');
INSERT INTO Staff VALUES (10, 'Psychiatry', TO_DATE('2023-01-05', 'YYYY-MM-DD'), '12345678910', 9000, 15, 'Nurse');
INSERT INTO Staff VALUES (11, 'Cardiology', TO_DATE('2023-01-01', 'YYYY-MM-DD'), '12345678911', 10000, 16, 'Laborant');
INSERT INTO Staff VALUES (12, 'Neurology', TO_DATE('2023-01-02', 'YYYY-MM-DD'), '12345678912', 12000, 17, 'Laborant');
INSERT INTO Staff VALUES (13, 'Dermatology', TO_DATE('2023-01-03', 'YYYY-MM-DD'), '12345678913', 11000, 18, 'Laborant');
INSERT INTO Staff VALUES (14, 'Orthopedics', TO_DATE('2023-01-04', 'YYYY-MM-DD'), '12345678914', 13000, 19, 'Laborant');
INSERT INTO Staff VALUES (15, 'Psychiatry', TO_DATE('2023-01-05', 'YYYY-MM-DD'), '12345678915', 9000, 20, 'Laborant');
INSERT INTO Staff VALUES (16, 'Cardiology', TO_DATE('2023-01-01', 'YYYY-MM-DD'), '12345678916', 10000, 21, 'Administrator');
INSERT INTO Staff VALUES (17, 'Neurology', TO_DATE('2023-01-02', 'YYYY-MM-DD'), '12345678917', 12000, 22, 'Administrator');
INSERT INTO Staff VALUES (18, 'Dermatology', TO_DATE('2023-01-03', 'YYYY-MM-DD'), '12345678918', 11000, 23, 'Administrator');
INSERT INTO Staff VALUES (19, 'Orthopedics', TO_DATE('2023-01-04', 'YYYY-MM-DD'), '12345678919', 13000, 24, 'Administrator');
INSERT INTO Staff VALUES (20, 'Psychiatry', TO_DATE('2023-01-05', 'YYYY-MM-DD'), '12345678920', 9000, 25, 'Administrator');
INSERT INTO Staff VALUES (21, 'Cardiology', TO_DATE('2023-01-01', 'YYYY-MM-DD'), '12345678921', 10000, 26, 'Secretary');
INSERT INTO Staff VALUES (22, 'Neurology', TO_DATE('2023-01-02', 'YYYY-MM-DD'), '12345678922', 12000, 27, 'Secretary');
INSERT INTO Staff VALUES (23, 'Dermatology', TO_DATE('2023-01-03', 'YYYY-MM-DD'), '12345678923', 11000, 28, 'Secretary');
INSERT INTO Staff VALUES (24, 'Orthopedics', TO_DATE('2023-01-04', 'YYYY-MM-DD'), '12345678924', 13000, 29, 'Secretary');
INSERT INTO Staff VALUES (25, 'Psychiatry', TO_DATE('2023-01-05', 'YYYY-MM-DD'), '12345678925', 9000, 30, 'Secretary');

INSERT INTO Doctor VALUES (1, 1, 'Professor');
INSERT INTO Doctor VALUES (2, 2, 'Professor');
INSERT INTO Doctor VALUES (3, 3, 'Resident');
INSERT INTO Doctor VALUES (4, 4, 'Resident');
INSERT INTO Doctor VALUES (5, 5, 'Fellow');

INSERT INTO Nurse VALUES (1, 6, 'Senior Nurse');
INSERT INTO Nurse VALUES (2, 7, 'Charge Nurse');
INSERT INTO Nurse VALUES (3, 8, 'Registered Nurse');
INSERT INTO Nurse VALUES (4, 9, 'Nurse Practitioner');
INSERT INTO Nurse VALUES (5, 10, 'Nurse Practitioner');

INSERT INTO Laborant VALUES (1, 11, 'Lead Laboratory Technician');
INSERT INTO Laborant VALUES (2, 12, 'Senior Laboratory Technician');
INSERT INTO Laborant VALUES (3, 13, 'Laboratory Technician');
INSERT INTO Laborant VALUES (4, 14, 'Junior Laboratory Technician');
INSERT INTO Laborant VALUES (5, 15, 'Laboratory Assistant');

INSERT INTO Administrators VALUES (1, 16, 'Chief Administrator');
INSERT INTO Administrators VALUES (2, 17, 'Senior Administrator');
INSERT INTO Administrators VALUES (3, 18, 'Administrator');
INSERT INTO Administrators VALUES (4, 19, 'Assistant Administrator');
INSERT INTO Administrators VALUES (5, 20, 'Junior Administrator');

INSERT INTO Secretary VALUES (1, 21, 'Senior Secretary');
INSERT INTO Secretary VALUES (2, 22, 'Secretary');
INSERT INTO Secretary VALUES (3, 23, 'Secretary');
INSERT INTO Secretary VALUES (4, 24, 'Intern Assistant');
INSERT INTO Secretary VALUES (5, 25, 'Intern Assistant');

INSERT INTO Room VALUES (1, 2, 1, 'Y', 1);
INSERT INTO Room VALUES (2, 3, 2, 'N', 2);
INSERT INTO Room VALUES (3, 2, 0, 'Y', 3);
INSERT INTO Room VALUES (4, 1, 1, 'N', 4);
INSERT INTO Room VALUES (5, 3, 1, 'Y', 5);

INSERT INTO Patient VALUES ('12345678901', 26, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('12345678902', 27, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('12345678903', 28, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('12345678904', 29, NULL, NULL, 'N');
INSERT INTO Patient VALUES ('12345678905', 30, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('12445678906', 31, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('12545678907', 32, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('12645678908', 33, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('12745678909', 34, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('12845678910', 35, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('12945678911', 36, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('13045678912', 37, NULL, NULL, 'Y');
INSERT INTO Patient VALUES ('13145678913', 38, 3, NULL, 'Y');
INSERT INTO Patient VALUES ('13245678914', 39, 4, NULL, 'Y');
INSERT INTO Patient VALUES ('13345678915', 40, 5, NULL, 'Y');

INSERT INTO Medicine VALUES (111, 'Med A', '50mg', 100);
INSERT INTO Medicine VALUES (222, 'Med B', '100mg', 200);
INSERT INTO Medicine VALUES (333, 'Med C', '150mg', 150);
INSERT INTO Medicine VALUES (444, 'Med D', '200mg', 250);
INSERT INTO Medicine VALUES (555, 'Med E', '250mg', 300);
INSERT INTO Medicine VALUES (666, 'Med F', '50mg', 100);
INSERT INTO Medicine VALUES (777, 'Med G', '100mg', 200);
INSERT INTO Medicine VALUES (888, 'Med H', '152mg', 150);
INSERT INTO Medicine VALUES (990, 'Med J', '250mg', 250);
INSERT INTO Medicine VALUES (999, 'Med K', '300mg', 300);
INSERT INTO Medicine VALUES (110, 'Med L', '50mg', 100);
INSERT INTO Medicine VALUES (220, 'Med M', '100mg', 200);
INSERT INTO Medicine VALUES (330, 'Med N', '150mg', 150);
INSERT INTO Medicine VALUES (440, 'Med O', '200mg', 250);
INSERT INTO Medicine VALUES (550, 'Med P', '250mg', 300);
INSERT INTO Medicine VALUES (660, 'Med R', '50mg', 100);
INSERT INTO Medicine VALUES (770, 'Med S', '100mg', 200);
INSERT INTO Medicine VALUES (880, 'Med T', '152mg', 150);
INSERT INTO Medicine VALUES (991, 'Med U', '250mg', 250);
INSERT INTO Medicine VALUES (992, 'Med V', '300mg', 300);

INSERT INTO Prescription VALUES (1, TO_DATE('2023-02-01', 'YYYY-MM-DD'), '12345678901', 111, 26, 1);
INSERT INTO Prescription VALUES (2, TO_DATE('2023-02-02', 'YYYY-MM-DD'), '12345678902', 222, 27, 2);
INSERT INTO Prescription VALUES (3, TO_DATE('2023-02-03', 'YYYY-MM-DD'), '12345678903', 333, 28, 3);
INSERT INTO Prescription VALUES (4, TO_DATE('2023-02-04', 'YYYY-MM-DD'), '12345678904', 444, 29, 4);
INSERT INTO Prescription VALUES (5, TO_DATE('2023-02-05', 'YYYY-MM-DD'), '12345678905', 555, 30, 5);
INSERT INTO Prescription VALUES (6, TO_DATE('2023-02-01', 'YYYY-MM-DD'), '12345678901', 111, 26, 1);
INSERT INTO Prescription VALUES (7, TO_DATE('2023-02-02', 'YYYY-MM-DD'), '12345678902', 222, 27, 2);
INSERT INTO Prescription VALUES (8, TO_DATE('2023-02-03', 'YYYY-MM-DD'), '12345678903', 333, 28, 3);
INSERT INTO Prescription VALUES (9, TO_DATE('2023-02-04', 'YYYY-MM-DD'), '12345678904', 444, 29, 4);
INSERT INTO Prescription VALUES (10, TO_DATE('2023-02-05', 'YYYY-MM-DD'), '12345678905', 555, 30, 5);
INSERT INTO Prescription VALUES (11, TO_DATE('2023-02-01', 'YYYY-MM-DD'), '12345678901', 111, 26, 1);
INSERT INTO Prescription VALUES (12, TO_DATE('2023-02-02', 'YYYY-MM-DD'), '12345678902', 222, 27, 2);
INSERT INTO Prescription VALUES (13, TO_DATE('2023-02-03', 'YYYY-MM-DD'), '12345678903', 333, 28, 3);
INSERT INTO Prescription VALUES (14, TO_DATE('2023-02-04', 'YYYY-MM-DD'), '12345678904', 444, 29, 4);
INSERT INTO Prescription VALUES (15, TO_DATE('2023-02-05', 'YYYY-MM-DD'), '12345678905', 555, 30, 5);
INSERT INTO Prescription VALUES (16, TO_DATE('2023-02-01', 'YYYY-MM-DD'), '12345678901', 111, 26, 1);
INSERT INTO Prescription VALUES (17, TO_DATE('2023-02-02', 'YYYY-MM-DD'), '12345678902', 222, 27, 2);
INSERT INTO Prescription VALUES (18, TO_DATE('2023-02-03', 'YYYY-MM-DD'), '12345678903', 333, 28, 3);
INSERT INTO Prescription VALUES (19, TO_DATE('2023-02-04', 'YYYY-MM-DD'), '12345678904', 444, 29, 4);
INSERT INTO Prescription VALUES (20, TO_DATE('2023-02-05', 'YYYY-MM-DD'), '12345678905', 555, 30, 5);

INSERT INTO Treatment VALUES (1, 'MR', '12345678901', 26, 0, 111, 1);
INSERT INTO Treatment VALUES (2, 'EKO', '12345678901', 26, 0, 222, 1);
INSERT INTO Treatment VALUES (3, 'Blood Test', '12345678902', 27, 3, 333, 2);
INSERT INTO Treatment VALUES (4, 'EKO', '12345678903', 28, 0, 444, 2);
INSERT INTO Treatment VALUES (5, 'EKO', '12345678904', 29, 0, 555, 4);
INSERT INTO Treatment VALUES (6, 'MR', '12345678901', 26, 0, 111, 1);
INSERT INTO Treatment VALUES (7, 'EKO', '12345678901', 26, 0, 222, 1);
INSERT INTO Treatment VALUES (8, 'Blood Test', '12345678902', 27, 3, 333, 2);
INSERT INTO Treatment VALUES (9, 'EKO', '12345678903', 28, 0, 444, 2);
INSERT INTO Treatment VALUES (10, 'EKO', '12345678904', 29, 0, 555, 4);
INSERT INTO Treatment VALUES (11, 'MR', '12345678901', 26, 0, 111, 1);
INSERT INTO Treatment VALUES (12, 'EKO', '12345678901', 26, 0, 222, 1);
INSERT INTO Treatment VALUES (13, 'Blood Test', '12345678902', 27, 0, 333, 2);
INSERT INTO Treatment VALUES (14, 'EKO', '12345678903', 28, 0, 444, 2);
INSERT INTO Treatment VALUES (15, 'EKO', '12345678904', 29, 0, 555, 4);
INSERT INTO Treatment VALUES (16, 'MR', '12345678901', 26, 0, 111, 1);
INSERT INTO Treatment VALUES (17, 'EKO', '12345678901', 26, 0, 222, 1);
INSERT INTO Treatment VALUES (18, 'Blood Test', '12345678902', 27, 3, 333, 2);
INSERT INTO Treatment VALUES (19, 'EKO', '12345678903', 28, 0, 444, 2);
INSERT INTO Treatment VALUES (20, 'EKO', '12345678904', 29, 0, 555, 4);

INSERT INTO Bill VALUES (1, 500, TO_DATE('2023-02-01', 'YYYY-MM-DD'), 'completed', '12345678901', 26);
INSERT INTO Bill VALUES (2, 1000, TO_DATE('2023-02-02', 'YYYY-MM-DD'), 'completed', '12345678902', 27);
INSERT INTO Bill VALUES (3, 1500, TO_DATE('2023-02-03', 'YYYY-MM-DD'), 'completed', '12345678903', 28);
INSERT INTO Bill VALUES (4, 2000, TO_DATE('2023-02-04', 'YYYY-MM-DD'), 'completed', '12345678904', 29);
INSERT INTO Bill VALUES (5, 2500, TO_DATE('2023-07-05', 'YYYY-MM-DD'), 'completed', '12345678905', 30);
INSERT INTO Bill VALUES (6, 500, TO_DATE('2023-02-01', 'YYYY-MM-DD'), 'completed', '12345678901', 26);
INSERT INTO Bill VALUES (7, 1000, TO_DATE('2023-02-02', 'YYYY-MM-DD'), 'completed', '12345678902', 27);
INSERT INTO Bill VALUES (8, 1500, TO_DATE('2023-02-03', 'YYYY-MM-DD'), 'completed', '12345678903', 28);
INSERT INTO Bill VALUES (9, 2000, TO_DATE('2023-02-04', 'YYYY-MM-DD'), 'completed', '12345678904', 29);
INSERT INTO Bill VALUES (10, 2500, TO_DATE('2023-07-05', 'YYYY-MM-DD'), 'completed', '12345678905', 30);
INSERT INTO Bill VALUES (11, 500, TO_DATE('2023-02-01', 'YYYY-MM-DD'), 'completed', '12345678901', 26);
INSERT INTO Bill VALUES (12, 1000, TO_DATE('2023-02-02', 'YYYY-MM-DD'), 'completed', '12345678902', 27);
INSERT INTO Bill VALUES (13, 1500, TO_DATE('2023-02-03', 'YYYY-MM-DD'), 'completed', '12345678903', 28);
INSERT INTO Bill VALUES (14, 2000, TO_DATE('2023-02-04', 'YYYY-MM-DD'), 'completed', '12345678904', 29);
INSERT INTO Bill VALUES (15, 2500, TO_DATE('2023-07-05', 'YYYY-MM-DD'), 'completed', '12345678905', 30);
INSERT INTO Bill VALUES (16, 500, TO_DATE('2023-02-01', 'YYYY-MM-DD'), 'completed', '12345678901', 26);
INSERT INTO Bill VALUES (17, 1000, TO_DATE('2023-02-02', 'YYYY-MM-DD'), 'completed', '12345678902', 27);
INSERT INTO Bill VALUES (18, 1500, TO_DATE('2023-02-03', 'YYYY-MM-DD'), 'ongoing', '12345678903', 28);
INSERT INTO Bill VALUES (19, 2000, TO_DATE('2023-02-04', 'YYYY-MM-DD'), 'ongoing', '12345678904', 29);
INSERT INTO Bill VALUES (20, 2500, TO_DATE('2023-07-05', 'YYYY-MM-DD'), 'ongoing', '12345678905', 30);

INSERT INTO Test VALUES (1, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'Test A', 'Pozitif', '12345678901', 26, 1);
INSERT INTO Test VALUES (2, TO_DATE('2023-03-02', 'YYYY-MM-DD'), 'Test B', 'Negatif', '12345678902', 27, 2);
INSERT INTO Test VALUES (3, TO_DATE('2023-03-03', 'YYYY-MM-DD'), 'Test C', 'Pozitif', '12345678903', 28, 3);
INSERT INTO Test VALUES (4, TO_DATE('2023-03-04', 'YYYY-MM-DD'), 'Test D', 'Negatif', '12345678904', 29, 4);
INSERT INTO Test VALUES (5, TO_DATE('2023-03-05', 'YYYY-MM-DD'), 'Test E', 'Pozitif', '12345678905', 30, 5);
INSERT INTO Test VALUES (6, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'Test A', 'Pozitif', '12345678901', 26, 1);
INSERT INTO Test VALUES (7, TO_DATE('2023-03-02', 'YYYY-MM-DD'), 'Test B', 'Negatif', '12345678902', 27, 2);
INSERT INTO Test VALUES (8, TO_DATE('2023-03-03', 'YYYY-MM-DD'), 'Test C', 'Pozitif', '12345678903', 28, 3);
INSERT INTO Test VALUES (9, TO_DATE('2023-03-04', 'YYYY-MM-DD'), 'Test D', 'Negatif', '12345678904', 29, 4);
INSERT INTO Test VALUES (10, TO_DATE('2023-03-05', 'YYYY-MM-DD'), 'Test E', 'Pozitif', '12345678905', 30, 5);
INSERT INTO Test VALUES (11, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'Test A', 'Pozitif', '12345678901', 26, 1);
INSERT INTO Test VALUES (12, TO_DATE('2023-03-02', 'YYYY-MM-DD'), 'Test B', 'Negatif', '12345678902', 27, 2);
INSERT INTO Test VALUES (13, TO_DATE('2023-03-03', 'YYYY-MM-DD'), 'Test C', 'Pozitif', '12345678903', 28, 3);
INSERT INTO Test VALUES (14, TO_DATE('2023-03-04', 'YYYY-MM-DD'), 'Test D', 'Negatif', '12345678904', 29, 4);
INSERT INTO Test VALUES (15, TO_DATE('2023-03-05', 'YYYY-MM-DD'), 'Test E', 'Pozitif', '12345678905', 30, 5);
INSERT INTO Test VALUES (16, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'Test A', 'Pozitif', '12345678901', 26, 1);
INSERT INTO Test VALUES (17, TO_DATE('2023-03-02', 'YYYY-MM-DD'), 'Test B', 'Negatif', '12345678902', 27, 2);
INSERT INTO Test VALUES (18, TO_DATE('2023-03-03', 'YYYY-MM-DD'), 'Test C', 'Pozitif', '12345678903', 28, 3);
INSERT INTO Test VALUES (19, TO_DATE('2023-03-04', 'YYYY-MM-DD'), 'Test D', 'Negatif', '12345678904', 29, 4);
INSERT INTO Test VALUES (20, TO_DATE('2023-03-05', 'YYYY-MM-DD'), 'Test E', 'Pozitif', '12345678905', 30, 5);

INSERT INTO Appointment VALUES (1, TO_DATE('2023-04-01', 'YYYY-MM-DD'), '08:00', 'completed', '12345678901', 1, 26);
INSERT INTO Appointment VALUES (2, TO_DATE('2023-04-02', 'YYYY-MM-DD'), '09:00', 'completed', '12345678902', 2, 27);
INSERT INTO Appointment VALUES (3, TO_DATE('2023-04-03', 'YYYY-MM-DD'), '10:00', 'completed', '12345678903', 3, 28);
INSERT INTO Appointment VALUES (4, TO_DATE('2023-04-04', 'YYYY-MM-DD'), '11:00', 'completed', '12345678904', 4, 29);
INSERT INTO Appointment VALUES (5, TO_DATE('2023-05-05', 'YYYY-MM-DD'), '11:00', 'completed', '12345678905', 5, 30);
INSERT INTO Appointment VALUES (6, TO_DATE('2023-04-01', 'YYYY-MM-DD'), '08:00', 'completed', '12345678901', 1, 26);
INSERT INTO Appointment VALUES (7, TO_DATE('2023-04-02', 'YYYY-MM-DD'), '09:00', 'completed', '12345678902', 2, 27);
INSERT INTO Appointment VALUES (8, TO_DATE('2023-04-03', 'YYYY-MM-DD'), '10:00', 'completed', '12345678903', 3, 28);
INSERT INTO Appointment VALUES (9, TO_DATE('2023-04-04', 'YYYY-MM-DD'), '11:00', 'completed', '12345678904', 4, 29);
INSERT INTO Appointment VALUES (10, TO_DATE('2023-05-05', 'YYYY-MM-DD'), '11:00', 'completed', '12345678905', 5, 30);
INSERT INTO Appointment VALUES (11, TO_DATE('2023-04-01', 'YYYY-MM-DD'), '08:00', 'completed', '12345678901', 1, 26);
INSERT INTO Appointment VALUES (12, TO_DATE('2023-04-02', 'YYYY-MM-DD'), '09:00', 'completed', '12345678902', 2, 27);
INSERT INTO Appointment VALUES (13, TO_DATE('2023-04-03', 'YYYY-MM-DD'), '10:00', 'completed', '12345678903', 3, 28);
INSERT INTO Appointment VALUES (14, TO_DATE('2023-04-04', 'YYYY-MM-DD'), '11:00', 'completed', '12345678904', 4, 29);
INSERT INTO Appointment VALUES (15, TO_DATE('2023-05-05', 'YYYY-MM-DD'), '11:00', 'completed', '12345678905', 5, 30);
INSERT INTO Appointment VALUES (16, TO_DATE('2023-04-01', 'YYYY-MM-DD'), '08:00', 'scheduled', '12345678901', 1, 26);
INSERT INTO Appointment VALUES (17, TO_DATE('2023-04-02', 'YYYY-MM-DD'), '09:00', 'scheduled', '12345678902', 2, 27);
INSERT INTO Appointment VALUES (18, TO_DATE('2023-04-03', 'YYYY-MM-DD'), '10:00', 'completed', '12345678903', 3, 28);
INSERT INTO Appointment VALUES (19, TO_DATE('2023-04-04', 'YYYY-MM-DD'), '11:00', 'completed', '12345678904', 4, 29);
INSERT INTO Appointment VALUES (20, TO_DATE('2023-05-05', 'YYYY-MM-DD'), '11:00', 'scheduled', '12345678905', 5, 30);

INSERT INTO Price VALUES (1, 'Appointment', 500);
INSERT INTO Price VALUES (2, 'EKO', 300);
INSERT INTO Price VALUES (3, 'Blood Test', 200);
INSERT INTO Price VALUES (4, 'EKG', 400);
INSERT INTO Price VALUES (5, 'MR', 1500);
INSERT INTO Price VALUES (6, 'CT Scan', 300);
INSERT INTO Price VALUES (7, 'Endoscopy', 300);
INSERT INTO Price VALUES (8, 'Biopsy', 300);
INSERT INTO Price VALUES (9, 'Mammography ', 300);
INSERT INTO Price VALUES (10, 'Bone Density Scan', 300);
INSERT INTO Price VALUES (11, 'Spirometry ', 400);
INSERT INTO Price VALUES (12, 'Ultrasound', 500);
INSERT INTO Price VALUES (13, 'Echocardiogram', 500);
INSERT INTO Price VALUES (14, 'PET Scan', 900);
INSERT INTO Price VALUES (15, 'Colonoscopy', 3000);
INSERT INTO Price VALUES (16, 'Test A', 300);
INSERT INTO Price VALUES (17, 'Test B ', 400);
INSERT INTO Price VALUES (18, 'Test C', 500);
INSERT INTO Price VALUES (19, 'Test D', 500);
INSERT INTO Price VALUES (20, 'Test E', 900);
INSERT INTO Price VALUES (21, 'Test F', 300);
INSERT INTO Price VALUES (22, 'Test G ', 400);
INSERT INTO Price VALUES (23, 'Test H', 500);
INSERT INTO Price VALUES (24, 'Test J', 500);
INSERT INTO Price VALUES (25, 'Test K', 900);


CREATE OR REPLACE TRIGGER check_nurse_role
BEFORE INSERT ON Nurse
FOR EACH ROW
DECLARE
    v_role VARCHAR2(50);
BEGIN
    SELECT role INTO v_role FROM Staff WHERE ID = :NEW.staff_id;
    IF v_role != 'Nurse' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Staff role is not nurse for nurse table.');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER check_doctor_role
BEFORE INSERT ON Doctor
FOR EACH ROW
DECLARE
    v_role VARCHAR2(50);
BEGIN
    SELECT role INTO v_role FROM Staff WHERE ID = :NEW.staff_id;
    IF v_role != 'Doctor' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Staff role is not doctor for doctor table.');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER check_secretary_role
BEFORE INSERT ON Secretary
FOR EACH ROW
DECLARE
    v_role VARCHAR2(50);
BEGIN
    SELECT role INTO v_role FROM Staff WHERE ID = :NEW.staff_id;
    IF v_role != 'Secretary' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Staff role is not secretary for secretary table.');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER check_laborant_role
BEFORE INSERT ON Laborant
FOR EACH ROW
DECLARE
    v_role VARCHAR2(50);
BEGIN
    SELECT role INTO v_role FROM Staff WHERE ID = :NEW.staff_id;
    IF v_role != 'Laborant' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Staff role is not laborant for laborant table.');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER check_administrator_role
BEFORE INSERT ON Administrators
FOR EACH ROW
DECLARE
    v_role VARCHAR2(50);
BEGIN
    SELECT role INTO v_role FROM Staff WHERE ID = :NEW.staff_id;
    IF v_role != 'Administrator' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Staff role is not administrator for administrators table.');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER decrease_medicine_stock
AFTER INSERT ON Prescription
FOR EACH ROW
DECLARE
    v_stock INT;
BEGIN
    SELECT stock INTO v_stock FROM Medicine WHERE ID = :NEW.medicine_ID;
    IF v_stock > 0 THEN
        UPDATE Medicine
        SET stock = stock - 1
        WHERE ID = :NEW.medicine_ID;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock for Medicine ID: ' || :NEW.medicine_ID);
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_update_bill_appointment
AFTER INSERT ON Appointment
FOR EACH ROW
DECLARE
    appointment_price NUMBER(10,2);
    bill_status VARCHAR2(50);
    insurance_status CHAR(1);
BEGIN
    SELECT P.amount INTO appointment_price
    FROM Price P
    WHERE P.service_description = 'Appointment';

    SELECT B.status, P.insurance INTO bill_status, insurance_status
    FROM Bill B, Patient P
    WHERE B.patient_soc_sec_no = :NEW.patient_soc_sec_no
    AND P.soc_sec_no = :NEW.patient_soc_sec_no;

    IF bill_status = 'ongoing' THEN
        IF insurance_status = 'Y' THEN
            appointment_price := appointment_price * 0.8;
        END IF;
        UPDATE Bill
        SET total = total + appointment_price
        WHERE patient_soc_sec_no = :NEW.patient_soc_sec_no;
    ELSIF bill_status = 'completed' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Bill not found.');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_update_bill_test
AFTER INSERT ON Test
FOR EACH ROW
DECLARE
    test_price NUMBER(10,2);
    bill_status VARCHAR2(50);
    insurance_status CHAR(1);
BEGIN
    SELECT P.amount INTO test_price
    FROM Price P
    WHERE P.service_description = :NEW.name;

    SELECT B.status, P.insurance INTO bill_status, insurance_status
    FROM Bill B, Patient P
    WHERE B.patient_soc_sec_no = :NEW.patient_soc_sec_no
    AND P.soc_sec_no = :NEW.patient_soc_sec_no;

    IF bill_status = 'ongoing' THEN
        IF insurance_status = 'Y' THEN
            test_price := test_price * 0.8;
        END IF;
        UPDATE Bill
        SET total = total + test_price
        WHERE patient_soc_sec_no = :NEW.patient_soc_sec_no;
    ELSIF bill_status = 'completed' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Bill not Found.');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_update_bill_treatment
AFTER INSERT ON Treatment
FOR EACH ROW
DECLARE
    treatment_price NUMBER(10,2);
    bill_status VARCHAR2(50);
    insurance_status CHAR(1);
BEGIN
    SELECT P.amount INTO treatment_price
    FROM Price P
    WHERE P.service_description = :NEW.name;

    SELECT B.status, P.insurance INTO bill_status, insurance_status
    FROM Bill B
    JOIN Patient P ON B.patient_soc_sec_no = P.soc_sec_no
    WHERE B.patient_soc_sec_no = :NEW.patient_soc_sec_no
    AND B.status = 'ongoing'
    ORDER BY B.datetime DESC
    FETCH FIRST 1 ROW ONLY;

    IF bill_status = 'ongoing' THEN
        IF insurance_status = 'Y' THEN
            treatment_price := treatment_price * 0.8;
        END IF;
        UPDATE Bill
        SET total = total + treatment_price
        WHERE patient_soc_sec_no = :NEW.patient_soc_sec_no;
    ELSIF bill_status = 'completed' THEN
        RAISE_APPLICATION_ERROR(-20003, 'Bill not Found.');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_assign_room_treatment
AFTER INSERT ON Treatment
FOR EACH ROW
DECLARE
    available_room_id NUMBER(10);
    room_capacity NUMBER(5);
    current_patient_count NUMBER(5);
BEGIN
    IF :NEW.admission_days != 0 THEN
        BEGIN
            SELECT ID, max_capacity, current_patient_count INTO available_room_id, room_capacity, current_patient_count
            FROM Room
            WHERE current_patient_count < max_capacity AND availability = 'Y'
            AND ROWNUM = 1;

            UPDATE Patient SET 
                room_id = available_room_id,
                discharge_date = SYSDATE + :NEW.admission_days
            WHERE soc_sec_no = :NEW.patient_soc_sec_no;

            UPDATE Room SET 
                current_patient_count = current_patient_count + 1
            WHERE ID = available_room_id;

            IF current_patient_count + 1 = room_capacity THEN
                UPDATE Room SET availability = 'N'
                WHERE ID = available_room_id;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20004, 'No available room for the treatment.');
        END;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_update_room_count
AFTER UPDATE OF room_id ON Patient
FOR EACH ROW
WHEN (OLD.room_id IS NOT NULL AND NEW.room_id IS NULL)
BEGIN
    UPDATE Room
    SET current_patient_count = current_patient_count - 1
    WHERE ID = :OLD.room_id;
END;
/
