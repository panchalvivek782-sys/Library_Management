CREATE DATABASE library_management;
USE library_management;

CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255)
);

CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT,
    category VARCHAR(100),
    isbn VARCHAR(20),
    published_date DATE,
    price DECIMAL(10, 2),
    available_copies INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE SET NULL
);

CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(20),
    membership_date DATE
);

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    fine_amount DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE
);

INSERT INTO Authors (name, email) VALUES 
('Albert Einstein', 'einstein@example.com'),
('Isaac Newton', 'newton@example.com'),
('J.K. Rowling', 'rowling@example.com');

INSERT INTO Books (title, author_id, category, isbn, published_date, price, available_copies) VALUES 
('The World As I See It', 1, 'Science', '9780143039884', '2016-05-01', 450.00, 5),
('Principia Mathematica', 2, 'Science', '9781607962403', '1999-01-01', 650.00, 2),
('Harry Potter and the Philosophers Stone', 3, 'Fiction', '9780747532699', '1997-06-26', 350.00, 0);

INSERT INTO Members (name, email, phone_number, membership_date) VALUES 
('John Doe', 'john.doe@example.com', '1234567890', '2021-06-15'),
('Jane Smith', NULL, '9876543210', '2023-02-10'),
('Bob Johnson', 'bob.j@example.com', '5551234567', '2019-11-05');

INSERT INTO Transactions (member_id, book_id, borrow_date, return_date, fine_amount) VALUES 
(1, 1, '2026-05-10', '2026-05-20', 0.00),
(2, 1, '2026-09-01', '2026-09-15', 10.00),
(1, 2, '2026-10-01', NULL, 0.00);

UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = 1;
UPDATE Books SET available_copies = available_copies + 1 WHERE book_id = 1;

DELETE FROM Members 
WHERE member_id NOT IN (
    SELECT DISTINCT member_id 
    FROM Transactions 
    WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

SELECT * FROM Books WHERE available_copies > 0;

SELECT * FROM Books WHERE YEAR(published_date) > 2015;

SELECT * FROM Books ORDER BY price DESC LIMIT 5;

SELECT * FROM Members WHERE YEAR(membership_date) < 2022;

SELECT * FROM Books WHERE category = 'Science' AND price < 500;

SELECT * FROM Books WHERE available_copies = 0;

SELECT DISTINCT m.* 
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
WHERE YEAR(m.membership_date) > 2020 
OR m.member_id IN (
    SELECT member_id FROM Transactions GROUP BY member_id HAVING COUNT(transaction_id) > 3
);

SELECT * FROM Books ORDER BY title ASC;

SELECT m.member_id, m.name, COUNT(t.transaction_id) AS books_borrowed 
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name;

SELECT category, COUNT(*) AS total_books FROM Books GROUP BY category;

SELECT category, COUNT(*) AS total_books FROM Books GROUP BY category;

SELECT AVG(price) AS average_price FROM Books;

SELECT book_id, COUNT(*) AS borrow_count 
FROM Transactions 
GROUP BY book_id 
ORDER BY borrow_count DESC 
LIMIT 1;

SELECT SUM(fine_amount) AS total_fines FROM Transactions;

SELECT b.title, a.name AS author_name 
FROM Books b
INNER JOIN Authors a ON b.author_id = a.author_id;

SELECT m.*, t.transaction_id, t.borrow_date 
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id;

SELECT b.*, t.transaction_id 
FROM Transactions t
RIGHT JOIN Books b ON t.book_id = b.book_id
WHERE t.transaction_id IS NULL;

SELECT m.member_id, m.name, t.transaction_id 
FROM Members m 
LEFT JOIN Transactions t ON m.member_id = t.member_id
UNION
SELECT m.member_id, m.name, t.transaction_id 
FROM Members m 
RIGHT JOIN Transactions t ON m.member_id = t.member_id;

SELECT * FROM Books 
WHERE book_id IN (
    SELECT DISTINCT book_id 
    FROM Transactions 
    WHERE member_id IN (
        SELECT member_id FROM Members WHERE YEAR(membership_date) > 2022
    )
);

SELECT * FROM Books 
WHERE book_id = (
    SELECT book_id 
    FROM Transactions 
    GROUP BY book_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

SELECT * FROM Members 
WHERE member_id NOT IN (
    SELECT DISTINCT member_id FROM Transactions
);

SELECT YEAR(published_date) AS publication_year, COUNT(*) AS book_count 
FROM Books 
GROUP BY YEAR(published_date);

SELECT transaction_id, DATEDIFF(return_date, borrow_date) AS borrow_duration_days 
FROM Transactions 
WHERE return_date IS NOT NULL;

SELECT DATE_FORMAT(borrow_date, '%d-%m-%Y') AS formatted_borrow_date FROM Transactions;

SELECT UPPER(title) AS uppercase_title FROM Books;

SELECT TRIM(name) AS trimmed_author_name FROM Authors;

SELECT member_id, name, COALESCE(email, 'Not Provided') AS email FROM Members;

SELECT book_id, COUNT(*) AS borrow_count,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS book_rank
FROM Transactions
GROUP BY book_id;

SELECT member_id, borrow_date,
       COUNT(*) OVER (PARTITION BY member_id ORDER BY borrow_date) AS cumulative_books_borrowed
FROM Transactions;

SELECT borrow_date, COUNT(*) AS daily_borrows,
       AVG(COUNT(*)) OVER (ORDER BY borrow_date RANGE BETWEEN INTERVAL 3 MONTH PRECEDING AND CURRENT ROW) AS moving_average
FROM Transactions
GROUP BY borrow_date;

SELECT member_id, name,
       CASE 
           WHEN member_id IN (
               SELECT DISTINCT member_id 
               FROM Transactions 
               WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
           ) THEN 'Active'
           ELSE 'Inactive'
        'Museum'
       END AS Membership_Status
FROM Members;

SELECT title, published_date,
       CASE 
           WHEN YEAR(published_date) > 2020 THEN 'New Arrival'
           WHEN YEAR(published_date) < 2000 THEN 'Classic'
           ELSE 'Regular'
       END AS book_category
FROM Books;