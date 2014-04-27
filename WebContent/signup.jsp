<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sign Up</title>
<style>
</style>
</head>
<body>
	<div style="width: 25%">
		Sign Up or <a href="login.jsp">Log In</a> <br /> 
		<form action="verify.jsp" method="post">
		<label for="name">Username</label>
		<input type="text" name="name" required /> <br /> 
		<label for="group">Group</label>
		<select name="group">
			<option value="customer">Customer</option>
			<option value="owner">Owner</option>
		</select> <br /> 
		<label for="age">Age</label> 
		<input type="text" name="age" required /> <br /> 
		<label for="state">State</label> 
		<select	name="state">
			<option value="CA">CA</option>
		</select> <br /> 
		<input type="submit" value="Sign Up" />
		</form>
	</div>
</body>
</html>