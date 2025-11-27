DECLARE
    -- Initialize our empty "Truck" (Collection)
    v_my_patients hospital_pkg.t_patient_tab := hospital_pkg.t_patient_tab();
    v_count NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- STARTING TEST ---');

    -- 1. PREPARE BULK DATA
    -- We extend the collection (make space) and add data to memory
    -- And we add the test data  
    v_my_patients.EXTEND(3); -- Make space for 3 patients
    
    v_my_patients(1).p_id := 101;
    v_my_patients(1).p_name := 'John Doe';
    v_my_patients(1).p_age := 30;
    v_my_patients(1).p_gender := 'Male';
    v_my_patients(1).p_status := 'NO';

    v_my_patients(2).p_id := 102;
    v_my_patients(2).p_name := 'Jane Smith';
    v_my_patients(2).p_age := 25;
    v_my_patients(2).p_gender := 'Female';
    v_my_patients(2).p_status := 'NO';

    v_my_patients(3).p_id := 103;
    v_my_patients(3).p_name := 'Alice Brown';
    v_my_patients(3).p_age := 50;
    v_my_patients(3).p_gender := 'Female';
    v_my_patients(3).p_status := 'NO';

    -- 2. CALLING THE BULK LOAD PROCEDURE
    hospital_pkg.bulk_load_patients(v_my_patients);

    -- 3. ADMITING ONE PATIENT
    hospital_pkg.admit_patient(102); -- Admit Jane

    -- 4. CHECKING THE COUNT FOR ADMITTED PATIENTS
    v_count := hospital_pkg.count_admitted();
    DBMS_OUTPUT.PUT_LINE('Number of Admitted Patients: ' || v_count);
    
    DBMS_OUTPUT.PUT_LINE('--- TEST COMPLETE ---');
END;
/
--VERIFYING WHETHER THE PATIENTS HAVE BEEN CORRECTLY INSERTED
select * from PATIENTS;

-- Running this variable declaration first
VARIABLE rc REFCURSOR;

-- Executing the block to fill the cursor
BEGIN
    :rc := hospital_pkg.show_all_patients();
END;
/

-- Printing the cursor contents
-- It will display all the patients since that was the intention of this function through this cursor
PRINT rc;
