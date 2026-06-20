# Product Safety and Inspection Management System

## Project Overview
This project simulates a product safety and regulatory monitoring database system using PostgreSQL. The database stores information about products, categories, inspections, certifications, and recalls.

---

## Dataset Description

### Tables Used

1. categories
2. products
3. inspections
4. certifications
5. recalls

---

## Data Dictionary

### categories

| Column | Description |
|---|---|
| category_id | Unique category ID |
| category_name | Name of category |

### products

| Column | Description |
|---|---|
| product_id | Unique product ID |
| product_name | Name of product |
| manufacturer | Product manufacturer |
| barcode | Product barcode |
| category_id | Product category ID |
| category_name | Product category |
| expiry_date | Product expiry date |
| certification_label | Certification availability |
| description | Product description |

### inspections

| Column | Description |
|---|---|
| inspection_id | Unique inspection ID |
| product_id | Product inspected |
| inspection_date | Date of inspection |
| result | Pass or fail |
| failure_reason | Reason for failure |
| notes | Inspection notes |

### certifications

| Column | Description |
|---|---|
| certification_id | Unique certification ID |
| product_id | Certified product |
| certification_status | Certification status |
| expiry_date | Certification expiry |
| authority | Certifying authority |
| notes | Additional notes |

### recalls

| Column | Description |
|---|---|
| recall_id | Unique recall ID |
| product_id | Recalled product |
| recall_date | Recall date |
| reason | Recall reason |
| severity | Recall severity |
| description | Recall description |

---

## Allowed Values

- inspection result = pass/fail
- recall severity = high/medium
- certification_status = certified/expired/non-compliant

---

## PostgreSQL Setup

### Create Database

```sql
CREATE DATABASE product_safety_db;