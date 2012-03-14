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

        mondrian.spi.impl.CatalogLocatorImpl;"%>


<html> 
<head> 
<title>Flush Mondrian Cache</title> 
</head> 
<body> 


<%
int year1=0;
int month1=0;
int month2=0;
int year2=0;
String year="";
String month="";
String monthdiff="";
String yeardiff="";
StringWriter sw = new StringWriter();
PrintWriter pw = new PrintWriter(sw); 


PropertyList properties = mondrian.olap.Util.parseConnectString("Catalog=solution:bi-developers/analysis/market.xml");
String dataSourceName = properties.get(RolapConnectionProperties.DataSource.name());
IDatasourceService datasourceService =  (IDatasourceService) PentahoSystem.getObjectFactory().getObject(IDatasourceService.IDATASOURCE_SERVICE,null);
javax.sql.DataSource dataSourceImpl = datasourceService.getDataSource("DatasourceName");

//Create a database connection to the datasource
RolapConnection mondrianConnection = (RolapConnection)DriverManager.getConnection(properties, null, dataSourceImpl);
RolapSchema mondrianSchema = (RolapSchema)mondrianConnection.getSchema();
mondrian.olap.Cube someCube = mondrianConnection.getSchema().lookupCube("CubeName", true);

out.println(someCube);

out.println("connection =" + dataSourceImpl);
pw.println("\n\n");


mondrian.olap.SchemaReader schemaReader = someCube.getSchemaReader(null);
out.println("Schema Reader =" + schemaReader);

Class.forName("com.mysql.jdbc.Driver");

String url="jdbc:mysql://localhost:3306/<datbasename>";

java.sql.Connection con=java.sql.DriverManager.getConnection(url,"username","password");

Statement stmt=con.createStatement();

ResultSet rs=stmt.executeQuery("select distinct LEFT(CAST(max(tran_date) AS CHAR(10)),4) as Year,MONTH(max(tran_date)) as Month from sales_fact");
		
while(rs.next())
{
	 year1=rs.getInt("Year");
	 month1=rs.getInt("Month");
	 month2=month1-1; 
	 year2=year1-1;
	 if(month1!=1)
	 {	 
	 year=java.lang.String.valueOf(year1);
     month=java.lang.String.valueOf(month1);
     monthdiff=java.lang.String.valueOf(month2);
     yeardiff=java.lang.String.valueOf(year2);
     out.println(year+"    "+month+"   "+ monthdiff);

mondrian.olap.Member memberYear = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("Year", "All Year",year),true);

mondrian.olap.Member memberCurrMonth = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("Month", "All Month",month),true);

mondrian.olap.Member memberPrevMonth = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("Month", "All Month", monthdiff),true);

mondrian.olap.CacheControl cacheControl = mondrianConnection.getCacheControl(pw);

mondrian.olap.CacheControl.CellRegion measuresRegion = cacheControl.createMeasuresRegion(someCube);

mondrian.olap.CacheControl.CellRegion regionYear = cacheControl.createMemberRegion(memberYear, true);

mondrian.olap.CacheControl.CellRegion regionCurrMonth = cacheControl.createMemberRegion(memberCurrMonth, true);

mondrian.olap.CacheControl.CellRegion regionPrevMonth = cacheControl.createMemberRegion(memberPrevMonth, true);

mondrian.olap.CacheControl.CellRegion regionPrevCrossed = cacheControl.createCrossjoinRegion(measuresRegion,regionYear,regionPrevMonth);

mondrian.olap.CacheControl.CellRegion regionCurrCrossed = cacheControl.createCrossjoinRegion(measuresRegion,regionYear,regionCurrMonth);

cacheControl.flush(regionPrevCrossed);
cacheControl.flush(regionCurrCrossed);
out.println(regionPrevCrossed);
pw.println("\n");
out.println(regionCurrCrossed);
	 }

	 else
	 {
		 year=java.lang.String.valueOf(year1);
	     month=java.lang.String.valueOf(month1);
	     monthdiff="12";
	     yeardiff=java.lang.String.valueOf(year2);
	     out.println(year+"    "+month+"   "+ monthdiff+"    "+yeardiff);

	mondrian.olap.Member memberCurrYear = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("Year", "All Year",year),true);

	mondrian.olap.Member memberCurrMonth = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("Month", "All Month",month),true);

	mondrian.olap.Member memberPrevYear = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("Year", "All Year",yeardiff),true);
	
	mondrian.olap.Member memberPrevMonth = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("Month", "All Month", monthdiff),true);
	
	mondrian.olap.CacheControl cacheControl = mondrianConnection.getCacheControl(pw);

	mondrian.olap.CacheControl.CellRegion measuresRegion = cacheControl.createMeasuresRegion(someCube);

	mondrian.olap.CacheControl.CellRegion regionCurrYear = cacheControl.createMemberRegion(memberCurrYear, true);

	mondrian.olap.CacheControl.CellRegion regionCurrMonth = cacheControl.createMemberRegion(memberCurrMonth, true);
	
	mondrian.olap.CacheControl.CellRegion regionPrevYear = cacheControl.createMemberRegion(memberPrevYear, true);

	mondrian.olap.CacheControl.CellRegion regionPrevMonth = cacheControl.createMemberRegion(memberPrevMonth, true);
	
	mondrian.olap.CacheControl.CellRegion regionPrevCrossed = cacheControl.createCrossjoinRegion(measuresRegion,regionPrevYear,regionPrevMonth);

	mondrian.olap.CacheControl.CellRegion regionCurrCrossed = cacheControl.createCrossjoinRegion(measuresRegion,regionCurrYear,regionCurrMonth);

	cacheControl.flush(regionPrevCrossed);
	cacheControl.flush(regionCurrCrossed);
	out.println(regionPrevCrossed);
	pw.println("\n");
	out.println(regionCurrCrossed);
	 }
}
pw.flush();

%> 

<h3>Properties:</h3>
<%= properties %>

<h3>Schema Name</h3>
<%= mondrianSchema.getName() %>

<h3>Cube Name</h3>
<%= someCube != null ? someCube.getName() : "Cube not found" %>


</body> 
</html>
