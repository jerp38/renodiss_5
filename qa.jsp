<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");

    if (usuario == null || !"qa".equalsIgnoreCase(rol)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel QA - Revisión de Documentos</title>
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

    <p>Este panel permite revisar y descargar documentos normativos cargados por otros usuarios.</p>

    <ul>
        <li><a href="revisarDocumentos.jsp">📄 Ver y descargar documentos</a></li>
    </ul>

    <hr>
    <a href="logout.jsp">Cerrar sesión</a>
</body>
</html>
