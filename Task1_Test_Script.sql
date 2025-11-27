--Test rows inserted in the tables to verify the trigger's activation

-- 1. Fail once (No output)
INSERT INTO login_audit (username, status) VALUES ('SimUser', 'FAILED');

-- 2. Fail twice (No output)
INSERT INTO login_audit (username, status) VALUES ('SimUser', 'FAILED');

-- 3. Fail third time (WATCH THE DBMS OUTPUT WINDOW)
INSERT INTO login_audit (username, status) VALUES ('SimUser', 'FAILED');


-- Check the Audit Trail
SELECT * FROM login_audit WHERE username = 'Hacker_Bob';

-- Check the Alerts (We should see one row here)
SELECT * FROM security_alerts WHERE username = 'SimUser';
