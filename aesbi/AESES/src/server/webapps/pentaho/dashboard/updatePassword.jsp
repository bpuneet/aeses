<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@ page import="org.pentaho.platform.engine.security.DefaultPentahoPasswordEncoder"%>

<%

Object obj = session.getAttribute("SECURITY_PRINCIPAL");
if(obj != null
&& obj instanceof org.springframework.security.providers.UsernamePasswordAuthenticationToken)
{ 

String currentPassword=request.getParameter("current");
DefaultPentahoPasswordEncoder e1 = new DefaultPentahoPasswordEncoder();
	String encryptedPassword = e1.encodePassword(currentPassword,32);

String Newpass=request.getParameter("new");
String conpass=request.getParameter("confirm");

	String encryptedPassword2 = e1.encodePassword(Newpass,32);

String connectionURL = "jdbc:mysql://enst01db01pr.aesenergystorage.com:3306/hibernate?user=nagraj.r&password=Sigma_2011!";
Connection con=null;
String pass="";
int id=0;


org.springframework.security.userdetails.User user1 = (org.springframework.security.userdetails.User)
((org.springframework.security.providers.UsernamePasswordAuthenticationToken)obj).getPrincipal();


try{
Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection(connectionURL);
Statement st=con.createStatement();
ResultSet rs=st.executeQuery("select PASSWORD from USERS where USERNAME='"+user1.getUsername()+"'");
while(rs.next()){
pass=rs.getString(1);
}
if(pass.equals(encryptedPassword)){
if(Newpass != null && Newpass != "")
{
if(Newpass.equals(conpass))
{
Statement st1=con.createStatement();
int i=st1.executeUpdate("update USERS set PASSWORD='"+encryptedPassword2+"' where USERNAME='"+user1.getUsername()+"'");%>
<script type="text/javascript">
alert("Password changed successfully");
window.onload = formSubmit;
function formSubmit() {
      document.forms["change"].submit();
}
</script>
<%
st1.close();
con.close();
}
else
{%>
<script type="text/javascript">
alert(" Make sure the passwords match.");
window.onload = formSubmit;
function formSubmit() {
      document.forms["change"].submit();
}
</script>
<%
}
}
else{%>
<script type="text/javascript">
alert(" Password field can not be empty");
window.onload = formSubmit;
function formSubmit() {
      document.forms["change"].submit();
}</script>
<%
}
}
else{%>
<script type="text/javascript">
alert("Invalid Current Password");
window.onload = formSubmit;
function formSubmit() {
      document.forms["change"].submit();
}
</script>
<%
}
}
catch(Exception e){
out.println(e);
}
}
%>

<form action="changePassword.jsp" name="change" method="post">
</form>