-- First Exercise 
-- Task 1

CREATE VIEW `OrdersView` 
AS
SELECT OrderID, Quantity, TotalCost
FROM `orders`;


SELECT * FROM `OrdersView`;


-- Task 2

SELECT `customers`.`CustomerID`,
    `customers`.`FullName`,
    `orders`.`OrderID`,
    `orders`.`TotalCost`,
    `menus`.`MenuName`,
    `menuitems`.`CourseName`
FROM `customers`
LEFT JOIN `orders` ON `orders`.`CustomerID` = `customers`.`CustomerID`
LEFT JOIN `menus` ON `menus`.`MenuID` = `orders`.`MenuID`
LEFT JOIN `menuitems` ON `menuitems`.`MenuID` = `menus`.`MenuID`
WHERE `orders`.`TotalCost` > 150;


-- Task 3

SELECT DISTINCT `menus`.`MenuName`
FROM `orders`
LEFT JOIN `menus` ON `menus`.`MenuID` = `orders`.`MenuID`
WHERE `orders`.`Quantity` > 2;
-- OR
SELECT DISTINCT `MenuName`
FROM `menus`
WHERE `MenuID` = ANY (
    SELECT DISTINCT `MenuID`
    FROM `orders`
    WHERE `Quantity` > 2
);

-- Second Exercise
-- Task 1

DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(`Quantity`) AS `Max Quantity in Order`
    FROM `orders`;
END//
DELIMITER ;

CALL GetMaxQuantity();


-- Task 2

PREPARE GetOrderDetail 
FROM 'SELECT OrderID, Quantity, TotalCost 
FROM orders 
WHERE CustomerID = ?';

SET @CustID = 22;
EXECUTE GetOrderDetail USING @CustID;


-- Task 3

DELIMITER //
CREATE PROCEDURE CancelOrder (IN IDofOrder INT)
BEGIN
    DELETE FROM `orders`
    WHERE `OrderID` = IDofOrder;

    SELECT CONCAT('Order ', IDofOrder, ' is cancelled') AS `Confirmation`;
END//
DELIMITER ;

CALL CancelOrder(1105);


-- Third Exercise
-- Task 1

INSERT INTO `bookings` (`BookingID`, `BookingDate`, `TableNumber`, `CustomerID`)
VALUES
('1','2022-10-10','5','1'),
('2','2022-11-12','3','3'),
('3','2022-10-11','2','2'),
('4','2022-10-13','2','1');



-- Task 2

DELIMITER //
CREATE PROCEDURE CheckBooking (IN bkgDate DATE, IN tblNumber CHAR(1))
BEGIN
    SET @tabCount = (
        SELECT COUNT(*) FROM bookings
        WHERE TableNumber = tblNumber
            AND BookingDate = bkgDate
    );

    IF @tabCount = 0 THEN
        SELECT CONCAT('Table ', tblNumber, ' is not booked') AS `Booking status`;
    ELSE
        SELECT CONCAT('Table ', tblNumber, ' is already booked') AS `Booking status`;
    END IF;

END//
DELIMITER ;


CALL CheckBooking('2022-10-13', '1');


-- Task 3

DELIMITER //
CREATE PROCEDURE AddValidBooking(IN bkgDate DATE, IN tblNumber CHAR(1))
BEGIN
    SET @tabCount = (
        SELECT COUNT(*) FROM bookings
        WHERE TableNumber = tblNumber
            AND BookingDate = bkgDate
    );

    START TRANSACTION;

    INSERT INTO bookings (BookingDate, TableNumber)
    VALUES (bkgDate, tblNumber);

    IF @tabCount > 0 THEN
        ROLLBACK;
        SELECT CONCAT('Table ', tblNumber, ' is already booked - booking cancelled') AS `Booking status`;
    ELSE
        COMMIT;
        SELECT CONCAT('Table ', tblNumber, ' is booked successfully') AS `Booking status`;
    END IF;

END//
DELIMITER ;


CALL AddValidBooking('2022-10-13', '2');


-- Fourth Exercise
-- Task 1
DELIMITER //
CREATE PROCEDURE AddBooking(IN bkgID INT, IN bkgDate DATE, IN tblNumber CHAR(1), IN custID INT)
BEGIN
    SET @tblCount = (
        SELECT COUNT(*) FROM bookings WHERE BookingID = bkgID
    );

    START TRANSACTION;
    INSERT INTO bookings (BookingID, BookingDate, TableNumber, CustomerID)
    VALUES (bkgID, bkgDate, tblNumber, custID);

    IF @tblCount = 0 THEN
        COMMIT;
        SELECT 'New booking added' AS `Confirmation`;
    ELSE
        ROLLBACK;
        SELECT 'Booking already exists' AS `Confirmation`;
    END IF;
END//
DELIMITER ;


CALL AddBooking(9, '2022-12-30', 3, 4);


-- Task 2
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN bkgID INT, IN bkgDate DATE)
BEGIN
    START TRANSACTION;
    UPDATE bookings
    SET BookingDate = bkgDate
    WHERE BookingID = bkgID;
    COMMIT;

    SELECT CONCAT('Booking ', bkgID, ' is updated') AS `confirmation`;
END//
DELIMITER ;

CALL UpdateBooking(9, '2022-07-18');

-- Task 3

DELIMITER //
CREATE PROCEDURE CancelBooking(IN bkgID INT)
BEGIN
    START TRANSACTION;
    DELETE FROM bookings
    WHERE BookingID = bkgID;
    COMMIT;

    SELECT CONCAT('Booking ', bkgID, ' is cancelled') AS `confirmation`;
END//
DELIMITER ;

CALL CancelBooking(9);