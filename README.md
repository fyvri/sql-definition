# SQL Definition
I can't describe this mini project, but I just want to refresh my knowledge about database and SQL functions by a case. Here are the guidelines you to follow:
* [Scenario](#scenario)
* [Objective](#objective)
* [Context](#context)
* [Requirements](#requirements)
* [Solving](#solving)

## Scenario
I am working in an e-commerce company and single handedly responsible with a CRM (customer relationship management) with the user management data. The user data should synchronize with user data from another system which from [https://reqres.in/api/users?page=2](https://reqres.in/api/users?page=2).

## Objective
I need to build a database schema for CRM service from scratch according to the requirements.

## Context
* For the MVP, the requirements of CRM service are defined below 
* The actors that can access the service are admin and super admin.
* User is the entity that manipulates or manages the services.
* Users and actors had different data structures.

## Requirements
1. Milestone 1
    * Create ERD how I want to design the database based on the configuration at milestone 2.
1. Milestone 2
    * Initiate the database schema on mySQL server.
    * Create actor table which will contain information about as follow:
        ```
        Id (bigint unsigned)
        Username (varchar)
        Password (varchar)
        Role id (int unsigned)
        Flag for actor if its verified (enum(‘true’, ‘false’)
        Flag for actor if its active (enum(‘true’, ‘false’)
        Created at (timestamp)
        Updated at (timestamp)
        ```
    * Create table for customer which will contain information about as follow:
        ```
        Id (bigint unsigned)
        First name (varchar)
        Last name (varchar)
        Email (varchar)
        Avatar (varchar)
        Created at (timestamp)
        Updated at (timestamp)
        ```
    * Create table for storing each unique actor role which are admin and super admin, the table consist:
        ```
        Id (int unsigned)
        Role name (varchar)
        ```
    * Create register approval table which will be used to get a list of admin registration that need to be approved by super admin, the data consist:
        ```
        Id (bigint unsigned)
        Admin id (bigint unsigned)
        Super admin id (bigint unsigned)
        Status (varchar)
        ```
    * Add foreign key to role id which reference table is role table.
1. Milestone 3
    * For super admin, insert one super admin to actor table.
    * For the super admin, create a mysql user that can access the database through the mysql server with the same username and password from actor table, also the host is 0.0.0.0.
    * Export the database schema into a sql file using mysqldump.

## Solving
1. Milestone 1
    * I design the database based on the configuration at milestone 2 using [dbdiagram.io](https://dbdiagram.io). You can see my design in [this link](https://dbdiagram.io/d/64749c137764f72fcf07e338) or download it from this repository with file name: `Database Diagram Design.png`.
    * Or you can generate UML from [PlanText](https://www.planttext.com) by file: `database_schema.rb` or download it from this repository with file name: `Entity Relationship Diagram.png`.
1. Milestone 2
    * Migrating the database schema on mySQL server using file name: `database_schema.sql` in this repository. I use the following command:
        ```bash
        mysql -u root -p < ./database_schema.sql
        ```
    * If you don't want to migrate it, you can use the following these queries:
        1. I initiate the database schema on mySQL server use the following command:
            ```sql
            CREATE DATABASE sql_definition;
            ```
        1. I use that database for creating some database, I use the following SQL query:
            ```sql
            USE sql_definition;
            ```
        1. Crete role table:
            ```sql
            CREATE TABLE `roles` (
                `id` int unsigned PRIMARY KEY AUTO_INCREMENT,
                `name` varchar(20) UNIQUE NOT NULL
            );
            ```
        1. Create actor table:
            ```sql
            CREATE TABLE `actors` (
                `id` bigint unsigned PRIMARY KEY AUTO_INCREMENT,
                `username` varchar(100) UNIQUE NOT NULL,
                `password` varchar(60) NOT NULL,
                `role_id` int unsigned NOT NULL,
                `is_verified` ENUM ('TRUE', 'FALSE') NOT NULL DEFAULT "FALSE",
                `is_active` ENUM ('TRUE', 'FALSE') NOT NULL DEFAULT "FALSE",
                `created_at` timestamp NOT NULL DEFAULT (now()),
                `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
            );
            ```
        1. Create customer table:
            ```sql
            CREATE TABLE `customers` (
                `id` bigint unsigned PRIMARY KEY AUTO_INCREMENT,
                `first_name` varchar(100) NOT NULL,
                `last_name` varchar(100) NOT NULL,
                `email` varchar(255) UNIQUE NOT NULL,
                `avatar` varchar(255),
                `created_at` timestamp NOT NULL DEFAULT (now()),
                `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
            );
            ```
        1. Create register_approval table:
            ```sql
            CREATE TABLE `register_approvals` (
                `id` bigint unsigned PRIMARY KEY AUTO_INCREMENT,
                `super_admin_id` bigint unsigned,
                `admin_id` bigint unsigned,
                `status` varchar(20)
            );
            ```
        1. Add foreign key to role id which reference table is role table.
            ```sql
            ALTER TABLE `actors` ADD FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
            ```
        1. Add foreign key to super admin id and admin id which reference table is actor table.
            ```sql
            ALTER TABLE `register_approvals` ADD FOREIGN KEY (`super_admin_id`) REFERENCES `actors` (`id`);
            ALTER TABLE `register_approvals` ADD FOREIGN KEY (`admin_id`) REFERENCES `actors` (`id`);
            ```
1. Milestone 3
    * Before inserting new actor, I must field role table.
        ```sql
        INSERT INTO roles (id, name) VALUES (1, 'superadmin'), (2, 'admin');
        ```
    * I insert one super admin to actor table. I don't input id, created_at and updated_at columns, because it has default value.
        ```sql
        INSERT INTO actors (username, password, role_id, is_verified, is_active) VALUES ('superadmin', 'password', 1, TRUE, TRUE);
        ```
    * To create a MySQL user that can access the database through the mysql server from actor table, I use the following SQL query:
        ```sql
        CREATE USER 'superadmin'@'127.0.0.1' IDENTIFIED BY 'password';
        ```
        Don't forget to give credentials as superadmin by this query:
        ```sql
        GRANT ALL PRIVILEGES ON sql_definition.* TO 'superadmin'@'127.0.0.1';
        ```
    * To export the database schema into a SQL file using mysqldump, I use the following command:
        ```command
        mysqldump -u superadmin -p -h '127.0.0.1' sql_definition > sql_definition_backup.sql
        ```
        A file which I has been dumped naming file `sql_definition_backup.sql` in this repository.