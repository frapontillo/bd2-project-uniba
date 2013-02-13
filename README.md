bd2-project-uniba
=================

University project for the Database Systems 2 course.

## Project folders

The project is divided into 4 folders:

- `app`, containing the Web application.
- `db`, containing scripts and files for creating and managing the database.
- `dw`, containing the scripts for the data warehouse.
- `rest`, containing the RESTful Web Service that implements the business logic.

## RESTful Web Service

The dependencies for the RESTful Web Service are:

- `jersey-bundle-1.17.jar` and `asm-3.3.1.jar` for Jersey, an implementation of the JAX-RS specification.
- `postgresql-9.2-1002.jdbc4.jar` for managing the connection with PostgreSQL 9.2.
- `cayenne-server-3.0.2.jar`, `ashwood-2.0.jar`, `commons-collections-3.1.jar`, `commons-logging-1.1.jar`, `vpp-2.2.1.jar` for the ORM mapping.

## History

### 2013-02-12

- Empty project created on GitHub.

### 2013-02-13

- RESTful Web Service set up with all of the libraries, base classes and configs.