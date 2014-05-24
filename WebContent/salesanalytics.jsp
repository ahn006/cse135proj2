<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<%@ page import="com.cse135.group49.project.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CSE135 Sales Analytics</title>
</head>
<body>
<%@include file="header.jsp" %>
<a href="categories.jsp">Categories</a>
<a href="products.jsp">Products</a>
<a href="salesanalytics.jsp">Sales Analytics</a>
<%
if(session.getAttribute("name")!=null)
{
	/* UNCOMMENT TO GENERATE DATA */
	//DataGenerator.main(null); out.println("ok");
	if (request.getParameter("rows") != null) {
		%>
		<%@include file="conn.jsp" %>
		<%
		if (request.getParameter("rows").equals("customers")) {
			stmt = conn.createStatement();
			stmt.execute("DROP TABLE IF EXISTS analytics");
			stmt.execute("CREATE TEMPORARY TABLE analytics AS SELECT uid , pid, SUM(s.quantity*s.price) FROM sales s GROUP BY s.uid, s.pid ORDER BY s.uid, s.pid");
			stmt.execute("CREATE INDEX uid_index ON analytics (uid)");
			
			Statement userstmt = conn.createStatement();
			ResultSet users = userstmt.executeQuery("SELECT id, name FROM users ORDER BY name ASC");
			
            rs = stmt.executeQuery("SELECT id, name FROM products ORDER BY name ASC");
            out.println("<table>");            
            out.println("<tr><td></td>");
            ArrayList<Integer> pids = new ArrayList<Integer>();
            
            while(rs.next()) { 
                out.println("<td>"+rs.getString("name")+"</td>");
                pids.add(rs.getInt("id"));
            }
            
            out.println("</tr>");
            pstmt = conn.prepareStatement("SELECT sum FROM analytics WHERE uid = ? AND pid = ?");
            while (users.next()) {
                out.println("<tr>");
                out.println("<td>" + users.getString("name") + "</td>");
                for (Integer pid : pids ) {
                	pstmt.setInt(1, users.getInt("id"));
                	pstmt.setInt(2, pid);
                	rs = pstmt.executeQuery();
                	if ( !(rs.next()))
                		out.println("<td>0</td>");
                	else
                		out.println("<td>" + rs.getInt("sum") + "</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>");
		}
		else if ( request.getParameter("rows").equals("states")) {
			stmt = conn.createStatement();
            stmt.execute("DROP TABLE IF EXISTS analytics");
            stmt.execute("CREATE TEMPORARY TABLE analytics AS SELECT st.state , pid, SUM(s.quantity*s.price) FROM sales s INNER JOIN (SELECT users.id, users.state FROM users ORDER BY users.state ASC ) As st ON s.uid = st.id GROUP BY st.state, s.pid ORDER BY st.state, s.pid");
            stmt.execute("CREATE INDEX state_index ON analytics (state)");
            
            Statement statestmt = conn.createStatement();
            ResultSet states = statestmt.executeQuery("SELECT state FROM users GROUP BY state ORDER BY state ASC");
            
            rs = stmt.executeQuery("SELECT id, name FROM products ORDER BY name ASC");
            out.println("<table>");            
            out.println("<tr><td></td>");
            ArrayList<Integer> pids = new ArrayList<Integer>();
            
            while(rs.next()) { 
                out.println("<td>"+rs.getString("name")+"</td>");
                pids.add(rs.getInt("id"));
            }
            
            out.println("</tr>");
            pstmt = conn.prepareStatement("SELECT sum FROM analytics WHERE state = ? AND pid = ?");
            while (states.next()) {
                out.println("<tr>");
                out.println("<td>" + states.getString("state") + "</td>");
                for (Integer pid : pids ) {
                    pstmt.setString(1, states.getString("state"));
                    pstmt.setInt(2, pid);
                    rs = pstmt.executeQuery();
                    if ( !(rs.next()))
                        out.println("<td>0</td>");
                    else
                        out.println("<td>" + rs.getInt("sum") + "</td>");
                }
                out.println("</tr>");
            }
		}
	}
	%>
	
	<form method="post">
	   <select name="rows">
	       <option value="customers">Customers</option>
	       <option value="states">States</option>
	   </select>
	   <input type="submit">
	</form>
	<%
}
else
{
    out.println("Please go to home page to login first.");
}
%>
</body>
</html>