-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
-- Database for Little Lemon Restaurant management capstone project for meta database engineer course.

-- -----------------------------------------------------
-- Schema LittleLemonDB
--
-- Database for Little Lemon Restaurant management capstone project for meta database engineer course.
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customers` (
  `customer_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(11) NULL,
  `address` VARCHAR(45) NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `booking_id` INT NOT NULL,
  `booking_date` DATE NOT NULL,
  `table_number` VARCHAR(2) NULL,
  `customer_id` INT NOT NULL,
  PRIMARY KEY (`booking_id`, `customer_id`),
  INDEX `fk_Bookings_Customers1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_Bookings_Customers1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `LittleLemonDB`.`Customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `menu_id` INT NOT NULL,
  `cuisine` VARCHAR(45) NOT NULL,
  `starter` VARCHAR(45) NULL,
  `course` VARCHAR(45) NULL,
  `drink` VARCHAR(45) NULL,
  `dessert` VARCHAR(45) NULL,
  PRIMARY KEY (`menu_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `order_id` INT NOT NULL,
  `order_date` DATE NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `total_price` DECIMAL(6,2) NOT NULL,
  `customer_id` INT NOT NULL,
  `menu_id` INT NOT NULL,
  PRIMARY KEY (`order_id`, `customer_id`, `menu_id`),
  INDEX `fk_Orders_Customers1_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_Orders_Menu1_idx` (`menu_id` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Customers1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `LittleLemonDB`.`Customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Menu1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `LittleLemonDB`.`Menu` (`menu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Staffs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staffs` (
  `employee_id` INT NOT NULL,
  `role` VARCHAR(45) NOT NULL,
  `salary` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`employee_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`DeliveryStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`DeliveryStatus` (
  `delivery_id` INT NOT NULL,
  `status` VARCHAR(10) NOT NULL,
  `order_id` INT NOT NULL,
  `delivery_staff_id` INT NOT NULL,
  PRIMARY KEY (`delivery_id`, `order_id`, `delivery_staff_id`),
  INDEX `fk_DeliveryStatus_Orders_idx` (`order_id` ASC) VISIBLE,
  INDEX `fk_DeliveryStatus_Staffs1_idx` (`delivery_staff_id` ASC) VISIBLE,
  CONSTRAINT `fk_DeliveryStatus_Orders`
    FOREIGN KEY (`order_id`)
    REFERENCES `LittleLemonDB`.`Orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DeliveryStatus_Staffs1`
    FOREIGN KEY (`delivery_staff_id`)
    REFERENCES `LittleLemonDB`.`Staffs` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
