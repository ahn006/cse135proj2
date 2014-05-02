<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login Processing</title>
<%@include file="conn.jsp" %>

</head>
<body>
<%  
try{
pstmt = conn.prepareStatement("SELECT username FROM users WHERE username = ?");
pstmt.setString(1, request.getParameter("name"));
rs = pstmt.executeQuery();
if (!rs.next() && (request.getParameter("name") != "") && (Integer.parseInt(request.getParameter("age")) > 0 ) && (request.getParameter("group") != "") && (request.getParameter("state") != "")) {
    
	pstmt = conn.prepareStatement("INSERT INTO users (username, age, state, type) VALUES (?,?,?,?)");
	pstmt.setString(1, request.getParameter("name"));
    pstmt.setInt(2, Integer.parseInt(request.getParameter("age")));
    pstmt.setString(3, request.getParameter("state"));
    pstmt.setString(4, request.getParameter("group"));
    int rowCount = pstmt.executeUpdate();
    %>
    Sign up successful! <a href="login.jsp">Click here to Log in</a>.
    <%
}
else {
%>
    Sign up has failed.
    Please <a href="signup.jsp">try again</a> or <a href="login.jsp">log in</a>.
<%
}

}
catch(Exception e) {
	    %>
	    <p> An error occurred: <%=e.getMessage() %></p>
	    <%
	        
	    }
%>
</body>
</html>
