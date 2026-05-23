
SELECT pg_sleep(30);

CREATE TABLE test_lock (
id INT PRIMARY KEY,
name TEXT
);

INSERT INTO test_lock VALUES
(1, 'Priya'),
(2, 'Rahul');


BEGIN;

UPDATE test_lock
SET name = 'Locked User'
WHERE id = 1;

COMMIT;

DROP TABLE test_lock;

Select * from test_lock;

