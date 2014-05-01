<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cse135.group49.project.*"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Checkout</title>
<%@include file="conn.jsp"%>

</head>
<body>
<%@include file="header.jsp"%>
<a href="browse.jsp">return to browsing</a>
<%
if ( session.getAttribute("name") == null ) {
    %>
    You need to be <a href="login.jsp"> logged in</a> to purchase.
    <%
}
else if ( session.getAttribute("cart") == null ) {
    %>
    Your cart is empty.
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
        List<Product> products = new ArrayList<Product>(cart.getProducts());
        Integer total = 0;
        %>
        <table>
        <tr><td>Product</td><td>Price</td><td>Quantity</td><td>Total</td></tr>
        <%
        for (Product product : products ) {
            pstmt = conn.prepareStatement("SELECT price FROM products WHERE sku = ?");
            pstmt.setInt(1, product.getProduct());
            rs = pstmt.executeQuery();
            if(!rs.next()) {
                %>
                <tr><td>The product <%= product.getProduct() %> was removed from the database. You can no longer purchase it</td></tr>
                <%
                cart.removeProduct(product);
            }
            else {
                if ( ! ( rs.getInt("price") == product.getPrice() ) ) {
                    %>
                    <tr><td>The price of the product was changed. If you click confirm below, the product will be purchased at the new price. The below price reflects the new price</td></tr>
                    <%
                    product.changePrice(rs.getInt("price"));
                }
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
        }
        session.setAttribute("cart", cart);
        %>
        </table>            
        Total: <%= total %>
        <form action="confirmation.jsp" method="post">
        <input type="hidden" name="action" value="buy" />
            <label for="cc">Enter your credit card number</label>
            <input type="text" name="cc" required />
            <input type="submit" value="Purchase" />
        </form>
        <%
    }
}
%>
</body>
</html>
