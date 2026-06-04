-- Performance Analysis and Optimization for DBMS Project

--check the time taken for the original query without indexes
EXPLAIN ANALYZE
SELECT I.product_id,
       product_name,
       manufacturer,
       inspection_id,
       inspection_date,
       failure_reason,
       notes
FROM products p
JOIN inspections i
ON p.product_id = i.product_id;


-- index on product_id in inspections table to optimize the join
CREATE INDEX idx_product_id 
ON inspections(product_id);


-- check the time taken for the query after creating the index
EXPLAIN ANALYZE
SELECT I.product_id,
       product_name,
       manufacturer,
       inspection_id,
       inspection_date,
       failure_reason,
       notes
FROM products p
JOIN inspections i
ON p.product_id = i.product_id;

-- check the time taken for the original query without indexes
EXPLAIN ANALYZE
SELECT product_id,
       COUNT(*) AS total_inspections,

       RANK() OVER
       (
           ORDER BY COUNT(*) DESC
       ) AS inspection_rank

FROM inspections
GROUP BY product_id;

-- index on product_id in inspections table to optimize the aggregation and ranking
CREATE INDEX idx_inspections_product_rank
ON inspections(product_id);

-- check the time taken for the query after creating the index
EXPLAIN ANALYZE
SELECT product_id,
       COUNT(*) AS total_inspections,

       RANK() OVER
       (
           ORDER BY COUNT(*) DESC
       ) AS inspection_rank

FROM inspections
GROUP BY product_id;

-- check the time taken for the original query without indexes
EXPLAIN ANALYZE
SELECT certification_id,
       expiry_date,
       inspection_id,
       failure_reason
FROM inspections i
JOIN certifications c
ON i.product_id = c.product_id;

-- index on product_id in certifications table to optimize the join
CREATE INDEX idx_certifications_product
ON certifications(product_id);

-- check the time taken for the query after creating the index
EXPLAIN ANALYZE
SELECT certification_id,
       expiry_date,
       inspection_id,
       failure_reason
FROM inspections i
JOIN certifications c
ON i.product_id = c.product_id;


-- Trigger to log recalls
CREATE TABLE recall_log (
    log_id SERIAL PRIMARY KEY,
    recall_id INT,
    product_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger function to log recall inserts
CREATE OR REPLACE FUNCTION log_recall_insert()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO recall_log(
        recall_id,
        product_id
    )
    VALUES(
        NEW.recall_id,
        NEW.product_id
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Create the trigger.
CREATE TRIGGER trg_recall_log
AFTER INSERT ON recalls
FOR EACH ROW
EXECUTE FUNCTION log_recall_insert();

-- Query to check the information schema for the recalls table
SELECT column_name,
       data_type,
       is_nullable
FROM information_schema.columns
WHERE table_name = 'recalls';

--select the max recall_id to determine the next recall_id for testing the trigger
SELECT MAX(recall_id) FROM recalls;

-- Insert a new recall to test the trigger
INSERT INTO recalls(
    recall_id,
    product_id,
    recall_date,
    reason,
    severity,
    description
)
VALUES(
    298,
    1,
    CURRENT_DATE,
    'Testing Trigger',
    'high',
    'Trigger demonstration'
);
--check the recall_log to see if the trigger worked
SELECT * FROM recall_log
ORDER BY recall_id DESC;

--checking the recalls table to see if the new recall was inserted
SELECT * 
FROM recalls
WHERE recall_id = 298;