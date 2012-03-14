var prev = 'Analysis';
var market = 'All Markets';
var project = 'LM';

function do_highlight(name)
{
if(prev)
{
document.getElementById(prev).style.visibility = 'hidden';
}
document.getElementById(name).style.visibility = 'visible';
document.getElementById(market).style.visibility = 'hidden';
document.getElementById(project).style.visibility = 'hidden';
prev = name;
}



function do_highlightMarkets(name)
{
if(market)
{
document.getElementById(market).style.visibility = 'hidden';
}
document.getElementById(name).style.visibility = 'visible';
document.getElementById(prev).style.visibility = 'hidden';
document.getElementById(project).style.visibility = 'hidden';
market = name;
}


function do_highlightProjects(name)
{
if(project)
{
document.getElementById(project).style.visibility = 'hidden';
}
document.getElementById(name).style.visibility = 'visible';
document.getElementById(prev).style.visibility = 'hidden';
document.getElementById(market).style.visibility = 'hidden';
project = name;
}

function do_highlightP(name)
{
document.getElementById(project).style.visibility = 'visible';
document.getElementById(prev).style.visibility = 'hidden';
document.getElementById(market).style.visibility = 'hidden';
}

function do_highlightM(name)
{
document.getElementById(project).style.visibility = 'hidden';
document.getElementById(prev).style.visibility = 'hidden';
document.getElementById(market).style.visibility = 'visible';
}