<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.renodiss.util.ConexionDB" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cargar Documento</title>
</head>

<head>

<meta charset="UTF-8">
<title>Login - ReNoDiSS</title>

<link rel="manifest" href="manifest.json">
<meta name="theme-color" content="#1976d2">

<script src="script.js"></script>

</head>
<body>
<%
    // Verificar sesión
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<h2>Bienvenido, <%= usuario %> (<%= rol %>)</h2>
<h3>Cargar nuevo documento normativo</h3>

<form action="CargarDocumentoServlet" method="post" enctype="multipart/form-data">
    <label for="titulo">Título:</label><br>
    <input type="text" name="titulo" required><br><br>

    <label for="descripcion">Descripción:</label><br>
    <textarea name="descripcion" rows="3" cols="40"></textarea><br><br>

    <label for="tipo">Tipo de documento:</label><br>
    <select name="id_tipo">
        <%
            try (Connection conn = ConexionDB.getConnection()) {
                PreparedStatement stmt = conn.prepareStatement("SELECT id_tipo, nombre_tipo FROM tipos_documento");
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("id_tipo") %>"><%= rs.getString("nombre_tipo") %></option>
        <%
                }
            } catch (Exception e) {
                out.println("<option>Error cargando tipos</option>");
            }
        %>
    </select><br><br>

    <label for="categoria">Categoría:</label><br>
    <select name="id_categoria">
        <%
            try (Connection conn = ConexionDB.getConnection()) {
                PreparedStatement stmt = conn.prepareStatement("SELECT id_categoria, nombre_categoria FROM categorias");
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("id_categoria") %>"><%= rs.getString("nombre_categoria") %></option>
        <%
                }
            } catch (Exception e) {
                out.println("<option>Error cargando categorías</option>");
            }
        %>
    </select><br><br>

    <label for="archivo">Archivo:</label><br>
    <input type="file" name="archivo" accept=".pdf,.doc,.docx" required><br><br>

    <input type="submit" value="Cargar Documento">
</form>

<br>
<a href="funcional.jsp">⬅ Volver al panel</a> |
<a href="logout.jsp">Cerrar sesión</a>

</body>
</html>
