<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
if(request.getScheme().equalsIgnoreCase("http")){
	response.sendRedirect("https://dashboard.aesenergystorage.com:8443/pentaho/Dashboard");
}
%>
<html>
<head>
<title>AES Dashboard</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="shortcut icon" href="/pentaho-style/favicon.ico" />
<link href="/pentaho/dashboard/style.css" rel="stylesheet" type="text/css">
<script src="http://code.jquery.com/jquery-latest.js" type="text/javascript"></script>
<script src="/pentaho/dashboard/js/tab.js" type="text/javascript"></script>
<script src="/pentaho/dashboard/js/do_highlight.js" type="text/javascript"></script>


</head>
<body>
<div class="main-div">

<div  id="tab" class="tab-div">
   		<ul>
		        <li><a href="#" onclick = "javascript:getElementById('iframe_a').src='http://www.aesenergystorage.com';" class="logo"><img src="/pentaho/dashboard/images/aeses_logo.png" alt="" width="35" height="32" border="0"></a></li>
            	<li><a href="#" onclick="do_highlightP('Projects');" ><span><span>Projects</span></span></a>
				<ul>
					
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=angamos_changes.wcdf';"><span><span>Angamos</span></span></a></li>
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=LM_changes.wcdf';"><span><span>Laurel Mountain</span></span></a></li>
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=LA_changes.wcdf';"><span><span>Los Andes</span></span></a></li>
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=JC_changes.wcdf';"><span><span>Johnson City</span></span></a></li>
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/ViewAction?solution=AESES&path=Projects&action=Project_Performance.xaction';"><span><span>KPI Report</span></span></a></li>
								

					</ul>
				</li>
                <li><a href="#" onclick="do_highlightP('Projects');" ><span><span>Markets</span></span></a>
				<ul>
					
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=ALL_Markets_Reg.wcdf';"><span><span>Regulation</span></span></a></li>
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=ALL_Markets_Energy.wcdf';"><span><span>Energy</span></span></a></li>
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=Market_Pricing.wcdf';"><span><span>Market Prices</span></span></a></li>
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=Market_Comparison.wcdf';"><span><span>Comparison</span></span></a></li>
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FMarket&file=arbitrator.wcdf';"><span><span>Arbitrage Report</span></span></a></li>
								

					</ul>
				</li>
                <li style="float:right"><a id="logout" href="/pentaho/Logout" ><span><span>Logout</span></span></a></li>
                <li style="float:right;"><a href="#"><span><span>My Account</span></span></a>
			<ul>
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/dashboard/My_applications.jsp';"><span><span>My Applications</span></span></a></li>
					<li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/dashboard/changePassword.jsp';"><span><span>Change Password</span></span></a></li>
			</ul>

		</li>
		
          <li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/Home';" ><span><span>Analysis</span></span></a></li>
		  <li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/dashboard/Collaboration.jsp';" ><span><span>Collaboration</span></span></a></li>
		  <li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/dashboard/Tickets.jsp';" ><span><span>Tickets</span></span></a></li>
		  <li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/dashboard/SCADA.jsp';" ><span><span>SCADA</span></span></a></li>
		  <li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/dashboard/Monitoring.jsp';" ><span><span>Monitoring</span></span></a></li>
		  <li><a href="#" onclick="javascript:getElementById('iframe_a').src='/pentaho/dashboard/Maintenance.jsp';" ><span><span>Maintenance</span></span></a></li>
			


            </ul>
  </div>
    <!---header end-->
	    <div class="main">
    	<div  id="tab" class="tab-div">
        	
        </div>
         <!---tab end-->
        <div class="tab-container">
            <iframe src="http://www.aesenergystorage.com" frameborder="0" name="iframe_a" id="iframe_a" width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>
        </div>
         <!---tab div end-->
	</div>
     <!---main end-->
</div>
 <!---main-container end-->
</body>
</html>
