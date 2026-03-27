\timing on
\echo '=== APPLY INDEXES ==='

-- ============================================
-- TODO: Создайте индексы на основе ваших EXPLAIN ANALYZE
-- ============================================

-- Индекс 1
-- TODO:
-- CREATE INDEX ... ON ... USING BTREE (...);
-- Обоснование:
-- - какой запрос ускоряет
-- - почему выбран именно этот тип индекса
CREATE INDEX idx_order_tot_am_created_at 
ON  orders USING BTREE(total_amount, created_at DESC);
-- ускорит фильтр и сортировку 

-- Индекс 2
-- TODO:
-- CREATE INDEX ... ON ... USING ... (...);
-- Обоснование:
-- - какой запрос ускоряет
-- - почему выбран именно этот тип индекса
CREATE INDEX idx_stat_created_at 
ON orders USING BTREE(status, created_at );
-- быстрее ищет статус paid и ускоряет сортировки по диапозону даты

-- Индекс 3
-- TODO:
-- CREATE INDEX ... ON ... USING ... (...);
-- Обоснование:
-- - какой запрос ускоряет
-- - почему выбран именно этот тип индекса
CREATE INDEX idx_order_oritem_join
ON order_items USING BTREE(order_id)
-- быстрее объединение будет 
-- (Опционально) Частичный индекс / BRIN / составной индекс
-- TODO

-- Не забудьте обновить статистику после создания индексов
-- TODO:
-- ANALYZE;

