<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

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
<div class="main-div" id="dashboard">
<div  id="tab" class="tab-div">
   		<ul>
		        <li><a href="http://www.aesenergystorage.com/" target="_blank" class="logo"><img src="/pentaho/dashboard/images/aeses_logo.png" alt="" width="43" height="39" border="0"></a></li>
            	 <li><a href="#" onclick="do_highlightP('Projects');"><span><span>Projects</span></span></a>
				<ul>
					<li><a href="#" onclick="do_highlightProjects('All projects');"><span><span>All projects</span></span></a></li>
					<li><a href="#" onclick="do_highlightProjects('LM');"><span><span>Laurel Mountain</span></span></a></li>
					<li><a href="#" onclick="do_highlightProjects('LA');"><span><span>Los Andes</span></span></a></li>
					<li><a href="#" onclick="do_highlightProjects('JC');"><span><span>Johnson City</span></span></a></li>
					<li><a href="#" onclick="do_highlightProjects('LM_KPIS');"><span><span>KPI Report</span></span></a></li>

					</ul>
		  </li>

                <li><a href="#" onclick="do_highlightM('Markets');"><span><span>Markets</span></span></a>
			<ul>
					<li><a href="#" onclick="do_highlightMarkets('All Markets');"><span><span>Regulation</span></span></a></li>
					<!--<li><a href="#" onclick="do_highlightMarkets('NYISO');"><span><span>NYISO</span></span></a></li>-->
					<li><a href="#" onclick="do_highlightMarkets('Dashboard');"><span><span>Market Prices</span></span></a></li>
					<li><a href="#" onclick="do_highlightMarkets('Comparision');"><span><span>Comparision</span></span></a></li>
					</ul>

		</li>

                 <li style="float:right"><a id="logout" href="/pentaho/Logout" ><span><span>Logout</span></span></a></li>
                <li style="float:right;"><a href="#"><span><span>My Account</span></span></a>
			<ul>
					<li><a href="#" onclick="do_highlight('users');"><span><span>My Applications</span></span></a></li>
			</ul>

		</li>

                <li><a href="#" onclick="do_highlight('Analysis');" ><span><span>Analysis</span></span></a></li>
             <li><a href="#" onclick="do_highlight('Collaboration');" ><span><span>Collaboration</span></span></a></li>
                <li><a href="#" onclick="do_highlight('tickets');" ><span><span>Tickets</span></span></a></li>
                <li><a href="#" onclick="do_highlight('SCADA');" ><span><span>SCADA</span></span></a></li>
		
		<li><a href="http://enst01nm01pr.aesenergystorage.com:8080/zport/dmd/" target="windowName" ><span><span>Monitoring</span></span></a></li>
		<!--<li><a href="#" onclick="do_highlight('Monitoring');" ><span><span>Monitoring</span></span></a></li>-->
		<li><a href="#" onclick="do_highlight('Maintenance');" ><span><span>Maintenance</span></span></a></li>

		</ul>


  </div>

<div id='All projects' style="visibility:hidden;">
<iframe src="/pentaho/content/reporting/reportviewer/report.html?solution=AESES&path=%2FProjects&name=KPI_Reports_JC_html.prpt" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto"></iframe>	
</div>

<div id='LM'>
<iframe src="/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=LM_project.wcdf" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='LA' style="visibility:hidden;">
<iframe src="/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=LA_project.wcdf" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='JC' style="visibility:hidden;">
<iframe src="/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=JC_project.wcdf" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>


<div id='All Markets' style="visibility:hidden;">
<iframe src="/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=ALL_markets.wcdf" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='NYISO' style="visibility:hidden;">
<iframe src="/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=NYISO.wcdf" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='Dashboard' style="visibility:hidden;">
<iframe src="/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=AES_nyiso.wcdf" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='Comparision' style="visibility:hidden;">
<iframe src="/pentaho/content/pentaho-cdf-dd/Render?solution=AESES&path=%2FDEV_Verification&file=comparison_report2.wcdf" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>


<div id='Analysis' style="visibility:hidden;">
<iframe src="/pentaho/Home" name="iframe_analysis" id="iframe_analysis"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='Collaboration' style="visibility:hidden;">
<iframe src="/pentaho/dashboard/Collaboration.jsp"  name="iframe_collaboration" id="iframe_collaboration"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='tickets' style="visibility:hidden;">
<iframe src="/pentaho/dashboard/Tickets.jsp" name="iframe_tickets" id="iframe_tickets"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>
</div>

<div id='SCADA' style="visibility:hidden;">
<iframe src="http://enst01ap01pr.aesenergystorage.com:8080/" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='Monitoring' style="visibility:hidden;">
<iframe src="http://enst01nm01pr.aesenergystorage.com:8080/zport/dmd/" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='Maintenance' style="visibility:hidden;">
<iframe src="https://aesenergystorage.macmms.com/" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='users' style="visibility:hidden;">
<iframe src="/pentaho/dashboard/My_applications.jsp" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>

<div id='LM_KPIS' style="visibility:hidden;">
<iframe src="/pentaho/ViewAction?solution=AESES&path=Projects&action=LM_monthly.xaction" name="iframe_a" id="iframe_a"  width="100%" height="93%" scrolling="auto" style="position:fixed;top:39px;"></iframe>	
</div>
</div>

</body>
</html>