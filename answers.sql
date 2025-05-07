-- Question 1: Transform ProductDetail table into 1NF by splitting Products into individual rows
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.num), ',', -1)) AS Product
FROM ProductDetail
CROSS JOIN (
    SELECT a.N + b.N * 10 + 1 AS num
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    HAVING num <= 1 + (LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')))
) n
WHERE TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.num), ',', -1)) != '';

-- Question 2: Transform OrderDetails table into 2NF by removing partial dependencies
-- Step 1: Create OrderCustomers table to store unique OrderID and CustomerName
CREATE TABLE OrderCustomers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

-- Step 2: Insert unique OrderID and CustomerName pairs
INSERT INTO OrderCustomers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create OrderDetails_2NF table with full dependency on composite key
CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES OrderCustomers(OrderID)
);

-- Step 4: Insert data into OrderDetails_2NF
INSERT INTO OrderDetails_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;