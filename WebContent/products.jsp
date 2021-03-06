<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CSE135 Products</title>
</head>

<body>
<%@include file="header.jsp" %>

<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
    <a href="categories.jsp">Categories</a>
    <a href="products.jsp">Products</a>
    <a href="salesanalytics.jsp">Sales Analytics</a>
    <table width="100%">
        <tr><td><a href="products.jsp?cid=-1" target="_self">All Categories</a></td></tr>
<%
if(session.getAttribute("name")!=null)
{
    //int userID  = (Integer)session.getAttribute("userID");
    //String role = (String)session.getAttribute("role");
    %>
    <%@include file="conn.jsp" %>
    <%
    String SQL=null;
    try
    {
        stmt =conn.createStatement();
        rs=stmt.executeQuery("SELECT * FROM categories order by id asc;");
        String c_name=null;
        int c_id=0;
        while(rs.next())
        {
            c_id=rs.getInt(1);
            c_name=rs.getString(2);
            out.println("<tr><td><a href=\"products.jsp?cid="+c_id+"\" target=\"_self\">"+c_name+"</a></td></tr>");
        }
        %>
    </table>    
</div>
<%
        String action=null,name=null, SKU=null, category=null, price_str=null, id_str=null;
        float price=0;
        try { action      = request.getParameter("action");}catch(Exception e){action  = null;}
        try {id_str   = request.getParameter("id");}catch(Exception e){id_str = null;}
        try{
            name      = request.getParameter("name"); 
            SKU       = request.getParameter("SKU"); 
            category  = request.getParameter("category"); 
            price_str = request.getParameter("price"); 
            price     = Float.parseFloat(price_str);
        }
        catch(Exception e) 
        { 
            name      = null; 
            SKU       = null; 
            category  = null; 
            price_str = null; 
            price     = 0;
        }
        if(("insert").equals(action))
        {
            rs=stmt.executeQuery("SELECT * FROM categories where name='"+category+"';");
            int cid=0;
            if(rs.next())
            {
                cid=rs.getInt(1);
            }
            String  SQL_1="INSERT INTO products (cid, name, SKU, category, price) VALUES("+cid+",'"+name+"','"+SKU+"', '"+category+"',"+price+");";
            try{
            conn.setAutoCommit(false);
            stmt.execute(SQL_1);
            conn.commit();
            conn.setAutoCommit(true);
            }
            catch(Exception e)
            {
                out.println("Fail! Please <a href=\"products.jsp\" target=\"_self\">insert it</a> again.");
            }
        }
        else if(("update").equals(action))
        {
            String  SQL_2="update products set name='"+name+"' , SKU='"+SKU+"' , category='"+category+"' , price='"+price+"' where id="+id_str+";";
            try{
                conn.setAutoCommit(false);
                stmt.execute(SQL_2);
                conn.commit();
                conn.setAutoCommit(true);
            //  response.sendRedirect("products.jsp?cid=-1");
            }
            catch(Exception e)
            {
                out.println("Fail! Please <a href=\"products.jsp\" target=\"_self\">update it</a> again.");
            }
        }
        if(("delete").equals(action))
        {
            String  SQL_3="delete from products where id="+id_str+";";
            try{
            conn.setAutoCommit(false);
            stmt.execute(SQL_3);
            conn.commit();
            conn.setAutoCommit(true);
            }
            catch(Exception e)
            {
                out.println("Fail! Please try again in the <a href=\"products.jsp\" target=\"_self\">products page</a>.<br><br>");
            }
        }
%>

<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<%
       String c_id_str=null,key=null;
       int c_id_int=-1;
       try {c_id_str=request.getParameter("cid"); c_id_int=Integer.parseInt(c_id_str);}catch(Exception e){c_id_str=null;c_id_int=-1;}
       try {key=request.getParameter("key");}catch(Exception e){key=null;}

        
        if(c_id_int==-1 && key==null)
        {
            SQL="SELECT id,name,SKU, category, price FROM products order by id asc;";
        }
        else
        {
            if(c_id_int==-1 && key!=null)
            {
                SQL="SELECT id,name,SKU, category, price FROM products where name LIKE '"+key+"%' order by id asc;";
            }
            else if(c_id_int!=-1 && key!=null)
            {
                SQL="SELECT id,name,SKU, category, price FROM products where cid="+c_id_int+" and name LIKE '"+key+"%' order by id asc;";
            }
            else if(c_id_int!=-1 && key==null)
            {
                SQL="SELECT id,name,SKU, category, price FROM products where cid="+c_id_int+" order by id asc;";
            }
        }
%>
<form action="products.jsp" method="post">
Search for products: 
<input type="text" name="cid" id="cid" value="<%=c_id_int%>" style="display:none">
<input type="text" id="key" name="key" size="50"><input type="submit" value="Search">
</form>
<br>

<table width="100%"  border="1px" align="center">
    <tr align="center">
        <td width="20%"><B>Product Name</B></td>
        <td width="20%"><B>SKU number</B></td>
        <td width="20%"><B>Category</B></td>
        <td width="20%"><B>Price</B></td>
        <td width="20%" colspan="2"><B>Operations</B></td>
    </tr>
    <form action="products.jsp" method="post">
    <tr align="center">
        <input type="hidden" name="action" id="action" value="insert" />
        <td width="20%"><input type="text" name="name" id="name"></td>
        <td width="20%"><input type="text" name="SKU" id="SKU"></td>
        <td width="20%">
        <select id="category" name="category">
            <%
                rs=stmt.executeQuery("SELECT * FROM categories order by id asc;");
                while(rs.next())
                {
                    c_id=rs.getInt(1);
                    c_name=rs.getString(2);
                    out.println("<option id=\""+c_id+"\">"+c_name+"</option>");
                }
            %>
        </select>
        </td>
        <td width="20%"><input type="text" name="price" id="price" ></td>
        <td width="20%" colspan="2"><input type="submit"  value="Insert"></td>
    </tr>
    </form>
<%      
        rs=stmt.executeQuery(SQL);
        int id=0;
        name=""; SKU="";category=null;
        price=0;
        while(rs.next())
        {
            id=rs.getInt(1);
            name=rs.getString(2);
             SKU=rs.getString(3);
             category=rs.getString(4);
             price=rs.getFloat(5);
%>           
        
        <tr align="center">
        <form action="products.jsp" method="post">
            <input type="hidden" name="action" id="action" value="update" />
            <input type="hidden" name="id" id="id" value="<%=id%>" />
            <td width="20%"><input type="text" name="name" id="name" value="<%=name%>" /></td>
            <td width="20%"><input type="text" name="SKU" id="SKU" value="<%=SKU%>" /></td>
            <td width="20%"><input type="text" name="category" id="category" value="<%=category%>" /></td>
            <td width="10%"><input type="text" name="price" id="price" value="<%=price%>" /></td>
            <td width="10%"><input type="submit" value="Update" /></td>
        </form>
        <form action="products.jsp" method="post">
            <input type="hidden" name="action" id="action" value="delete" width="3" />
            <input type="hidden" name="id" id="id" value="<%=id%>" width="3" />
            <td width="10%"><input type="submit" value="Delete" /></td>
        </form>
        </tr>       
<%           
        }
        out.println("</table>");
    }
    catch(Exception e)
    {
        out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");

    }
    finally
    {
        conn.close();
    }
}
else
{
    out.println("Please go to <a href=\"login.jsp\" target=\"_self\">home page</a> to login first.");
}
%>
</div>
</body>
</html>