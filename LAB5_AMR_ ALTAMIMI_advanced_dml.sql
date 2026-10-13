CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);

CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (regular_price > 0 AND discount_price > 0 AND discount_price < regular_price)
);

CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER CHECK (num_guests BETWEEN 1 AND 10),
    CHECK (check_out_date > check_in_date)
);

INSERT INTO employees VALUES (1, 'John', 'Doe', 30, 50000.00);
INSERT INTO employees VALUES (2, 'Jane', 'Smith', 45, 75000.50);
-- INSERT INTO employees VALUES (3, 'Bob', 'Brown', 17, 30000.00);
-- INSERT INTO employees VALUES (4, 'Alice', 'White', 25, -1000.00);

INSERT INTO products_catalog VALUES (1, 'Laptop', 1000.00, 800.00);
INSERT INTO products_catalog VALUES (2, 'Phone', 500.00, 450.00);
-- INSERT INTO products_catalog VALUES (3, 'Tablet', -200.00, 100.00);
-- INSERT INTO products_catalog VALUES (4, 'Monitor', 300.00, 350.00);

INSERT INTO bookings VALUES (1, '2026-06-01', '2026-06-07', 2);
INSERT INTO bookings VALUES (2, '2026-07-10', '2026-07-15', 4);
-- INSERT INTO bookings VALUES (3, '2026-08-01', '2026-08-01', 3);
-- INSERT INTO bookings VALUES (4, '2026-09-01', '2026-09-05', 15);

CREATE TABLE customers (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

INSERT INTO customers VALUES (1, 'alice@example.com', '555-0100', '2026-01-10');
INSERT INTO customers VALUES (2, 'bob@example.com', NULL, '2026-02-15');
-- INSERT INTO customers VALUES (NULL, 'charlie@example.com', '555-0200', '2026-03-01');
-- INSERT INTO customers VALUES (3, NULL, '555-0300', '2026-03-05');

INSERT INTO inventory VALUES (1, 'Widget A', 50, 19.99, CURRENT_TIMESTAMP);
INSERT INTO inventory VALUES (2, 'Widget B', 0, 5.49, CURRENT_TIMESTAMP);
-- INSERT INTO inventory VALUES (3, 'Widget C', -5, 10.00, CURRENT_TIMESTAMP);
-- INSERT INTO inventory VALUES (4, 'Widget D', 10, 0.00, CURRENT_TIMESTAMP);
-- INSERT INTO inventory VALUES (5, NULL, 10, 15.00, CURRENT_TIMESTAMP);

CREATE TABLE users (
    user_id INTEGER,
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    created_at TIMESTAMP
);

CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    UNIQUE (student_id, course_code, semester)
);

ALTER TABLE users DROP CONSTRAINT users_username_key;
ALTER TABLE users DROP CONSTRAINT users_email_key;
ALTER TABLE users ADD CONSTRAINT unique_username UNIQUE (username);
ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);

INSERT INTO users VALUES (1, 'johndoe', 'john@example.com', CURRENT_TIMESTAMP);
INSERT INTO users VALUES (2, 'janedoe', 'jane@example.com', CURRENT_TIMESTAMP);
-- INSERT INTO users VALUES (3, 'johndoe', 'other@example.com', CURRENT_TIMESTAMP);
-- INSERT INTO users VALUES (4, 'bobsmith', 'john@example.com', CURRENT_TIMESTAMP);

INSERT INTO course_enrollments VALUES (1, 101, 'CS101', 'Fall2026');
INSERT INTO course_enrollments VALUES (2, 101, 'MATH101', 'Fall2026');
-- INSERT INTO course_enrollments VALUES (3, 101, 'CS101', 'Fall2026');

CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

INSERT INTO departments VALUES (1, 'HR', 'Building A');
INSERT INTO departments VALUES (2, 'Engineering', 'Building B');
INSERT INTO departments VALUES (3, 'Sales', 'Building C');
-- INSERT INTO departments VALUES (1, 'Marketing', 'Building D');
-- INSERT INTO departments VALUES (NULL, 'Support', 'Building E');

CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO student_courses VALUES (1, 101, '2026-09-01', 'A');
INSERT INTO student_courses VALUES (1, 102, '2026-09-01', 'B');
INSERT INTO student_courses VALUES (2, 101, '2026-09-01', 'A');

CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);

INSERT INTO employees_dept VALUES (1, 'Alice Smith', 1, '2024-01-15');
INSERT INTO employees_dept VALUES (2, 'Bob Jones', 2, '2025-03-20');
-- INSERT INTO employees_dept VALUES (3, 'Charlie Brown', 99, '2026-05-10');

CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

INSERT INTO authors VALUES (1, 'J.K. Rowling', 'UK');
INSERT INTO authors VALUES (2, 'George Orwell', 'UK');

INSERT INTO publishers VALUES (1, 'Bloomsbury', 'London');
INSERT INTO publishers VALUES (2, 'Secker & Warburg', 'London');

INSERT INTO books VALUES (1, 'Harry Potter', 1, 1, 1997, '978-0747532699');
INSERT INTO books VALUES (2, '1984', 2, 2, 1949, '978-0451524935');

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);

INSERT INTO categories VALUES (1, 'Electronics');
INSERT INTO products_fk VALUES (1, 'Smartphone', 1);
INSERT INTO orders VALUES (100, '2026-10-01');
INSERT INTO order_items VALUES (1, 100, 1, 2);

-- DELETE FROM categories WHERE category_id = 1;
DELETE FROM orders WHERE order_id = 100;

CREATE TABLE e_customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE e_products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE e_orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES e_customers(customer_id) ON DELETE RESTRICT,
    order_date DATE NOT NULL,
    total_amount NUMERIC NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE e_order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES e_orders(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES e_products(product_id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price >= 0)
);

INSERT INTO e_customers VALUES (1, 'Alice Smith', 'alice@shop.com', '555-1000', '2026-01-01');
INSERT INTO e_customers VALUES (2, 'Bob Jones', 'bob@shop.com', '555-2000', '2026-01-05');
INSERT INTO e_customers VALUES (3, 'Charlie Brown', 'charlie@shop.com', '555-3000', '2026-02-10');
INSERT INTO e_customers VALUES (4, 'Diana Prince', 'diana@shop.com', '555-4000', '2026-03-12');
INSERT INTO e_customers VALUES (5, 'Evan Wright', 'evan@shop.com', '555-5000', '2026-04-20');

INSERT INTO e_products VALUES (1, 'Wireless Mouse', 'Ergonomic mouse', 25.99, 150);
INSERT INTO e_products VALUES (2, 'Mechanical Keyboard', 'RGB backlight', 89.99, 75);
INSERT INTO e_products VALUES (3, 'USB-C Hub', 'Multi-port adapter', 45.00, 200);
INSERT INTO e_products VALUES (4, 'Monitor 27"', '4K UHD display', 349.99, 30);
INSERT INTO e_products VALUES (5, 'Desk Lamp', 'LED adjustable lamp', 19.99, 100);

INSERT INTO e_orders VALUES (1, 1, '2026-10-01', 115.98, 'delivered');
INSERT INTO e_orders VALUES (2, 2, '2026-10-02', 349.99, 'shipped');
INSERT INTO e_orders VALUES (3, 3, '2026-10-03', 45.00, 'processing');
INSERT INTO e_orders VALUES (4, 4, '2026-10-04', 25.99, 'pending');
INSERT INTO e_orders VALUES (5, 5, '2026-10-05', 89.99, 'cancelled');

INSERT INTO e_order_details VALUES (1, 1, 1, 1, 25.99);
INSERT INTO e_order_details VALUES (2, 1, 3, 2, 45.00);
INSERT INTO e_order_details VALUES (3, 2, 4, 1, 349.99);
INSERT INTO e_order_details VALUES (4, 3, 3, 1, 45.00);
INSERT INTO e_order_details VALUES (5, 4, 1, 1, 25.99);

SELECT * FROM e_customers;
SELECT * FROM e_products;
SELECT * FROM e_orders;
SELECT * FROM e_order_details;
