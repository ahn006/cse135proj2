<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Checkout</title>
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




	<%
	    // check if user is customer
	        //"products, amounts and prices"  of the current user in Cart table 
	        //total sum of the items
	        //ask for credit card in textbox
	        //post everything when clicked Purchase - send it to confirmation.jsp and remove from the cart.

	    }
	%>
</body>
</html>
