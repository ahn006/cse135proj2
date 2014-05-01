
<%
    //to check random landing on pages. Checks if the user is logged in or not
    if (session.getAttribute("name") == null) {
%>
<p>User Not logged In</p>
<%
    } else {
%>

<p>
	Hello
	<%=session.getAttribute("name")%></p>
<%
    }
%>