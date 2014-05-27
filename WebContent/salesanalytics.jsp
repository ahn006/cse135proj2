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
<%@include file="conn.jsp" %>
<%

double start = System.nanoTime();
int[] ageArr = {0, 125}; //new int[2];
if(request.getParameter("ageFilter") != null) {
	String[] temp = request.getParameter("ageFilter").split("-");
	ageArr[0] = Integer.parseInt(temp[0]);
	ageArr[1] = Integer.parseInt(temp[1]);
	session.setAttribute("ageFilter", true);
}
String state = "%";
if(request.getParameter("stateFilter") != null ) {
	state = request.getParameter("stateFilter");
}
if(request.getParameter("nofilter") != null) {
	session.setAttribute("nofilter", "true");
}
if(session.getAttribute("rowOffset") == null ) {
	session.setAttribute("rowOffset", 0);
}
if(request.getParameter("rowOffset") != null ) {	
	String current = (session.getAttribute("rowOffset")).toString();
	if ( Integer.parseInt(request.getParameter("rowOffset")) == 0) {
		session.setAttribute("rowOffset", 0 );
	}
	else {
		session.setAttribute("rowOffset", Integer.parseInt(current) + 20 );
	}
}
if(session.getAttribute("colOffset") == null ) {
	session.setAttribute("colOffset", 0);
}
if(request.getParameter("colOffset") != null ) {
	String current = (session.getAttribute("colOffset")).toString();
	if ( Integer.parseInt(request.getParameter("colOffset")) == 0) {
		session.setAttribute("colOffset", 0 );
	}
	else {
		session.setAttribute("colOffset", Integer.parseInt(current) + 10 );
	}
}
int rowCnt = 0;
int colCnt = 0;
Statement cat = conn.createStatement();
ResultSet catRS = cat.executeQuery("SELECT name from categories"); 

if(session.getAttribute("name")!=null)
{
	/* UNCOMMENT TO GENERATE DATA */
	//DataGenerator.main(null); out.println("ok");
	if (request.getParameter("rows") != null) {
		%>

		<%
		if (request.getParameter("rows").equals("customers")) {
			stmt = conn.createStatement();
			stmt.execute("DROP TABLE IF EXISTS analytics");
			stmt.execute("CREATE TEMPORARY TABLE analytics AS SELECT uid , pid, SUM(s.quantity*s.price) FROM sales s GROUP BY s.uid, s.pid ORDER BY s.uid, s.pid");
			stmt.execute("CREATE INDEX uid_index ON analytics (uid)");
			
			Statement userstmt = conn.createStatement();
			ResultSet users = null;
			PreparedStatement pStat = conn.prepareStatement("SELECT id, name FROM users WHERE users.age >= ? AND users.age < ? AND state LIKE ? ORDER BY name ASC LIMIT 20 OFFSET " + session.getAttribute("rowOffset")); 
			/*
			if( session.getAttribute("ageFilter") == null ) {
				users = userstmt.executeQuery("SELECT id, name FROM users ORDER BY name ASC LIMIT 20 OFFSET " + session.getAttribute("rowOffset"));
			}
			else {
				PreparedStatement pStat = conn.prepareStatement("SELECT id, name FROM users WHERE users.age >= ? AND users.age < ? ORDER BY name ASC LIMIT 20 OFFSET " + session.getAttribute("rowOffset"));  
				pStat.setInt(1, ageArr[0]);
				pStat.setInt(2, ageArr[1]);
				users = pStat.executeQuery();
			}*/
			int nextOffset = Integer.parseInt(session.getAttribute("rowOffset").toString()) + 20;
			PreparedStatement pStat2 = conn.prepareStatement("SELECT id, name FROM users WHERE users.age >= ? AND users.age < ? AND state LIKE ? ORDER BY name ASC LIMIT 20 OFFSET " + nextOffset); 
			
			pStat.setInt(1, ageArr[0]);
			pStat.setInt(2, ageArr[1]);
			pStat.setString(3, state);

			pStat2.setInt(1, ageArr[0]);
			pStat2.setInt(2, ageArr[1]);
			pStat2.setString(3, state);
			
			users = pStat.executeQuery();
			
			
			
			PreparedStatement pro = conn.prepareStatement("SELECT products.id, products.name FROM products, categories WHERE categories.name LIKE ? AND categories.id = products.cid ORDER BY name ASC LIMIT 10 OFFSET " + session.getAttribute("colOffset"));
			pro.setString(1, request.getParameter("categoryFilter"));
			rs = pro.executeQuery();
			
			PreparedStatement pro2 = conn.prepareStatement("SELECT products.id, products.name FROM products, categories WHERE categories.name LIKE ? AND categories.id = products.cid ORDER BY name ASC LIMIT 10 OFFSET " + session.getAttribute("colOffset"));
			pro2.setString(1, request.getParameter("categoryFilter"));
			ResultSet nextPro = pro2.executeQuery();
			
			//int temp = (Integer.parseInt(session.getAttribute("rowOffset").toString()) + 20);
			Statement stmt2 = conn.createStatement();
            /*ResultSet nextCus = stmt2.executeQuery("SELECT id, name FROM users ORDER BY name ASC LIMIT 20 OFFSET " + temp);
            */
            ResultSet nextCus = pStat2.executeQuery();
            while(nextCus.next()) {
            	rowCnt++;
            }
            
            int temp = (Integer.parseInt(session.getAttribute("colOffset").toString()) + 10);
            //ResultSet nextPro = stmt2.executeQuery( "SELECT id, name FROM products ORDER BY name ASC LIMIT 10 OFFSET " + temp );
  
            while(nextPro.next()) {
            	colCnt++;
            }
            //stmt2.close();
            //nextCus.close();
            nextPro.close();
            
            
            
            out.println("<table>");            
            out.println("<tr><td></td>");
            ArrayList<Integer> pids = new ArrayList<Integer>();
           
            while(rs.next()) { 
                out.println("<td><b>"+rs.getString("name")+"</b></td>");
                pids.add(rs.getInt("id"));
            }
            
            out.println("</tr>");
            pstmt = conn.prepareStatement("SELECT sum FROM analytics WHERE uid = ? AND pid = ?");
            
            while (users.next()) {
            	PreparedStatement pstmt2 = conn.prepareStatement("SELECT SUM(sum) as total FROM analytics WHERE uid = ?");
            	pstmt2.setInt(1, users.getInt("id"));
      
            	ResultSet rs2 = pstmt2.executeQuery();
            	rs2.next();
                out.println("<tr>");
                out.println("<td><b>" + users.getString("name") + "($" + rs2.getInt("total") + ")" + "</b></td>");
             
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
		conn.close();
		double end = System.nanoTime();
		out.println("<h2>" + ((end - start) / 1000000000.0 )+ "</h2>");
	}
	else { // Action was null so analytics page was just started
		rowCnt = 20; // initialize these vars so that the buttons will show on the page just
		colCnt = 10; // starting up
	}
	%>
	<%= rowCnt %>
	<%
	if (session.getAttribute("nofilter") == null || session.getAttribute("nofilter").toString().equals("false")) 
	{
	%>
	<form method="post">
	   <select name="rows">
	       <option value="customers">Customers</option>
	       <option value="states">States</option>
	   </select>
	   <select name="ageFilter">
	   	   <option value="0-125">All Ages</option>
	       <option value="12-18">12-18</option>
	       <option value="18-45">18-45</option>
	       <option value="45-65">45-65</option>
	       <option value="65-125">65-</option>
	   </select>
	   <select name="stateFilter">
	       <option value="%">All States</option>
	       <%@include file="states.html" %>
	   </select>
	   <select name="categoryFilter">
	       <option value="%">All Categories</option>
	       <%
	       while( catRS.next()) {
	    	   %> <option value="<%= catRS.getString("name") %>"><%= catRS.getString("name") %></option> <%
	       }
	       catRS.close();
	       cat.close();
	       %>
	   </select>
	   <input type="hidden" name="rowOffset" value=0 />
	   <input type="hidden" name="colOffset" value=0 />
	   <input type="submit">
	</form>
	
	<%
	//session.setAttribute("ageFilter", null);
	}
	session.setAttribute("nofilter", null);
	if (rowCnt > 0) {
	%>
	<form method="post">
		<input type="hidden" name="rows" value="<%= request.getParameter("rows")%>" />
		<input type="hidden" name="nofilter" value="true" />
		<input type="hidden" name="stateFilter" value="<%= request.getParameter("stateFilter") %>" />
		<input type="hidden" name="categoryFilter" value="<%= request.getParameter("categoryFilter") %>" />
		<%
		if (session.getAttribute("ageFilter") != null) {
		%>
		<input type="hidden" name="ageFilter" value="<%= request.getParameter("ageFilter") %>" />
		<%
		}
		session.setAttribute("ageFilter", null);
		%>
		<button name="rowOffset" value=20>Next 20 customers</button>
	</form>
	<%
	}
	if (colCnt > 0) {
	%>
	<form method="post">
		<input type="hidden" name="rows" value="<%= request.getParameter("rows")%>" />
		<input type="hidden" name="nofilter" value="true" />
		<input type="hidden" name="ageFilter" value="<%= request.getParameter("ageFilter") %>" />
		<input type="hidden" name="categoryFilter" value="<%= request.getParameter("categoryFilter") %>" />
		<input type="hidden" name="stateFilter" value="<%= request.getParameter("stateFilter") %>" />
		<button name="colOffset" value=10>Next 10 products</button>
	</form>
	<%
	}

}
else
{
    out.println("Please go to home page to login first.");
}
%>
</body>
</html>