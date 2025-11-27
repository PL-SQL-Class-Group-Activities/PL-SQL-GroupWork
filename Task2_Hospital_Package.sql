-- 1. Created Doctors Table
CREATE TABLE doctors (
    doctor_id NUMBER PRIMARY KEY,
    name      VARCHAR2(100),
    specialty VARCHAR2(50)
);

-- 2. Created Patients Table
CREATE TABLE patients (
    patient_id      NUMBER PRIMARY KEY,
    name            VARCHAR2(100),
    age             NUMBER,
    gender          VARCHAR2(10),
    admitted_status VARCHAR2(20) DEFAULT 'NOT ADMITTED' -- Default status
);

--We create both the package spec and body
CREATE OR REPLACE PACKAGE hospital_pkg AS

    -- DEFINING TYPES FOR BULK PROCESSING
    -- 1. Create a Record Type that matches the Patient table structure
    TYPE t_patient_rec IS RECORD (
        p_id     patients.patient_id%TYPE,
        p_name   patients.name%TYPE,
        p_age    patients.age%TYPE,
        p_gender patients.gender%TYPE,
        p_status patients.admitted_status%TYPE
    );

    -- 2. Create a Collection (Nested Table) of that Record Type
    -- This is the "Truck" that will hold multiple records
    TYPE t_patient_tab IS TABLE OF t_patient_rec;

    -- PROCEDURES AND FUNCTIONS
    
    -- Procedure to load many patients at once
    PROCEDURE bulk_load_patients(p_patients_list t_patient_tab);

    -- Function to get a cursor of all patients
    FUNCTION show_all_patients RETURN SYS_REFCURSOR;

    -- Function to count how many are admitted
    FUNCTION count_admitted RETURN NUMBER;

    -- Procedure to admit a single patient
    PROCEDURE admit_patient(p_id NUMBER);

END hospital_pkg;
/

CREATE OR REPLACE PACKAGE BODY hospital_pkg AS

    -- 1. BULK LOAD PATIENTS (Using FORALL)
    PROCEDURE bulk_load_patients(p_patients_list t_patient_tab) IS
    BEGIN
        -- FORALL is not a loop; it is a bulk command.
        -- It says: "Take everything from index 1 to the end, and do this SQL statement."
        FORALL i IN 1 .. p_patients_list.COUNT
            INSERT INTO patients (patient_id, name, age, gender, admitted_status)
            VALUES (
                p_patients_list(i).p_id,
                p_patients_list(i).p_name,
                p_patients_list(i).p_age,
                p_patients_list(i).p_gender,
                p_patients_list(i).p_status
            );
            
        -- Commit the changes to save them
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Bulk load completed. ' || SQL%ROWCOUNT || ' rows inserted.');
    END bulk_load_patients;


    -- 2. SHOW ALL PATIENTS
    FUNCTION show_all_patients RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM patients ORDER BY patient_id;
        RETURN v_cursor;
    END show_all_patients;


    -- 3. COUNT ADMITTED PATIENTS
    FUNCTION count_admitted RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM patients
        WHERE admitted_status = 'ADMITTED';
        
        RETURN v_count;
    END count_admitted;


    -- 4. ADMIT A PATIENT
    PROCEDURE admit_patient(p_id NUMBER) IS
    BEGIN
        UPDATE patients
        SET admitted_status = 'ADMITTED'
        WHERE patient_id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             DBMS_OUTPUT.PUT_LINE('Patient ID ' || p_id || ' not found.');
        ELSE
             DBMS_OUTPUT.PUT_LINE('Patient ' || p_id || ' status updated to ADMITTED.');
             COMMIT;
        END IF;
    END admit_patient;

END hospital_pkg;
/
