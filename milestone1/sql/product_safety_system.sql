--each product belongs to one category and this table stores the categories 
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,  --setting a unique identifier for each category
    category_name VARCHAR(100) UNIQUE NOT NULL --each category must be unique and does not allo nulls 
);
--this table stores all products being tracked and each product is linked to a category
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY, --setting a unique identifier for each product
    product_name VARCHAR(255) NOT NULL, 
    category_id INT, --foreign key linking this table to the category table
    FOREIGN KEY (category_id) REFERENCES categories(category_id) 
);

CREATE TABLE inspections ( --this table stores inspection records for each product 
    inspection_id SERIAL PRIMARY KEY, --setting a unique identifier 
    product_id INT, --linking the inspection table to the product table 
    inspection_date DATE NOT NULL,
    result VARCHAR(10) CHECK (result IN ('Pass', 'Fail')), --sets a domain for the result value
    failure_reason TEXT, --this is the reason for failure is a product does not pass inspection
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE certifications ( --this table stores the certification status of products(each product oly requires one certification record)
    certification_id SERIAL PRIMARY KEY, --setting a unique identifier for this table
    product_id INT UNIQUE, --this ensures one cetification per product
    certification_status VARCHAR(20) CHECK (certification_status IN ('Valid', 'Expired')), --
    expiry_date DATE, --setting the certification expiry date 
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE recalls (--this table stores product recalls and each product can have multiple recalls
    recall_id SERIAL PRIMARY KEY, --setting a unique recall record 
    product_id INT, -- links this table to the product table
    recall_date DATE,
    reason TEXT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
