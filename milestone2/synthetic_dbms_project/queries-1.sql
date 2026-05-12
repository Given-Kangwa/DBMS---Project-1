
--IMPORTING CSV TABLES IN pgAdmin4

\copy categories(category_id, category_name)
FROM 'C:/Users/User/Desktop/synthetic_dbms_project/categories.csv'
DELIMITER ','
CSV HEADER;

-- COUNTING  PRODUCTS IN EACH CATEGORIES AND ARRANGING ACCORDING TO THEIR INCREASING TOTAL;

SELECT category_name,
       COUNT (*) AS TOTAL_PRODUCTS
	   FROM PRODUCTS
	   GROUP BY CATEGORY_NAME
	   ORDER BY TOTAL_PRODUCTS DESC;

SELECT result,
       COUNT (*) AS TOTAL
	   FROM INSPECTIONS
	   GROUP BY result
	   ORDER BY TOTAL ASC;


SELECT category_NAME FROM CATEGORIES;

-- Joining PRODUCT TABLE and Inspections TABLE ON PRODUCT_ID

SELECT I.product_id,product_name,manufacturer,inspection_id,inspection_date,failure_reason,notes
FROM PRODUCTs p
JOIN INSPECTIONS i
ON p.PRODUCT_ID = i.PRODUCT_ID;

---SELECT * FROM PRODUCTS
--Join INSPECTION TABLE AND SEPCIFICATION TABLE ON PRODUCT_ID

SELECT certification_id,expiry_date,inspection_id,failure_reason
FROM INSPECTIONS i
join certifications c
ON i.product_id = c.product_id

-- : Products with above-average inspections #Subquery -1 

SELECT product_id,
       COUNT(*) AS total_inspections
FROM inspections
GROUP BY product_id
HAVING COUNT(*) >
(
    SELECT AVG(inspection_count)
    FROM
    (
        SELECT COUNT(*) AS inspection_count
        FROM inspections
        GROUP BY product_id
    ) AS inspection_avg
)
ORDER BY total_inspections DESC;

-- -- Query 6: Products with recalls # Subquery 2

-- PRODUCTS WITH RECALLS

SELECT p.PRODUCT_ID,manufacturer,PRODUCT_NAME,RECALL_ID, r.DESCRIPTION
FROM PRODUCTS p 
JOIN RECALLS r
ON p.PRODUCT_ID = r.Product_id

-- Query 7: Products with passed inspections using CTE

WITH passed_products AS
(SELECT p.product_id,
           product_name,
           category_name,
           result,
           notes
    FROM products p
    JOIN inspections i
    ON i.product_id = p.product_id
    WHERE i.result = 'pass')
SELECT *
FROM passed_products;

-- Query 8: Certified products using CTE

WITH certified_products AS
(
    SELECT p.product_id,
           product_name,
           certification_status,
           authority
    FROM products p
    JOIN certifications c
    ON p.product_id = c.product_id
    WHERE certification_status = 'certified'
)
SELECT *
FROM certified_products;


-- Query 9: Rank products by inspection count

SELECT product_id,
       COUNT(*) AS total_inspections,

       RANK() OVER
       (
           ORDER BY COUNT(*) DESC
       ) AS inspection_rank

FROM inspections
GROUP BY product_id;

-- Query 10: Latest inspection for each product

SELECT *
FROM
(
    SELECT inspection_id,
           product_id,
           inspection_date,
           result,

           ROW_NUMBER() OVER
           (
               PARTITION BY product_id
               ORDER BY inspection_date DESC
           ) AS row_num

    FROM inspections
) latest_inspections

WHERE row_num = 1;
