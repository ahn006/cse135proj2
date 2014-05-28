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
			//get offsets
			int rowOffset = Integer.parseInt(session.getAttribute("rowOffset").toString());
            int colOffset = (Integer.parseInt(session.getAttribute("colOffset").toString()));
            //create the queries
            String userQuery = "SELECT id, name FROM users WHERE age >= ? AND age < ? AND state LIKE ? ORDER BY name ASC LIMIT 20 OFFSET " + rowOffset;
            String prodQuery = "SELECT products.id, products.name FROM products, categories WHERE categories.name LIKE ? AND categories.id = products.cid ORDER BY name ASC LIMIT 10 OFFSET " + colOffset;
			String allQuery = "SELECT SUM(quantity* sales.price) AS total, SelectedProducts.name, SelectedUsers.name " +
			        " FROM sales " +
			        " RIGHT OUTER JOIN (" + prodQuery + ") As SelectedProducts ON sales.pid = SelectedProducts.id " + 
			        " INNER JOIN (" + userQuery + ") As SelectedUsers ON SelectedUsers.id = sales.uid " +
			        " GROUP BY SelectedProducts.name, SelectedUsers.name " + 
			        " ORDER BY SelectedUsers.name";
			//execute queries
			//All query
		    pstmt = conn.prepareStatement(allQuery);
		    pstmt.setString(1, request.getParameter("categoryFilter"));
		    pstmt.setInt(2, ageArr[0]);
		    pstmt.setInt(3, ageArr[1]);
		    pstmt.setString(4, state);
		    ResultSet allResults = pstmt.executeQuery();
		    
		    //User query
		    pstmt = conn.prepareStatement(userQuery);
		    pstmt.setInt(1, ageArr[0]);
            pstmt.setInt(2, ageArr[1]);
            pstmt.setString(3, state);
            ResultSet userResults = pstmt.executeQuery();
		    //Product query
		    pstmt = conn.prepareStatement(prodQuery);
		    pstmt.setString(1, request.getParameter("categoryFilter"));
            ResultSet prodResults = pstmt.executeQuery();
            
            String[] products = new String[10];
            out.println("<table>");
            out.println("<tr>");
            out.println("<td></td>");
            
            int i = 0;
            //print out the column header with the product names and stores the product names in an array
            while(prodResults.next()) {
                out.println("<td>" + prodResults.getString("name") + "</td>");
                products[i++] = prodResults.getString("name");
            }
            out.println("</tr>");
            
            //for each users, prints out a row with the product totals
            while(userResults.next()) {
                out.println("<tr>");
                out.println("<td>" + userResults.getString("name") + "</td>");
                //print out total of each product for the user
                out.println("</tr>");
            }
            out.println("</table>");        
		}
		else if ( request.getParameter("rows").equals("states")) {
			stmt = conn.createStatement();
            stmt.execute("DROP TABLE IF EXISTS analytics");
            stmt.execute("CREATE TEMPORARY TABLE analytics AS SELECT st.state , s.uid, pid, SUM(s.quantity*s.price) FROM sales s INNER JOIN (SELECT users.id, users.state FROM users ORDER BY users.state ASC ) As st ON s.uid = st.id GROUP BY st.state, s.pid, s.uid ORDER BY st.state, s.pid");
            stmt.execute("CREATE INDEX state_index ON analytics (state)");
            
            Statement statestmt = conn.createStatement();
            PreparedStatement pStat = conn.prepareStatement("SELECT state FROM users WHERE age >= ? AND age < ? AND state LIKE ? GROUP BY state ORDER BY state ASC LIMIT 20 OFFSET " + session.getAttribute("rowOffset"));
            //ResultSet states = statestmt.executeQuery("SELECT state FROM users GROUP BY state ORDER BY state ASC");
			pStat.setInt(1, ageArr[0]);	
			pStat.setInt(2, ageArr[1]);            
			pStat.setString(3, state);
			
			ResultSet states = pStat.executeQuery();
			
			int nextOffset = Integer.parseInt(session.getAttribute("rowOffset").toString()) + 20;
            PreparedStatement nextStates = conn.prepareStatement("SELECT state FROM users WHERE age >= ? AND age < ? AND state LIKE ? GROUP BY state ORDER BY state ASC LIMIT 20 OFFSET " + nextOffset);
			nextStates.setInt(1, ageArr[0]);	
			nextStates.setInt(2, ageArr[1]);            
			nextStates.setString(3, state);
			ResultSet next20 = nextStates.executeQuery();
			while(next20.next()) {
				rowCnt++;
			}
			
			
            PreparedStatement pStat2 = conn.prepareStatement("SELECT products.id, products.name FROM products, categories WHERE categories.name LIKE ? AND categories.id = products.cid ORDER BY name ASC LIMIT 10 OFFSET " + session.getAttribute("colOffset"));
            //rs = stmt.executeQuery("SELECT id, name FROM products ORDER BY name ASC");
			pStat2.setString(1, request.getParameter("categoryFilter"));
            rs = pStat2.executeQuery();
			
			int temp = (Integer.parseInt(session.getAttribute("colOffset").toString()) + 10);
			PreparedStatement pStat3 = conn.prepareStatement("SELECT products.id, products.name FROM products, categories WHERE categories.name LIKE ? AND categories.id = products.cid ORDER BY name ASC LIMIT 10 OFFSET " + temp);
			pStat3.setString(1, request.getParameter("categoryFilter"));
			ResultSet nextP = pStat3.executeQuery();
            while(nextP.next()) {
            	colCnt++;
            }
            
            out.println("<table>");            
            out.println("<tr><td></td>");
            ArrayList<Integer> pids = new ArrayList<Integer>();
            
            
            PreparedStatement pst = conn.prepareStatement("SELECT SUM(sum) as total FROM analytics join (SELECT id FROM users WHERE users.age >= ? AND users.age < ? AND state LIKE ?) AS foo ON analytics.uid = foo.id WHERE analytics.pid = ?");
            pst.setInt(1, ageArr[0]);
            pst.setInt(2, ageArr[1]);
            pst.setString(3, state);
            while(rs.next()) { 
            	pst.setInt(4, rs.getInt("id"));
            	ResultSet foo = pst.executeQuery();
            	int total = 0;
            	if( foo.next()) {
            		total = foo.getInt("total");
            	}
                out.println("<td><b>"+rs.getString("name")+ " ($" + total + ")" + "</b></td>");
                pids.add(rs.getInt("id"));
            }
            
            out.println("</tr>");
            pstmt = conn.prepareStatement("SELECT sum FROM analytics JOIN (SELECT id FROM users WHERE age >= ? AND age < ?) AS foo ON analytics.uid = foo.id WHERE state = ? AND pid = ?");
			pstmt.setInt(1, ageArr[0]);
			pstmt.setInt(2, ageArr[1]);
            while (states.next()) {
            	//PreparedStatement pstmt2 = conn.prepareStatement("SELECT SUM(sum) as total FROM analytics JOIN (SELECT products.id FROM products, categories WHERE categories.name LIKE ? AND categories.id = products.cid) AS s ON s.id = analytics.pid WHERE state LIKE ?");
            	PreparedStatement pstmt2 = conn.prepareStatement("SELECT SUM(sum) as total FROM (analytics JOIN (SELECT id FROM users WHERE state = ? AND age >= ? AND age < ?) as foo ON analytics.uid = foo.id) as bar JOIN (SELECT products.id FROM products, categories WHERE categories.name LIKE ? AND products.cid = categories.id) AS temp ON temp.id = bar.pid");
            	pstmt2.setString(1, states.getString("state"));
            	pstmt2.setInt(2, ageArr[0]);
            	pstmt2.setInt(3, ageArr[1]);
            	pstmt2.setString(4, request.getParameter("categoryFilter"));
            	
            	
            	ResultSet rs2 = pstmt2.executeQuery();
            	rs2.next();
            	
            	
                out.println("<tr>");
                out.println("<td><b>" + states.getString("state") + "($" + rs2.getInt("total") + ")" + "</b></td>");
                for (Integer pid : pids ) {
                    pstmt.setString(3, states.getString("state"));
                    pstmt.setInt(4, pid);
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
		double end = System.nanoTime(); // This is the timer. comment out
		out.println("<h2>" + ((end - start) / 1000000000.0 ) + " seconds" + "</h2>");
	}
	else { // Action was null so analytics page was just started
		rowCnt = 20; // initialize these vars so that the buttons will show on the page just
		colCnt = 10; // starting up
	}
	%>
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