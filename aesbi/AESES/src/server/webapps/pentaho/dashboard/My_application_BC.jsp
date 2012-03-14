<%@ page import="org.jasypt.encryption.pbe.StandardPBEStringEncryptor"%>
<%@ page import="org.jasypt.encryption.pbe.config.SimplePBEConfig"%>
<%@ page import="org.jasypt.encryption.pbe.*"%>
<%@ page import="org.jasypt.salt.RandomSaltGenerator"%>
<%@ page import="org.jasypt.salt.SaltGenerator"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="org.pentaho.platform.engine.security.DefaultPentahoPasswordEncoder"%>

<html> 
<body>
<% 
   String user = request.getParameter("name");
   String pass  = request.getParameter("pass");
   Statement statement = null;
	DefaultPentahoPasswordEncoder e1 = new DefaultPentahoPasswordEncoder();
	String encryptedPassword = e1.encodePassword(pass,32);         

   Connection connection = null;
   try {
   String connectionURL = "jdbc:mysql://enst01db01pr.aesenergystorage.com:3306/hibernate?user=nagraj.r&password=Sigma_2011!";

SimplePBEConfig simplePBEConfig = new SimplePBEConfig();
simplePBEConfig.setKeyObtentionIterations(10000);
 
SaltGenerator saltGenerator = new RandomSaltGenerator();
saltGenerator.generateSalt(16);
 
simplePBEConfig.setSaltGenerator(saltGenerator);
simplePBEConfig.setPassword("password$123#");
 
StandardPBEStringEncryptor e = new StandardPBEStringEncryptor();
e.setConfig(simplePBEConfig);
e.initialize();
 
String encryptedPassword2 = e.encrypt(pass);


Object obj = session.getAttribute("SECURITY_PRINCIPAL");
if(obj != null
&& obj instanceof org.springframework.security.providers.UsernamePasswordAuthenticationToken)
{
org.springframework.security.userdetails.User user1 = (org.springframework.security.userdetails.User)
((org.springframework.security.providers.UsernamePasswordAuthenticationToken)obj).getPrincipal();

   Class.forName("org.gjt.mm.mysql.Driver").newInstance();

   connection = DriverManager.getConnection(connectionURL);
   statement = connection.createStatement();
   String query="select * from APPLICATIONS where pentaho_user='"+user1.getUsername()+"'";
   String QueryString = "INSERT INTO APPLICATIONS (pentaho_user,basecamp_user,basecamp_pass) VALUES ('" + user1.getUsername() + "','" + user + "','" + encryptedPassword2 + "')";
   String QueryString2 = "UPDATE APPLICATIONS set basecamp_user='" + user + "',basecamp_pass='" + encryptedPassword2 + "' where pentaho_user='" + user1.getUsername() +"'";
   ResultSet rst = statement.executeQuery(query);
   if(rst.next())
   {
   statement.executeUpdate(QueryString2);
   }
   else
   {
   statement.executeUpdate(QueryString);
   }
%>
<script type="text/javascript">
alert('Succesfully updated the ' + '<%=user%>' +' credentials for BaseCamp application');
window.onload = formSubmit;
function formSubmit() {
      document.forms["logonForm"].submit();
}
</script>
<%

} } catch (Exception ex) {
%>
<script type="text/javascript">
alert('Unable to connect to database.');
window.onload = formSubmit;
function formSubmit() {
      document.forms["logonForm"].submit();
}
</script>
    <%
            } finally {

                statement.close();
                connection.close();
            }
    %>
	
	<form  id="f" action="My_applications.jsp" name="logonForm" method="post">
</form>
</FONT>
</body> 
</html>