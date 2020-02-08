DROP DATABASE IF EXISTS notive;
CREATE DATABASE notive;
USE notive;

CREATE TABLE `User` (
	`id` INT(10) NOT NULL AUTO_INCREMENT,
	`email` varchar(50) NOT NULL UNIQUE,
	`password` varchar(64) NOT NULL,
	`name` varchar(50),
	`surname` varchar(50),
	`date_of_birth` DATE,
	`created_at` INT(11),
	PRIMARY KEY (`id`)
);

CREATE TABLE `List` (
	`id` INT(10) NOT NULL AUTO_INCREMENT,
	`name` varchar(50) NOT NULL,
	`is_done` BOOLEAN NOT NULL DEFAULT '0',
	`user_id` INT(10) NOT NULL,
	`created_at` INT(11) NOT NULL,
	`finished_at` INT(11),
	PRIMARY KEY (`id`)
);

CREATE TABLE `Item` (
	`id` INT(10) NOT NULL AUTO_INCREMENT,
	`name` varchar(50) NOT NULL,
	`list_id` INT(10) NOT NULL,
	`is_done` BOOLEAN NOT NULL DEFAULT '0',
	`created_at` INT(11) NOT NULL,
	`finished_at` INT(11),
	PRIMARY KEY (`id`)
);

ALTER TABLE `List` ADD CONSTRAINT `List_fk0` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`);

ALTER TABLE `Item` ADD CONSTRAINT `Item_fk0` FOREIGN KEY (`list_id`) REFERENCES `List`(`id`);

