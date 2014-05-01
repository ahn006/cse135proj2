<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login In</title>
<%@include file="conn.jsp" %>
</head>
<body>
<%
if (!(request.getParameter("name") == null)) {
    pstmt = conn.prepareStatement("SELECT type FROM users WHERE username = ?");
    pstmt.setString(1, request.getParameter("name"));
    rs = pstmt.executeQuery();
    if (!rs.next()) {
        %>The provided name <%= request.getParameter("name") %> is not known.<%
    }
    else {
        
        if(rs.getString("type").equals("owner")) {
            session.setAttribute("name", request.getParameter("name"));
            session.setAttribute("group", "owner");
            response.sendRedirect("categories.jsp");
        }
        if (rs.getString("type").equals("customer")) {
            session.setAttribute("name", request.getParameter("name"));
            session.setAttribute("group", "customer");
            response.sendRedirect("browse.jsp");
        }
    }
}
%>
    <div style="width: 25%">
        <form action="" method="post">
        <label for="name">Username</label>
        <input type="text" name="name" required /> <br /> 
        <input type="submit" value="Sign Up" />
        </form>
    </div>
</body>
</html>