<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cse135.group49.project.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Confirmation</title>
<%@include file="conn.jsp"%>

</head>
<body>
	<%@include file="header.jsp"%>
	<a href="browse.jsp">Return to product browsing</a>
	<%
if ( session.getAttribute("name") == null ) {
    %>
	You need to be
	<a href="login.jsp"> logged in</a> to purchase.
	<%
}
else if ( session.getAttribute("cart") == null ) {
    %>
	Your cart was empty.
	<%
}
else if ( request.getParameter("action") == null || ! ( request.getParameter("action").equals("buy") ) ) {
    %>
	Invalid request
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
        %>
	<%
        for (Product product : products ) {
            pstmt = conn.prepareStatement("SELECT id, price FROM products WHERE sku = ?");
            pstmt.setInt(1, product.getProduct());
            rs = pstmt.executeQuery();
            if(!rs.next()) {
                %>
	<p>
		The product
		<%=product.getProduct() %>
		was removed from the database. You can no longer purchase it
	</p>
	<%
                cart.removeProduct(product);
            }
            else {
                if ( ! ( rs.getDouble("price") == product.getPrice() ) ) {
                    %>
	<p>
		The price for product
		<%= product.getProduct() %>
		was changed. You were not billed for it and it remains in your cart
	</p>
	<%
                    product.changePrice(rs.getDouble("price"));
                }
                else {                    
                    Integer pid = rs.getInt("id");
                    pstmt = conn.prepareStatement("SELECT id FROM users WHERE username =?");
                    pstmt.setString(1, session.getAttribute("name").toString());
                    rs = pstmt.executeQuery();
                    rs.next();
                    Integer uid = rs.getInt("id");
                    try {
                        pstmt = conn.prepareStatement("INSERT INTO transactions (user_id, product_id, price, quantity, credit_card) VALUES (?,?,?,?,?)");
                        pstmt.setInt(1, uid);
                        pstmt.setInt(2, pid);
                        pstmt.setDouble(3, product.getPrice());
                        pstmt.setInt(4, product.getQuantity());
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("cc")));
                        int rowCount = pstmt.executeUpdate();
                        %>
	<p>
		Product
		<%= product.getProduct() %>
		was purchased successfully
	</p>
	<%
                        cart.removeProduct(product);
                    }
                    catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                }                
            }
        }
    }
}
%>
</body>
</html>
