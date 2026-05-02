<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.renodiss.util.ConexionDB" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Revisión de Documentos - QA</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h2 { color: #333; }
        form { margin-bottom: 20px; }
        input[type="text"] { width: 300px; padding: 5px; }
        input[type="submit"] { padding: 5px 10px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #aaa; padding: 8px; }
        th { background-color: #f2f2f2; }
        a { color: #1a0dab; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");

    if (usuario == null || !"qa".equalsIgnoreCase(rol)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<h2>🔍 Revisión de Documentos</h2>
<p>Bienvenido, <strong><%= usuario %></strong> (Rol: <%= rol %>)</p>

<form method="get" action="verDocumentosQA.jsp">
    <label>Buscar documento:</label><br>
    <input type="text" name="query" placeholder="Título, descripción, tipo, categoría...">
    <input type="submit" value="Buscar">
</form>

<table>
    <tr>
        <th>ID</th>
        <th>Título</th>
        <th>Descripción</th>
        <th>Tipo</th>
        <th>Categoría</th>
        <th>Fecha</th>
        <th>Archivo</th>
    </tr>

<%
    String query = request.getParameter("query");
    String filtro = (query != null && !query.trim().isEmpty()) ? "%" + query + "%" : "%";

    try (Connection conn = ConexionDB.getConnection()) {
        String sql = "SELECT d.id_doc, d.titulo, d.descripcion, d.fecha_carga, "
                   + "t.nombre_tipo AS tipo, c.nombre_categoria AS categoria, d.ruta_archivo "
                   + "FROM documentos d "
                   + "LEFT JOIN tipos_documento t ON d.id_tipo = t.id_tipo "
                   + "LEFT JOIN categorias c ON d.id_categoria = c.id_categoria "
                   + "WHERE d.titulo LIKE ? OR d.descripcion LIKE ? OR t.nombre_tipo LIKE ? OR c.nombre_categoria LIKE ? "
                   + "ORDER BY d.fecha_carga DESC";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, filtro);
        ps.setString(2, filtro);
        ps.setString(3, filtro);
        ps.setString(4, filtro);
        ResultSet rs = ps.executeQuery();

        boolean hay = false;
        while (rs.next()) {
            hay = true;
%>
    <tr>
        <td><%= rs.getInt("id_doc") %></td>
        <td><%= rs.getString("titulo") %></td>
        <td><%= rs.getString("descripcion") %></td>
        <td><%= rs.getString("tipo") %></td>
        <td><%= rs.getString("categoria") %></td>
        <td><%= rs.getDate("fecha_carga") %></td>
        <td>
            <a href="<%= rs.getString("ruta_archivo") %>" target="_blank">👁 Ver</a> |
            <a href="<%= rs.getString("ruta_archivo") %>" download>⬇ Descargar</a>
        </td>
    </tr>
<%
        }
        if (!hay) {
            out.println("<tr><td colspan='7' style='color:red;'>No se encontraron documentos.</td></tr>");
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='7' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
    }
%>
</table>

<br>
<a href="qa.jsp">⬅ Volver al panel</a> |
<a href="logout.jsp">Cerrar sesión</a>

</body>
</html>
