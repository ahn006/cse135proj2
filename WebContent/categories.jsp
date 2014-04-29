<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Categories</title>
<%@ include file="conn.jsp" %>
</head>
<body>

<table>
	<tr>
	<td><h2>Categories</h2></td>
	<td><a href="products.jsp">Products</a></td>
	</tr>
</table>

<%        boolean deleteError = false; %>

<table>

    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <!--  jsp:include page="/menu.html" / -->
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

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.
                    pstmt = conn
                    .prepareStatement("INSERT INTO categories (name, description) VALUES (?, ?)");


                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setString(2, request.getParameter("description"));
                    //pstmt.setString(4, request.getParameter("last"));
                    int rowCount = pstmt.executeUpdate();

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

                    // Create the prepared statement and use it to
                    // UPDATE student values in the Students table.
                    pstmt = conn
                        .prepareStatement("UPDATE categories SET name = ?, "
                            + "description = ? WHERE id = ?");

                    //pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setString(2, request.getParameter("description"));
                    //pstmt.setString(4, request.getParameter("last"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%



            
            
                // Check if a delete is requested
                if (action != null && action.equals("delete")) {

                    // Begin transaction
                    //conn.setAutoCommit(false);

                    
                    conn.setAutoCommit(false);

		            
		            PreparedStatement pstmt2 = conn.
		            prepareStatement( "SELECT categories.id FROM categories WHERE EXISTS" +
		            " (SELECT classify.* FROM classify WHERE classify.category = categories.id)");
		            ResultSet rs2 = pstmt2.executeQuery();
		            boolean canDelete = true;
		            while(rs2.next()) {
		            	if( rs2.getInt("id") == Integer.parseInt(request.getParameter("id")) ) {
		            		canDelete = false;
		            	}
		            }
		            rs2.close();
		            rs2 = null;
		            pstmt2.close();
		            pstmt2 = null;


                    
                    
                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
                    if( canDelete ) {
	                    pstmt = conn
	                        .prepareStatement("DELETE FROM categories WHERE id = ?");
	
	                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
	                    int rowCount = pstmt.executeUpdate();
	
	                    // Commit transaction
	                    conn.commit();
                    }
                    else {
                    	deleteError = true;
                    }
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM categories");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Name</th>
                <th>Description</th>
            </tr>

            <tr>
                <form action="categories.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    
                    <th><input value="" name="name" size="15"/></th>
                    <th><input value="" name="description" size="15"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
            	conn.setAutoCommit(false);
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="categories.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>

               


                <td>
                    <input value="<%=rs.getString("name")%>" name="name" size="15"/>
                </td>

                <td>
                    <input value="<%=rs.getString("description")%>" name="description" size="15"/>
                </td>


                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="categories.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
                    <%-- Button --%>
                    
                <% PreparedStatement pstmt2 = conn.
                prepareStatement( "SELECT categories.id FROM categories WHERE EXISTS" +
                " (SELECT classify.* FROM classify WHERE classify.category = categories.id)");
                ResultSet rs2 = pstmt2.executeQuery();
                boolean canDelete = true;
                while(rs2.next()) {
                	if( rs2.getInt("id") == rs.getInt("id") ) {
                		canDelete = false;
                	}
                }
                if( canDelete ) { %>
                	<td><input type="submit" value="Delete"/></td>
              <%}
                rs2.close();
                rs2 = null;
                pstmt2.close();
                pstmt2 = null;
            	conn.setAutoCommit(true);

              %> 
                </form>
            </tr>

            <%
                }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();

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

<% if( deleteError ) {
		%>Category could not be deleted as there are still products attached to it<%
	}
%>


</body>
</html>
