<%@ page session="true" contentType="text/html; charset=ISO-8859-1" %>
<%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<jp:mondrianQuery id="query01"
dataSource="jdbc/MallOLAP"
catalogUri="/WEB-INF/queries/mallSchema.xml">
SELECT {[Measures].[incasso]} ON COLUMNS,
{([data],[attivita],[struttura],[dipendente],[responsabile])} ON ROWS
FROM [incassi]
</jp:mondrianQuery>

<c:set var="title01" scope="session">The Mall / Data Warehouse</c:set>