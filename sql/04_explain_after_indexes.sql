\timing on
\echo '=== AFTER INDEXES ==='

SET max_parallel_workers_per_gather = 0;
SET work_mem = '32MB';
ANALYZE;

-- ============================================
-- TODO:
-- Скопируйте сюда ТО ЖЕ множество запросов из 02_explain_before.sql
-- и выполните EXPLAIN (ANALYZE, BUFFERS) повторно.
-- ============================================
--поиск дорогих заказов 
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, user_id, total_amount, created_at
FROM orders
WHERE total_amount > 10000
ORDER BY created_at DESC
LIMIT 20;

\echo '--- Q2: Фильтрация по статусу + диапазону дат ---'
-- TODO: Подставьте свой запрос
-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT ...
-- FROM orders
-- WHERE status = 'paid'
--   AND created_at >= ...
--   AND created_at < ...;
EXPLAIN(ANALYZE, BUFFERS)
SELECT id, user_id , total_amount, created_at 
FROM orders 
WHERE status = 'paid' AND created_at >= '2025-08-01' AND created_at < '2025-12-31'
ORDER BY created_at;

\echo '--- Q3: JOIN + GROUP BY ---'
-- TODO: Подставьте свой запрос
-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT ...
-- FROM orders o
-- JOIN order_items oi ON oi.order_id = o.id
-- WHERE ...
-- GROUP BY ...
-- ORDER BY ...
-- LIMIT ...;
EXPLAIN(ANALYZE, BUFFERS)
SELECT o.user_id, COUNT(*) AS orders_count, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
WHERE o.created_at >= '2025-01-01'
GROUP BY o.user_id
ORDER BY total_spent DESC
LIMIT 15;


-- (Опционально) Q4
-- TODO
