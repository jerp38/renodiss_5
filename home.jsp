<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inicio - ReNoDiSS</title>
</head>
<body>
    <h2>Bienvenido a ReNoDiSS</h2>

    <p>Hola, <strong><%= session.getAttribute("usuario") %></strong>!</p>
    <p>Tu rol es: <strong><%= session.getAttribute("rol") %></strong></p>

    <a href="login.jsp">Cerrar sesión</a>
</body>
</html>
