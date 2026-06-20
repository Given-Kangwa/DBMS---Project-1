CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    manufacturer VARCHAR(255),
    barcode VARCHAR(50),
    category_id INT,
    category_name VARCHAR(100),
    expiry_date DATE,
    certification_label VARCHAR(50),
    description TEXT,

    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
);

CREATE TABLE inspections (
    inspection_id INT PRIMARY KEY,
    product_id INT,
    inspection_date DATE,
    result VARCHAR(20),
    failure_reason TEXT,
    notes TEXT,

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

CREATE TABLE certifications (
    certification_id INT PRIMARY KEY,
    product_id INT,
    certification_status VARCHAR(50),
    expiry_date DATE,
    authority VARCHAR(255),
    notes TEXT,

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

CREATE TABLE recalls (
    recall_id INT PRIMARY KEY,
    product_id INT,
    recall_date DATE,
    reason TEXT,
    severity VARCHAR(20),
    description TEXT,

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);