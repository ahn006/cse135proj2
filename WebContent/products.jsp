<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Products</title>
<%@ include file="conn.jsp" %>
</head>
<body>


<table>
	<tr>
	<td><h2>Products</h2></td>
	<td><a href="categories.jsp">Categories</a></td>
	
	<td>
		<form method="post" action="products.jsp">
			<input type="text" name="search" placeholder="Search products" />
		</form>
	</td><p>Hello <%=session.getAttribute("name") %></p>
	</td>
	</tr>
</table>


<% boolean insertSuccess = false; 
	if( request.getParameter("filtercategory") != null) {
		if( request.getParameter("filtercategory").equals("All Products") ) {
			session.setAttribute("currentcategory", "categories.name");
		}
		else {
			session.setAttribute("currentcategory", "'" + request.getParameter("filtercategory") + "'");
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
            pstmt = conn
            .prepareStatement("SELECT * from categories");

            rs = pstmt.executeQuery();
            String category = (String)(session.getAttribute("currentcategory"));
            
            %> 

            <ul>
            <li>
            	<form action="products.jsp" method="post">
                <input type="hidden" name="filtercategory" value="All Products"/>
            	<input type="submit" value="All Products" />
            	</form>
            </li>
            
            <%
            
            while( rs.next() ) {
            	%><li>
            		<form action="products.jsp" method="post">
                   	<input type="hidden" name="filtercategory" value="<%=rs.getString("name")%>"/>
   					<input type="submit" value="<%= rs.getString("name") %>" />
   					</form>	
            	</li><%
            }
            
            %> 
            </ul>
            <%
            
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
            %>
            
            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")) {

                 
                    conn.setAutoCommit(false);

					// This first prepared statement inserts the input values into the products
					// table
                    pstmt = conn
                    .prepareStatement("INSERT INTO products (name, sku, price) VALUES (?, ?, ?)");


                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("sku")));
                    pstmt.setDouble(3, Double.parseDouble(request.getParameter("price")));
                    int rowCount = pstmt.executeUpdate();

                    
                    // This second prepared Statement uses the category input value to insert values
                    // into the classify table (which is the relation that links the category table
                    // to the products table)
                    PreparedStatement pstmt2 = conn.
                    		prepareStatement("INSERT INTO classify (product, category) " +
                    		"SELECT products.id, categories.id FROM products, categories " +
                    		"WHERE categories.name = '" + request.getParameter("category") + 
                    		"' AND products.sku = " + request.getParameter("sku"));
                   
                    int rowCount2 = pstmt2.executeUpdate();
                    pstmt2 = null;
                    
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // This updates the products table; the classify/categories tables dont need
                    // to be updated
                    pstmt = conn
                        .prepareStatement("UPDATE products SET name = ?, "
                            + "sku = ?, price = ? WHERE id = ?");


                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("sku")));
                    pstmt.setDouble(3, Double.parseDouble(request.getParameter("price")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    
                    
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    
                    insertSuccess = true;
                }
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("delete")) {

                    // This statement deletes from the classify table first because otherwise 
                    // deleting from the products table will make the classify table have entries
                    // that reference null entries
                    conn.setAutoCommit(false);

                    PreparedStatement pstmt2 = conn.prepareStatement("DELETE FROM classify WHERE product = ?");
                    pstmt2.setInt(1, Integer.parseInt(request.getParameter("id")));
                    int rowCount2 = pstmt2.executeUpdate();
         
                    pstmt2 = null;

                    
                    // This statement deletes from the products table
                    pstmt = conn
                        .prepareStatement("DELETE FROM products WHERE id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                                        
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
            
            	conn.setAutoCommit(false);
                // Create the statement
                Statement statement = conn.createStatement();

                Statement statement2 = conn.createStatement();
                ResultSet rs2 = statement2.executeQuery("SELECT * FROM categories");
                
                
                
                // This first resultset is for setting up the update entries
                
                if( request.getParameter("search") != null) {
    	                rs = statement.executeQuery("SELECT products.*, categories.name as categoryName "
    	                + "FROM products, categories, classify WHERE substring(lower(products.name) from '" + 
    	                request.getParameter("search").toLowerCase() + "') = '" + 
    	                request.getParameter("search").toLowerCase() + "' AND categories.name = " +
    	                category +
    	                " AND classify.product = products.id AND classify.category = categories.id");
                }
                else if( request.getParameter("filtercategory") == null ||
              		request.getParameter("filtercategory").equals("All Products")) {
	                rs = statement.executeQuery("SELECT products.*, categories.name as categoryName "
	                + "FROM products, categories, classify " + 
	                "WHERE classify.product = products.id AND classify.category = categories.id");
                }
                else {
	                while( rs2.next() ) {
	                	if( request.getParameter("filtercategory").equals(rs2.getString("name"))) {
	                		rs = statement.executeQuery("SELECT products.*, categories.name as categoryName "
	           	                + "FROM products, categories, classify " + 
	           	                "WHERE categories.name = '" + rs2.getString("name") + "'" +
	           	                "AND classify.product = products.id AND classify.category = " +
	           	                "categories.id");
	                	}
	                }
                }		
                // This second resultset is for populating the dropdown menus of category
                statement2 = conn.createStatement();
                rs2 = statement2.executeQuery("SELECT * FROM categories");
                
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Name</th>
                <th>SKU</th>
                <th>Price</th>
                <th>Category</th>
            </tr>

            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    
                    <th><input value="" name="name" size="15"/></th>
                    <th><input value="" name="sku" size="15"/></th>
                    <th><input value="" name="price" size="15"/></th>
                    <th><select name="category">
                    	<option />
                    	<% while(rs2.next()) { %>
                    	<option value="<%=rs2.getString("name") %>"><%= rs2.getString("name") %>
                    	</option>

                    	<% } %>
					</select></th>                   	
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
            
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>

               


      
                <td>
                    <input value="<%=rs.getString("name")%>" name="name" size="15"/>
                </td>

       
                <td>
                    <input value="<%=rs.getInt("sku")%>" name="sku" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getDouble("price")%>" name="price" size="15"/>
                </td>
				<td>
					<select name="category"> 
						<option value="<%=rs.getString("categoryName")%>"><%=rs.getString("categoryName") %></option>
						
						<% 
						
						rs2 = statement2.executeQuery("SELECT * FROM categories WHERE categories.name != '"
						+ rs.getString("categoryName") + "'");
						
						while(rs2.next()) { %>
                    	<option value="<%=rs2.getString("name") %>"><%= rs2.getString("name") %>
                    	</option>

                    	<% } %>
						
					</select>
				</td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
                </form>
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
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
        </table>
        </td>
    </tr>





</table>



<% 	if( insertSuccess ) {
		%>Product was successfully inserted<%
	}
%>





</body>
</html>