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
int years = 0 ;
int months = 0 ;
int quarters = 0 ;
int day_of_years = 0 ;

String year = "";
String month = "";
String quarter = "";
String day_of_year = "";
StringWriter sw = new StringWriter();
PrintWriter pw = new PrintWriter(sw); 


//PropertyList properties = mondrian.olap.Util.parseConnectString("Catalog=solution:bi-developers/analysis/market.xml");
//String dataSourceName = properties.get(RolapConnectionProperties.DataSource.name());
//IDatasourceService datasourceService =  (IDatasourceService) //PentahoSystem.getObjectFactory().getObject(IDatasourceService.IDATASOURCE_SERVICE,null);
//javax.sql.DataSource dataSourceImpl = datasourceService.getDataSource("DatasourceName");

//Create a database connection to the datasource
RolapConnection mondrianConnection = (RolapConnection)DriverManager.getConnection(properties, null, dataSourceImpl);
RolapSchema mondrianSchema = (RolapSchema)mondrianConnection.getSchema();
mondrian.olap.Cube someCube = mondrianConnection.getSchema().lookupCube("Market", true);

out.println(someCube);

out.println("connection =" + dataSourceImpl);
pw.println("\n\n");


mondrian.olap.SchemaReader schemaReader = someCube.getSchemaReader(null);
out.println("Schema Reader =" + schemaReader);

Class.forName("com.mysql.jdbc.Driver");

String url="jdbc:mysql://enst01db01dv.aesenergystorage.com:3306/aeses";

java.sql.Connection con=java.sql.DriverManager.getConnection(url,"puneet.b","Sigma_2010!");

Statement stmt=con.createStatement();

ResultSet rs=stmt.executeQuery("SELECT year, quarter, month, day_of_year FROM aeses.bi_dim_date where id = (SELECT max(bi_dim_date_id) FROM aeses.bi_fact_markets_part )");
		
while(rs.next())
{
	 years=rs.getInt("year");
	 months=rs.getInt("month");
	 quarters=rs.getInt("quarter");
	 day_of_years=rs.getInt("day_of_year");
	 	 	 
	 year = java.lang.String.valueOf(years);
     month = java.lang.String.valueOf(months);
     quarter = java.lang.String.valueOf(quarters);
     day_of_year = java.lang.String.valueOf(day_of_years);
     out.println(year+"    "+month+"   "+ quarter+"  "+day_of_year);

mondrian.olap.Member memberYear = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("Year", "All Year",year),true);

mondrian.olap.Member memberMonth = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("Month", "All Month",month),true);

mondrian.olap.Member memberquarter = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("Quarter", "All Quarter", quarter),true);

mondrian.olap.Member memberday_of_year = schemaReader.getMemberByUniqueName(mondrian.olap.Id.Segment.toList("day_of_year", "All day_of_year", day_of_year),true);

mondrian.olap.CacheControl cacheControl = mondrianConnection.getCacheControl(pw);

mondrian.olap.CacheControl.CellRegion measuresRegion = cacheControl.createMeasuresRegion(someCube);

mondrian.olap.CacheControl.CellRegion regionYear = cacheControl.createMemberRegion(memberYear, true);

mondrian.olap.CacheControl.CellRegion regionMonth = cacheControl.createMemberRegion(memberMonth, true);

mondrian.olap.CacheControl.CellRegion regionquarter = cacheControl.createMemberRegion(memberquarter, true);

mondrian.olap.CacheControl.CellRegion regionday_of_year = cacheControl.createMemberRegion(memberday_of_year, true);


mondrian.olap.CacheControl.CellRegion regionCurrdata = cacheControl.createCrossjoinRegion(measuresRegion ,regionYear,regionMonth , regionquarter , regionday_of_year);

cacheControl.flush(regionCurrdata);

out.println(regionCurrdata);
pw.println("\n");
 
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
