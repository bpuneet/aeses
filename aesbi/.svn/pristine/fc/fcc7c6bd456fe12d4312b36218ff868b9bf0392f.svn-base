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

        mondrian.spi.impl.CatalogLocatorImpl;"%>


<html> 
<head> 
<title>Flush Mondrian Cache</title> 
</head> 
<body> 
<%

String provider = "mondrian";
String jdbcUrl = "jdbc:mysql://localhost:3306/xmltrans_rpt";
String user = "root";
String password = "admin";
String catalog = "file:D:/pentaho/setup/biserver-ce/pentaho-solutions/bi-developers/analysis/activity_details.xml";
String driver = "com.mysql.jdbc.Driver";


	Connection connection = DriverManager.getConnection("Provider="+provider
														+";Jdbc="+jdbcUrl
														+"?user="+user
														+"&password="+password
														+";Catalog="+catalog
														+";jdbcDrivers="+driver, 
														null);
	
	




StringWriter sw = new StringWriter();
PrintWriter pw = new PrintWriter(sw); 



RolapConnection mondrianConnection = (RolapConnection)connection;
RolapSchema mondrianSchema = (RolapSchema)mondrianConnection.getSchema();
RolapCube mondrianCube = (RolapCube)mondrianSchema.lookupCube("Activity Details", false);


mondrian.olap.SchemaReader schemaReader = mondrianCube.getSchemaReader(null);



java.util.ArrayList memberMarchList = new java.util.ArrayList();

memberMarchList.add(new mondrian.olap.Id.Segment("user",mondrian.olap.Id.Quoting.QUOTED));


mondrian.olap.Member memberTimeMarch = schemaReader.getMemberByUniqueName(memberMarchList ,true);


// Create an object for managing the cache
mondrian.olap.CacheControl cacheControl = mondrianConnection.getCacheControl(pw);

// Create a cache region defined by
mondrian.olap.CacheControl.CellRegion measuresRegion = cacheControl.createMeasuresRegion(mondrianCube);

mondrian.olap.CacheControl.CellRegion regionTime = cacheControl.createMemberRegion(memberTimeMarch, true);

mondrian.olap.CacheControl.CellRegion[] regions = new mondrian.olap.CacheControl.CellRegion[2]; 
regions[0]=measuresRegion;
regions[1]=regionTime;

mondrian.olap.CacheControl.CellRegion measuresTimeCellRegion =cacheControl.createCrossjoinRegion(regions);


cacheControl.flush(measuresTimeCellRegion);
//pw.flush();
//SimpleLogger log = new SimpleLogger(SimpleLogTest.class);

//log.debug("measuresTimeCellRegion=" + sw.toString());

out.println("measuresTimeCellRegion=" + sw.toString());

%> 

<h3>Properties:</h3>
<%= properties %>

<h3>Schema Name</h3>
<%= mondrianSchema.getName() %>

<h3>Cube Name</h3>
<%= mondrianCube != null ? mondrianCube.getName() : "Cube not found" %>


</body> 
</html>
