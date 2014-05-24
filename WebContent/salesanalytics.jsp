<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<%@ page import="com.cse135.group49.project.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CSE135 Sales Analytics</title>
</head>
<body>
<%@include file="header.jsp" %>
<%
if(session.getAttribute("name")!=null)
{
	/* UNCOMMENT TO GENERATE DATA */
	//DataGenerator.main(null); out.println("ok");
}
else
{
    out.println("Please go to home page to login first.");
}
%>
</body>
</html>