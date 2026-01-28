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

