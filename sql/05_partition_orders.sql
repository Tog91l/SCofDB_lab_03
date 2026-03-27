\timing on
\echo '=== PARTITION ORDERS BY DATE ==='

-- ============================================
-- TODO: Реализуйте партиционирование orders по дате
-- ============================================

-- Вариант A (рекомендуется): RANGE по created_at (месяц/квартал)
-- Вариант B: альтернативная разумная стратегия

-- Шаг 1: Подготовка структуры
-- TODO:
-- - создайте partitioned table (или shadow-таблицу для безопасной миграции)
-- - определите partition key = created_at

-- Шаг 2: Создание партиций
-- TODO:
-- - создайте набор партиций по диапазонам дат
-- - добавьте DEFAULT partition (опционально)

-- Шаг 3: Перенос данных
-- TODO:
-- - перенесите данные из исходной таблицы
-- - проверьте количество строк до/после

-- Шаг 4: Индексы на партиционированной таблице
-- TODO:
-- - создайте нужные индексы (если требуется)

-- Шаг 5: Проверка
-- TODO:
-- - ANALYZE
-- - проверка partition pruning на запросах по диапазону дат

CREATE TABLE orders_new (
    id UUID,
    user_id UUID,
    status TEXT,
    total_amount DECIMAL(12,2),
    created_at TIMESTAMP
) PARTITION BY RANGE (created_at);

CREATE TABLE orders_2024_06_09 PARTITION OF orders_new
FOR VALUES FROM ('2024-06-01') TO ('2024-09-01');

CREATE TABLE orders_2024_01_06 PARTITION OF orders_new
FOR VALUES FROM ('2024-01-01') TO ('2024-06-01');

CREATE TABLE orders_2024_09_2025 PARTITION OF orders_new
FOR VALUES FROM ('2024-09-01') TO ('2025-01-01');

CREATE TABLE orders_2025_01_06 PARTITION OF orders_new
FOR VALUES FROM ('2025-01-01') TO ('2025-06-01');

CREATE TABLE orders_2025_06_09 PARTITION OF orders_new
FOR VALUES FROM ('2025-06-01') TO ('2025-09-01');

CREATE TABLE orders_2025_09_2026 PARTITION OF orders_new
FOR VALUES FROM ('2025-09-01') TO ('2026-01-01');

CREATE TABLE orders_default PARTITION OF orders_new DEFAULT;

INSERT INTO orders_new
SELECT id, user_id, status, total_amount, created_at FROM orders;


CREATE INDEX idx_orders_status_created_at ON orders_new (status, created_at);
CREATE INDEX idx_orders_total_am_created_at ON orders_new (total_amount, created_at DESC);

ANALYZE orders_new;

-- орирг запрос 
EXPLAIN(ANALYZE, BUFFERS)
SELECT id, user_id , total_amount, created_at 
FROM orders 
WHERE status = 'paid' AND created_at >= '2025-08-01' AND created_at < '2025-12-31'
ORDER BY created_at;

-- с парацией 
EXPLAIN(ANALYZE, BUFFERS)
SELECT id, user_id , total_amount, created_at 
FROM orders_new
WHERE status = 'paid' AND created_at >= '2025-08-01' AND created_at < '2025-12-31'
ORDER BY created_at;
