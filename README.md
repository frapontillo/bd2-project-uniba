bd2-project-uniba
=================

University project for the Database Systems 2 course.

## Project folders

The project is divided into 5 folders:

- `web`, containing the Web application.
- `db`, containing scripts and files for creating and managing the database.
- `dw`, containing the scripts for the data warehouse.
- `rest`, containing the RESTful Web Service that implements the business logic.
- `rest-gen`, containing the generation code for the database classes.
- `doc`, containing the whole documentation and a bunch of other stuff.

## RESTful Web Service

The dependencies for the RESTful Web Service are:

- `jersey-bundle-1.17.jar` and `asm-3.3.1.jar` for Jersey, an implementation of the JAX-RS specification.
- `postgresql-9.2-1002.jdbc4.jar` for managing the connection with PostgreSQL 9.2.
- `jooq-2.6.2.jar` for the ORM mapping.
- `jackson-all-1.9.11.jar` for the JSON serialization/deserialization.

## History

### 2013-02-14

- Web app project draft created with yeoman.
- Apache Cayenne doesn't work as expected, deleted with all of the references.
- Imported jOOQ references.
- Project for code generation from database created (`rest-gen`). All of the code is ready to be used (objects, POJOs, DAOs).
- Written all of the Converters based on the newest database objects.
- `AttivitaResource` completed and properly working (`GET`, `POST`, `PUT`, `DELETE`).
- Update documentation.

### 2013-02-13

- RESTful Web Service set up with all of the libraries, base classes and configs.
- Database scripts created with tables, constraints, indexes and foreign keys. TODO: triggers and functions.

### 2013-02-12

- Empty project created on GitHub.