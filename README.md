# PL/SQL Assignment Questions: Security Trigger & Package Implementation

**Group Name :** C

**Date :** 27-11-2025

## Group Members
1. Keza Shania - 25793
2. Ruterana Gloire - 27717
3. Ndayishimiye Ineza Giuly - 27390
4. Kasemire Asimwe Benie - 27530
5. [Name] - [ID]
6. [Name] - [ID]

---

## Task 1: Security Audit System

### Problem Description
The organization required a security system to monitor suspicious login behavior. The specific policy was to trigger an alert and send a notification if a user attempts to log in with incorrect credentials more than **two times** in the same day.

### Solution Approach
We implemented this using:
1.  **Database Tables:** Created `login_audit` to track attempts and `security_alerts` to store violations.
2.  **Compound Trigger:** We used a `FOR INSERT` Compound Trigger on the audit table. This was necessary to avoid the **Mutating Table Error (ORA-04091)**. The trigger captures the username at the *Row Level* and queries the failure count at the *Statement Level*.
3.  **Email Simulation:** A stored procedure `mock_send_email` outputs the alert details to the console using `DBMS_OUTPUT`.

### Results
**1. Triggering the Alert (DBMS Output):**
<img width="935" height="253" alt="Screenshot 2025-11-27 132143" src="https://github.com/user-attachments/assets/9d61d479-dcc8-4e93-8683-c7ccca3e0cd5" />


**2. Database Record of the Alert:**
<img width="1213" height="391" alt="Screenshot 2025-11-27 132114" src="https://github.com/user-attachments/assets/02beee7e-921e-4505-b22a-0208bc30883f" />

---

## Task 2: Hospital Management Package

### Problem Description
The goal was to streamline patient management using PL/SQL Packages. The requirements included bulk processing for data entry and using cursors to retrieve patient lists.

### Solution Approach
We created a package `hospital_pkg` containing:
1.  **Bulk Processing:** Used `FORALL` and `TYPE ... TABLE OF` collections to insert multiple patient records efficiently in a single batch.
2.  **RefCursors:** The function `show_all_patients` returns a `SYS_REFCURSOR`, allowing the client to fetch the result set dynamically.
3.  **Transaction Control:** Logic was separated into a **Specification** (Interface) and **Body** (Implementation).

### Results
**1. Bulk Loading Patients (Success Message):**

<img width="487" height="188" alt="Screenshot 2025-11-27 132650" src="https://github.com/user-attachments/assets/e72dada2-9d4a-4b23-8510-6183117b2114" />

**2. Patients created in the table:**

<img width="724" height="350" alt="Screenshot 2025-11-27 132611" src="https://github.com/user-attachments/assets/24373c04-42f3-450b-b818-a098c207e902" />


**2. Retrieving Patient List (RefCursor Result):**

<img width="1343" height="542" alt="Screenshot 2025-11-27 132803" src="https://github.com/user-attachments/assets/ff9ba888-8e07-454d-b40a-cdbaf7bae032" />
