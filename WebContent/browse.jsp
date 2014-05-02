<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cse135.group49.project.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Product Browsing</title>
<%@ include file="conn.jsp"%>
</head>
<body>
	<%@ include file="header.jsp"%>
	<%
	    if (session.getAttribute("name") == null) {
	        %>
	        Search functionality is reserved for logged in users. Please
	        <a href="login.jsp">login</a>.
	        <%
	    } 
	    else {
	        if (session.getAttribute("cart") == null) {
	            %>
	            Your cart is empty
	            <%
	        } 
	        else {
	            Cart cart = (Cart) session.getAttribute("cart");
	            if (cart.getProducts().size() > 0) {
	                %>
	                <%=cart.getProducts().size() %>
	                items in cart.
	                <a href="cart.jsp">Buy</a>
	                <%
	            } 
	            else {
	                %>
	                Your cart is empty
	                <%
	            }
	        }
	%>
	<table>
		<tr>
			<td><h2>Product Browsing</h2></td>
			<td>
				<form method="post" action="browse.jsp">
					<input type="text" name="search" placeholder="Search products" />
				</form>
			</td>
		</tr>
	</table>
	<%
	    }

	    if (request.getParameter("filtercategory") != null) {
	        if (request.getParameter("filtercategory").equals(
	                "All Products")) {
	            session.setAttribute("currentcategory", "categories.name");
	        } else {
	            session.setAttribute("currentcategory",
	                    "'" + request.getParameter("filtercategory") + "'");
	        }
	    }
	%>

	<table>

		<tr>
			<td valign="top">
				<%
				    conn.setAutoCommit(false);

				    // This first prepared statement inserts the input values into the products
				    // table
				    pstmt = conn.prepareStatement("SELECT * from categories");

				    rs = pstmt.executeQuery();
				    String category = (String) (session.getAttribute("currentcategory"));
				%>

				<ul>
					<li>
						<form action="browse.jsp" method="post">
							<input type="hidden" name="filtercategory" value="All Products" />
							<input type="submit" value="All Products" />
						</form>
					</li>

					<%
					    while (rs.next()) {
					%><li>
						<form action="browse.jsp" method="post">
							<input type="hidden" name="filtercategory"
								value="<%=rs.getString("name")%>" /> <input type="submit"
								value="<%=rs.getString("name")%>" />
						</form>
					</li>
					<%
					    }
					%>
				</ul> <%
     conn.setAutoCommit(true);

     rs.close();
     rs = null;
     pstmt.close();
     pstmt = null;
 %>
			</td>
			<td>
				<%
				    try {
				%> <%-- -------- SELECT Statement Code -------- --%> <%
     conn.setAutoCommit(false);
         // Create the statement
         Statement statement = conn.createStatement();

         Statement statement2 = conn.createStatement();
         ResultSet rs2 = statement2
                 .executeQuery("SELECT * FROM categories");

         // This first resultset is for setting up the update entries

         if (request.getParameter("search") != null) {
             rs = statement
                     .executeQuery("SELECT products.*, categories.name as categoryName "
                             + "FROM products, categories, classify WHERE substring(lower(products.name) from '"
                             + request.getParameter("search")
                                     .toLowerCase()
                             + "') = '"
                             + request.getParameter("search")
                                     .toLowerCase()
                             + "' AND categories.name = "
                             + category
                             + " AND classify.product = products.id AND classify.category = categories.id");
         } else if (request.getParameter("filtercategory") == null
                 || request.getParameter("filtercategory").equals(
                         "All Products")) {
             rs = statement
                     .executeQuery("SELECT products.*, categories.name as categoryName "
                             + "FROM products, categories, classify "
                             + "WHERE classify.product = products.id AND classify.category = categories.id");
         } else {
             while (rs2.next()) {
                 if (request.getParameter("filtercategory").equals(
                         rs2.getString("name"))) {
                     rs = statement
                             .executeQuery("SELECT products.*, categories.name as categoryName "
                                     + "FROM products, categories, classify "
                                     + "WHERE categories.name = '"
                                     + rs2.getString("name")
                                     + "'"
                                     + "AND classify.product = products.id AND classify.category = "
                                     + "categories.id");
                 }
             }
         }
         // This second resultset is for populating the dropdown menus of category
         statement2 = conn.createStatement();
         rs2 = statement2.executeQuery("SELECT * FROM categories");
 %> <!-- Add an HTML table header row to format the results -->
				<table border="1">
					<tr>
						<th>Name</th>
						<th>SKU</th>
						<th>Price</th>
						<th>Category</th>
					</tr>


					<%-- -------- Iteration Code -------- --%>
					<%
					    // Iterate over the ResultSet
					        while (rs.next()) {
					%>

					<tr>



						<%-- Get the first name --%>
						<td><%=rs.getString("name")%></td>

						<%-- Get the middle name --%>
						<td><%=rs.getInt("sku")%></td>

						<td><%=rs.getDouble("price")%></td>
						<td><%=rs.getString("categoryName")%></td>
						<td><a href="productorder.jsp?product=<%= rs.getInt("id") %>">Order</a></td>
					</tr>

					<%
					    }
					%>

					<%-- -------- Close Connection Code -------- --%>
					<%
					    // Close the ResultSet
					        rs.close();
					        rs2.close();
					        // Close the Statement
					        statement.close();
					        statement2.close();

					        conn.setAutoCommit(true);

					        // Close the Connection
					        conn.close();
					    } catch (SQLException e) {

					        // Wrap the SQL exception in a runtime exception to propagate
					        // it upwards
					        throw new RuntimeException(e);
					    } finally {
					        // Release resources in a finally block in reverse-order of
					        // their creation

					        if (rs != null) {
					            try {
					                rs.close();
					            } catch (SQLException e) {
					            } // Ignore
					            rs = null;
					        }
					        if (pstmt != null) {
					            try {
					                pstmt.close();
					            } catch (SQLException e) {
					            } // Ignore
					            pstmt = null;
					        }
					        if (conn != null) {
					            try {
					                conn.close();
					            } catch (SQLException e) {
					            } // Ignore
					            conn = null;
					        }
					    }
					%>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>