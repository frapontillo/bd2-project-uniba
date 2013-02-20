bd2-project-uniba
=================

University project for the Database Systems 2 course.

## Project folders

The project is divided into several folders:

- `db`, containing scripts and files for creating and managing the database.
- `doc`, containing the whole documentation and a bunch of other stuff.
- `dw`, containing the script for the data warehouse, the Mondrian schema and some pages for jPivot.
- `rest`, containing the RESTful Web Service that implements the business logic.
- `rest-gen`, containing the generation code for the database classes.
- `tomcat-conf` contains a configuration example for the Tomcat server, referencing two databases (one for the Web app, one for the Mondrian analysis).
- `web`, containing the Web application.

## History

### 2013-02-20

- Fixed a major memory leak in the connection management (only when authentication is not succesful).
- Fixed a translation issue on the `pagination` plugin tag.
- Changed database schema for a function which didn't work on PostgreSQL 8.4.
- Updated deploy guide and documentation.
- Version 1.0.0.
- Improved error management, JDBC connections is always closed in a finally block.
- Updated doc.
- Deleted some parameters from `Resource` configurations.
- Updated deploy guide.
- Version 1.0.1.

### 2013-02-19

- Created a new database from scratch, filled with lots of fake data. Script made.
- Made a new script for the DW as well.
- Made a better landing page for jPivot, called `better.jsp`.
- Integrated the new jpivot route in the Web app (as an `iframe`), referencing `better.jsp?query=mallAnalysis`.
- Few bugfixes.
- Documentation updated.
- AngularJS bugfix for cookies.
- Deploy guide written.

### 2013-02-18

- Added JNDI lookup for the `DataSource`. Connection string is handled by the EE Container.
- Added `<title>` tags to all of the pages, injected by controllers.
- Improved connection, closing every connection after the `IEntity` conversion.
- Added `tomcat-conf` folder, containing a bootstrap configuration for the default case.
- Update database schema in `db/script.sql`.
- Exported `rest.war` file.
- Web app built with yeoman.
- Exported `app.war` file.
- Created `web/_server.sh` script for starting the yeoman preview server.
- Created `web/_build.sh` script for building the project with yeoman.
- Created `web/app/_war.sh` script for building a war file from the folder the script is in. The script is automatically copied by `_build.sh` in the distribution folder.
- Created `web/_build_war.sh` scripts, at first it builds, then makes a war file.
- Added `href`: Attivita to Struttura.
- Doc updated (Data Warehouse), DW schema created.
- DW schema filled with lots of fake entities (courtesy of Sir Internet, The).
- Mondrian schema created.
- JPivot page created, date problems solved by changing the DW schema with all `integer`s reset to `character varying`. JPivot example working, to be integrated in the Web app (as a link?).

### 2013-02-17

- Used datepicker.
- Made a filter for boolean.
- Attivita working in read/edit/new/delete mode.
- Struttura working in read/edit/new/delete mode.
- Dipendente working in read/edit/new/delete mode.
- Connection of Attivita to Struttura almost complete.
- TODO:
	- Connection of Assunzione to Dipendente and to Attivita.
	- List of Assunzione.
	- New Assunzione.
	- Edit Assunzione.
	- Delete Assunzione (firing).
- Enabled fast linking for creating a new Attivita starting from a Struttura.
- Attivita created from Struttura.
- Assunzione created from Dipendente and from Attivita.
- Assunzione edited and deleted.
- Datepicker issue seems to stand within the Bootstrap plugin, which is making changes outside of the scope of AngularJS. Cannot fix.
- Links between entities in pages.
- Fixed redirection by using `$location.url()` instead of `$location.path()`.
- Main development phase for Web app has ended.

### 2013-02-16

- `DipendenteResource` now working with the PostgreSQL function.
- Pages for Struttura made up to now:
	- List/Search of Struttura
	- Detail of Struttura (to complete with list of Attivita attached)
	- Edit Struttura
	- New Struttura
- Pages for Dipendente made:
	- List/Search of Dipendente
	- Detail of Dipendente (to complete with list of Assunzione in different Attivita attached)
	- Edit Dipendente
	- New Dipendente
- Pages for Attivita made:
	- List/Search of Attivita
	- Detail of Attivita (to complete with list of Assunzione of different Dipendente attached)
- Added momentjs.
- Added angular-strap as a reference.
- Added bootstrap-datepicker.

### 2013-02-15

- `UserSession` inserted, retrieved and deleted.
- Added `BadResponseException` with related `Mapper`.
- Authentication handled properly.
- Regenerated jooq entities because of DB schema changes.
- All resources are complete and properly working.
- Web service ready to be used.
- Web application initialized. Loaded libraries: `jquery`, `angular`, `angular-cookies`, `angular-resource`, `angular-ui`, `bootstrap`, `angular-bootstrap`, `angular-strap`.
- Home page created.
- Header created.
- Login and logout pages created.
- `Factory` for `UserSession` created and working.
- Fixed `Menu` factory class and all of the items, nested items point are now classified in the right parent in the header.
- Page for Struttura created with a draft of a table and a search box.
- Added another function to the db.
- Doc updated.
- Added paging to `StrutturaResource`, `AttivitaResource`, `DipendenteResource`. `DipendenteResource` and `AttivitaResource` are broken, fix that.

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