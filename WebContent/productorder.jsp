<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cse135.group49.project.*"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Product Order</title>
<%@include file="conn.jsp"%>

</head>
<body>
<%
try{
if ( session.getAttribute("name") == null) {
    %>
    You must be logged in to view cart. <a href="login.jsp">Login</a>
    <%
}
else {
    %>
    <a href="browse.jsp">Return to product browsing</a>
    <%
    if ( request.getParameter("action") != null && request.getParameter("action").equals("add") ) {
        
        if ( request.getParameter("sku") == null ) {
            %>
            Something went wrong with adding the product to cart. Please try again.
            <%
        }
        else if ( request.getParameter("sku") == null ) {
            %>
            Something went wrong with adding the product to cart. Please try again.
            <%
        }
        else if ( request.getParameter("price") == null ) {
            %>
            Something went wrong with adding the product to cart. Please try again.
            <%
        }
        else if ( request.getParameter("quantity") == null ) {
            %>
            Something went wrong with adding the product to cart. Please try again.
            <%
        }
        else if ( Integer.parseInt(request.getParameter("quantity")) < 1 ) {
            %>
            Invalid product quantity;
            <%
        }
        else {
            Cart cart;
            if ( session.getAttribute("cart") == null) {
                cart = new Cart(session.getAttribute("name").toString());
                }
            else {
                cart = (Cart) session.getAttribute("cart");
                }
            Product product = new Product( request.getParameter("product"),
            							   Integer.parseInt(request.getParameter("sku")),
                                           Integer.parseInt(request.getParameter("quantity")),
                                           Double.parseDouble(request.getParameter("price"))
                                         );
            cart.addProduct(product);
            session.setAttribute("cart", cart);
            session.setAttribute("currentproduct", request.getParameter("product"));
            response.sendRedirect("cart.jsp");
        }
        
    }
    if (session.getAttribute("cart") == null ) {
        %>
        Cart is empty
        <%
    }
    else {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart.getProducts().size() == 0 ) {
            %>
            Cart is empty
            <%
        }
        else {
            List<Product> products = cart.getProducts();
            Double total = 0.0;
            %>
            <table>
            <tr><td>Product</td><td>SKU</td><td>Price</td><td>Quantity</td><td>Total</td></tr>
            <%
            for (Product product : products ) {
                %>
                <tr>
                <td>
                	<% if( product.getName().equals(session.getAttribute("currentproduct"))) { %>
                    <%= product.getName() + " (last item added)" %>
                    <%} else { %>
                    <%= product.getName() %>
                    <%} %> 
                </td>
                <td>
                	<%= product.getProduct() %>
                </td>
                <td>
                    <%= String.format( "%.2f", product.getPrice()) %>
                </td>
                <td>
                    <%= product.getQuantity() %>
                </td>
                <td>
                    <%= String.format( "%.2f", product.getPrice()*product.getQuantity() ) %>
                    <% total += product.getPrice()*product.getQuantity(); %>
                </td>
                </tr>
                <%
            }
            %>
            </table>            
            Total: <%= String.format( "%.2f", total) %>
            
        
            <%
        }
        
    }
}
}
catch(Exception e)
{
	 %>
	    <p> An error occurred: <%=e.getMessage() %></p>
	    <%
}

%>
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
            <label for="product">Product Name: </label>
            <input type="text" name="product" value="<%= rs.getString("name") %>" readonly />
            <label for="price">Price: $</label>
            <input type="text" name="price" value="<%= rs.getDouble("price") %>" readonly />
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
