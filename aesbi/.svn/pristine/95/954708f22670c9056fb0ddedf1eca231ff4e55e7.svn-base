<% 

Object obj = session.getAttribute("SECURITY_PRINCIPAL");
if(obj != null
&& obj instanceof org.springframework.security.providers.UsernamePasswordAuthenticationToken)
{
org.springframework.security.userdetails.User user1 = (org.springframework.security.userdetails.User)
((org.springframework.security.providers.UsernamePasswordAuthenticationToken)obj).getPrincipal();

if(user1.getUsername() == null)
{
	response.sendRedirect("/pentaho/Login");
}


}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html>

<head>

<style>
body {
	margin: 0; 	padding: 0;
	font: normal .80em/1.6em Verdana, 'Trebuchet MS', Tahoma, sans-serif;
	color: #444;
	text-align: center;
	background: #E0E9DF;	
}



h1, h2, h3 {
	font: normal 1em Georgia, "Times New Roman", Times, serif;
	color:#111;
	letter-spacing:-1px;
}
h1 { font-size: 2.0em; } 
h3 { font-size: 1.1em; }

p, h1, h2, h3 {
	margin: 10px 15px;
	padding: 0;
}



#header-wrap,  #content-wrap {
	min-width: 810px;	
	width: 100%;	
}
#header-wrap {
	
	text-align: left;	
	background: #FFFFFF;	
	clear: both;
	position: relative;
}
#header-content {
	position: relative;
	margin: 0 auto; 
	padding: 0;
	height: 80px;
}



div.mylogo {
	
 position: absolute;
 top: 0px;
 left: 0px;

 }

div.mylogo img {
	border: none;
}


/** Alternative Menu  **/


/*- Top Menu --------------------------- */

    div.topmenu {
    margin:0;
    padding: 0;
      float:left;
      width:100%;
      font-size:93%;
      line-height:normal;
      background: #6699CC;
      height: 25px;
	   }
    



/* content */


#content-wrap {
	
background: #FAFAFA;	  
  width: 100%;
  float: left;
	  }
	  
	  
#content {
	text-align: left;	  
	margin-left: 4%;
 margin-right: 3%;
 
  margin-top: 20px;
  margin-bottom: 30px;
	  
	padding: 0;	
}



/* sidebar */
#sidebar {
	float: left;
	width: 20%;
	margin: 0 0 10px 0;
	padding: 0;	
	
	
}
#sidebar h3 {
	font: normal 1.4em Georgia, "Times New Roman", Times, serif;
	color: #498B48;
	padding: 0;
	margin: 0 0 10px 5px;	
		
}
#sidebar ul.sidemenu {
	margin: 5px 0 25px 0;
	padding: 0;	
	border-top: 1px dashed #E1E1E1;	
}
#sidebar ul.sidemenu li {
	list-style: none;
	border-bottom: 1px dashed #E1E1E1;
}
#sidebar ul.sidemenu a {
	display: block;
	color: #666666; 
	text-decoration: none;
	padding: .4em 0 .4em 10px;		
	width: 94%;
}
#sidebar ul.sidemenu a:hover {
	padding: .4em 0 .4em 10px;
	color: blue;
}
#sidebar ul.sidemenu a.active {
	padding: .4em 0 .4em 10px;
	color: #fff;
	background: #B1C8AE;	
}


/* main */

#pform {
position:absolute;
top:100px;
left:582px;
display:none;
border:2px solid DarkCyan;
padding:8px;
}
#BCpform {
position:absolute;
top:100px;
left:582px;
display:none;
border:2px solid DarkCyan;
padding:8px;
}

/* footer */
#footer-wrap {
	position: relative;
	clear: both;
	padding: 0 0;
	font: normal .95em 'Trebuchet MS', Tahoma, sans-serif;
	text-align: left;	
	background: #E0E9DF;		
	color: #CCC;
	width: 100%;
	float: left;	
	border-top: 4px #CCCCCC solid;
}
#footer-wrap p {
	
	text-align: center;
	color: #637561;
	padding-top: 15px;;
}

#footer-wrap div.outlink a{

 text-decoration: none;
 color: #ccc;
 font-size: 9px;
 padding-left: 3px;
 margin: 0;
 padding-left: 3px;
	
}


div.footmenu ul{
	
 list-style: none;
 padding: 8px 40% 0;

 
}

div.footmenu ul li {
	display: inline;
	padding-left: 5px;
}

div.footmenu ul li a{
	padding-right: 5px;
	text-decoration:none;
	color: #333;
}

</style>

<script type="text/javascript">
function promptJIRA() {
// get field to be validated
var pf = document.getElementById( 'pForm' );
var BCpf = document.getElementById( 'BCpForm' );
pf.style.display = 'block';
BCpf.style.display = 'none';
document.getElementById( 'JIRA' ).style.background="none repeat scroll 0 0 #B1C8AE";
document.getElementById( 'BC' ).style.background="none";
}

function promptBC() {
// get field to be validated
var pf = document.getElementById( 'pForm' );
var BCpf = document.getElementById( 'BCpForm' );
pf.style.display = 'none';
BCpf.style.display = 'block';
document.getElementById( 'JIRA' ).style.background="none";
document.getElementById( 'BC' ).style.background="none repeat scroll 0 0 #B1C8AE";
}

function getPdata( arg ) {
var f = document.getElementById( 'pForm' );
if ( 'Cancel' == arg ) {
f.style.display = 'none'; // hide form
return; // exit immediately
}
else {
var n = f.name.value;
var a = f.pass.value;
f.style.display = 'none'; // hide form
}
}

function getBCPdata( arg ) {
var f = document.getElementById( 'BCpForm' );
if ( 'Cancel' == arg ) {
f.style.display = 'none'; // hide form
return; // exit immediately
}
else {
var n = f.name.value;
var a = f.pass.value;
f.style.display = 'none'; // hide form
}
}

function validateForm()
{
var f = document.getElementById( 'pForm' );
var n = f.name.value;
var a = f.pass.value;
f.style.display = 'block'; 
if ((n==null || n=="") && (a==null || a=="") )
  {
  alert("Username and password cannot be empty");
  return false;
  }
 else if (n==null || n=="")
  {
  alert("Username cannot be empty");
  return false;
  }
   else if (a==null || a=="")
  {
  alert("password cannot be empty");
  return false;
  }
}

function validateForm2()
{
var f = document.getElementById( 'BCpForm' );
var n = f.name.value;
var a = f.pass.value;
f.style.display = 'block'; 
if ((n==null || n=="") && (a==null || a=="") )
  {
  alert("Username and password cannot be empty");
  return false;
  }
 else if (n==null || n=="")
  {
  alert("Username cannot be empty");
  return false;
  }
   else if (a==null || a=="")
  {
  alert("password cannot be empty");
  return false;
  }
}
</script>
	
</head>

<body>
	<div id="header-wrap">
	<div id="header-content">	
		<div class="mylogo">
			
		</div>	
	</div></div><!-- Header Wrapp -->	
	<!-- Top Menu -->
		<div class="topmenu">			
		</div> 				
	<!-- content-wrap starts here -->
	<div id="content-wrap">	
	<div id="content">	 	
	<div id="sidebar">			
				<h3></h3>
				<ul class="sidemenu">

				</ul>		
	</div>
	<form action="updatePassword.jsp" method="post">
	<table>
	<tr><td>Current Password</td><td><input type="password" name="current"></td></tr>
	<tr><td>New Password</td><td><input type="password" name="new"></td></tr>
	<tr><td>Confirm Password</td><td><input type="password" name="confirm"></td></tr>
	<tr><td><input type="submit" value="Change Password"></td><td><input type="reset" value="Reset" onclick="this.form.reset()" />
	</td></tr>
	</table>
	</form>
      	</div></div>
	<div id="footer-wrap">
	<div id="footer-content">
	<div class="outlink">
		</div>
	</div></div><!-- footer ends here -->
</body>
</html>
