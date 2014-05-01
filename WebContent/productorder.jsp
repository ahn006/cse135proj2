<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Product Order</title>
<%@include file="conn.jsp"%>

</head>
<body>
	<%
	    //to check random landing on pages. Checks if the user is logged in or not
	    if (session.getAttribute("name") == null) {
	%>
	<p>User Not logged In</p>
	<%
	    } else {
	%>

	<p>
		Hello
		<%=session.getAttribute("name")%></p>

	<a href="/CSE135Project/checkout.jsp">Buy Shopping Cart</a>


	<%
	    //check if user is customer 
	        //the product from product browsing page,ask for qty textbox, submit button (redirects to browsing page)

	        //display what all exists from table cart

	    }
	%>
</body>
</html>
