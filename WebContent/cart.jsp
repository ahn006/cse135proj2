<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.cse135.group49.project.*"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Cart</title>
<%@include file="conn.jsp"%>

</head>
<body>
<%@include file="header.jsp"%>
<%
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
            Product product = new Product( Integer.parseInt(request.getParameter("sku")),
                                           Integer.parseInt(request.getParameter("quantity")),
                                           Integer.parseInt(request.getParameter("price"))
                                         );
            cart.addProduct(product);
            session.setAttribute("cart", cart);
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
            Integer total = 0;
            %>
            <table>
            <tr><td>Product</td><td>Price</td><td>Quantity</td><td>Total</td></tr>
            <%
            for (Product product : products ) {
                %>
                <tr>
                <td>
                    <%= product.getProduct() %>
                </td>
                <td>
                    <%= product.getPrice() %>
                </td>
                <td>
                    <%= product.getQuantity() %>
                </td>
                <td>
                    <%= product.getPrice()*product.getQuantity() %>
                    <% total += product.getPrice()*product.getQuantity(); %>
                </td>
                </tr>
                <%
            }
            %>
            </table>            
            Total: <%= total %>
            <a href="checkout.jsp">Buy Cart</a>
            <%
        }
        
    }
}
%>
</body>
</html>