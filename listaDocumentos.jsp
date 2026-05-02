<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.renodiss.util.ConexionDB" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Lista de Documentos</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h2 { color: #333; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #aaa; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        a { color: #1a0dab; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .acciones a { margin-right: 10px; }
    </style>
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
    // Verificar sesión activa
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");

    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<h2>📂 Documentos Cargados</h2>
<p>Bienvenido, <strong><%= usuario %></strong> (<%= rol %>)</p>

<table>
    <tr>
        <th>ID</th>
        <th>Título</th>
        <th>Descripción</th>
        <th>Tipo</th>
        <th>Categoría</th>
        <th>Fecha de Carga</th>
        <th>Archivo</th>
        <% if ("funcional".equalsIgnoreCase(rol)) { %>
            <th>Acciones</th>
        <% } %>
    </tr>

<%
    try (Connection conn = ConexionDB.getConnection()) {
        String sql = "SELECT d.id_doc, d.titulo, d.descripcion, d.fecha_carga, "
                   + "t.nombre_tipo AS tipo, c.nombre_categoria AS categoria, d.ruta_archivo "
                   + "FROM documentos d "
                   + "LEFT JOIN tipos_documento t ON d.id_tipo = t.id_tipo "
                   + "LEFT JOIN categorias c ON d.id_categoria = c.id_categoria "
                   + "ORDER BY d.fecha_carga DESC";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id_doc") %></td>
        <td><%= rs.getString("titulo") %></td>
        <td><%= rs.getString("descripcion") %></td>
        <td><%= rs.getString("tipo") %></td>
        <td><%= rs.getString("categoria") %></td>
        <td><%= rs.getDate("fecha_carga") %></td>
        <td><a href="<%= rs.getString("ruta_archivo") %>" target="_blank">Ver archivo</a></td>

        <% if ("funcional".equalsIgnoreCase(rol)) { %>
        <td class="acciones">
            <a href="EliminarDocumentoServlet?id_doc=<%= rs.getInt("id_doc") %>" 
               onclick="return confirm('¿Seguro que deseas eliminar este documento?');">
               🗑️ Eliminar
            </a>
        </td>
        <% } %>
    </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='8' style='color:red;'>Error cargando documentos: " + e.getMessage() + "</td></tr>");
    }
%>
</table>

<br>
<a href="funcional.jsp">⬅ Volver al panel</a> |
<a href="logout.jsp">Cerrar sesión</a>

</body>
</html>
