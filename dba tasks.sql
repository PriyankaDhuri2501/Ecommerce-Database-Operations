
EXPLAIN ANALYZE 
SELECT *
FROM customers 
WHERE customer_city = 'sao paulo';

CREATE INDEX indx_city
ON customers(customer_city);

EXPLAIN ANALYZE 
SELECT *
FROM customers 
WHERE customer_city = 'sao paulo';

--All data of processes
SELECT *
FROM pg_stat_activity;

--Active processes
SELECT pid, usename, state, query
FROM pg_stat_activity
WHERE state = 'active';

--Idle sessions
SELECT pid, usename, state, query
FROM pg_stat_activity
WHERE state = 'idle';

--Active sessions duration
SELECT pid, now() - query_start AS duration, 
query 
FROM pg_stat_activity
WHERE state = 'active';

--kill process
SELECT pg_terminate_backend(19216);

-- total database connections
SELECT count(*)
FROM pg_stat_activity;

--count of active connections
SELECT count(*)
FROM pg_stat_activity
WHERE state = 'active';

--count of Idle sessions
SELECT count(*)
FROM pg_stat_activity
WHERE state = 'idle';

SELECT 
blocked.pid,
blocking.pid,
blocked.query,
blocking.query
FROM pg_stat_activity blocked 
JOIN pg_stat_activity blocking
ON blocking.pid = ANY(pg_blocking_pids(blocked.pid));

--database size 
SELECT pg_size_pretty(
pg_database_size('company_db')
);

--table size
SELECT
relname,
pg_size_pretty(pg_total_relation_size(relid))
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

--database names 
SELECT datname
FROM pg_database;

--Tables index
SELECT *
FROM pg_indexes
WHERE tablename='customers';

--user-created tables 
SELECT tablename
FROM pg_tables
WHERE schemaname='public';

SELECT *
FROM pg_locks;

--remove dead rows data
VACUUM ANALYZE test_lock;

CREATE USER analyst 
WITH PASSWORD 'AN123' ;

CREATE USER user2
WITH PASSWORD 'user@2' ;

GRANT CONNECT 
ON DATABASE company_db
TO analyst;


GRANT SELECT 
ON orders
TO analyst;

GRANT USAGE 
ON SCHEMA PUBLIC 
TO analyst;

REVOKE CONNECT 
ON DATABASE company_db
FROM analyst;

REVOKE USAGE 
ON SCHEMA PUBLIC 
FROM analyst;


SELECT * 
FROM information_schema.role_table_grants
WHERE grantee='user2';