<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">


<%@page import="
	java.util.*,
	javax.sql.DataSource,
	org.pentaho.platform.engine.core.system.PentahoSystem,
	org.pentaho.platform.api.data.IDatasourceService,
	mondrian.olap.Connection,
        mondrian.olap.DriverManager,
        mondrian.olap.Query,
        mondrian.olap.Result,
        mondrian.olap.Util.*,
        mondrian.rolap.RolapConnection,
        mondrian.rolap.RolapSchema,
        mondrian.rolap.RolapCube,
        mondrian.rolap.RolapConnectionProperties,
       
java.io.StringWriter,
java.io.PrintWriter,
java.sql.*,
javax.sql.*,
java.lang.*,
mondrian.olap.*,

        mondrian.spi.impl.CatalogLocatorImpl;"%>


<html> 
<head> 
<title>Flush Mondrian Cache</title> 
</head> 
<body> 


<%

String provider = "mondrian";
String jdbcUrl = "jdbc:mysql://localhost:3306/gg";
String user = "root";
String password = "admin";
String catalog = "file:/C:/work/pentaho/server/biserver-ce-3.7.0-stable/biserver-ce/pentaho-solutions/steel-wheels/nagraj/cubes/gg_Schema.xml";
String driver = "com.mysql.jdbc.Driver";

try{
	Connection connection = DriverManager.getConnection("Provider="+provider
														+";Jdbc="+jdbcUrl
														+"?user="+user
														+"&password="+password
														+";Catalog="+catalog
														+";jdbcDrivers="+driver, 
														null);
	CacheControl cacheControl = connection.getCacheControl(null);
	cacheControl.flushSchemaCache();
}catch(Exception e){
	out.println("Some error occured...");
	out.println(e.getMessage());	
}
%>


Cache Flushed...



</body> 
</html>
