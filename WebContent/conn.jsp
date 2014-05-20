<%@ page import="java.sql.*"%>
<%

Connection conn = null;
PreparedStatement pstmt = null;
Statement stmt;
ResultSet rs = null;
try {
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
        "jdbc:postgresql://127.0.0.1:5432/cseproject?" +
        "user=postgres&password=postgres");
} catch (SQLException ex) {
    throw new RuntimeException(ex);
}
%>