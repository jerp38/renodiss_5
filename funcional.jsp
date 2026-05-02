<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");

    if (usuario == null || !"funcional".equalsIgnoreCase(rol)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Panel Funcional</title>
</head>

<head>

<meta charset="UTF-8">
<title>Login - ReNoDiSS</title>

<link rel="manifest" href="manifest.json">
<meta name="theme-color" content="#1976d2">

<script src="script.js"></script>

</head>

<body>
    <h2>Bienvenido, <%= usuario %> 👋</h2>
    <h3>Rol: <%= rol %></h3>
    <hr>
    <p>Acceso a documentos normativos y búsqueda de información.</p>
    <ul>
        <li><a href="listaDocumentos.jsp">Ver documentos normativos</a></li>
        <li><a href="busqueda.jsp">Búsqueda avanzada 🔍</a></li>
        <li><a href="cargarDocumento.jsp">Cargar nuevo documento 📄</a></li>
    </ul>
    <hr>
    <a href="logout.jsp">Cerrar sesión</a>
</body>
</html>
