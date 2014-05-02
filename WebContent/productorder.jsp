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
<%@include file="header.jsp"%>
<%
if (request.getParameter("product") == null ) {
    %> 
    No product selected. Return to <a href="browse.jsp">Product Browsing</a>
    <%
}
else if ( session.getAttribute("name") == null ) { 
    %>
    You need to be logged in to order items. Please <a href="login.jsp">login</a>
    <%
}
else {
    try {
    Integer product = Integer.parseInt(request.getParameter("product"));
    pstmt = conn.prepareStatement("SELECT name, price, sku FROM products WHERE id =?");
    pstmt.setInt(1, product);
    rs = pstmt.executeQuery();
    while(rs.next()) {
        %>
        <form action = "cart.jsp" method="POST">
            <input type="hidden" name="action" value="add" />
            <input type="hidden" name="sku" value="<%= rs.getInt("sku") %>" />
            <label for="product">Product Name; </label>
            <input type="text" name="product" value="<%= rs.getString("name") %>" readonly />
            <label for="price">Price: $</label>
            <input type="text" name="price" value="<%= rs.getInt("price") %>" readonly />
            <label for="quantity">Enter quantity:</label>
            <input type="text" name="quantity" value="1"/>
            <input type="submit" value="Add to cart" />
        </form>
        <%
    }
    }
    catch(Exception e) {
    %>
    <p> An error occurred: <%=e.getMessage() %></p>
    <%
        
    }
}
%>
</body>
</html>
