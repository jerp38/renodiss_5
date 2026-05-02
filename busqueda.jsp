<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.renodiss.util.ConexionDB" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Búsqueda de Documentos</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h2 { color: #333; }
        form { margin-bottom: 20px; }
        input[type="text"], input[type="date"] { padding: 5px; margin-right: 10px; }
        input[type="submit"], .btn-clear { padding: 6px 12px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #aaa; padding: 8px; }
        th { background-color: #f2f2f2; }
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
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<h2>🔎 Búsqueda de Documentos</h2>
<p>Bienvenido, <strong><%= usuario %></strong> (<%= rol %>)</p>

<form method="get" action="busqueda.jsp">
    <label>Buscar palabra clave:</label>
    <input type="text" name="query" placeholder="Ej: Resolución" value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">

    <label>Desde:</label>
    <input type="date" name="fechaInicio" value="<%= request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : "" %>">

    <label>Hasta:</label>
    <input type="date" name="fechaFin" value="<%= request.getParameter("fechaFin") != null ? request.getParameter("fechaFin") : "" %>">

    <input type="submit" value="Buscar">
    <a href="busqueda.jsp" class="btn-clear">Limpiar</a>
</form>

<%
    String query = request.getParameter("query");
    String fechaInicio = request.getParameter("fechaInicio");
    String fechaFin = request.getParameter("fechaFin");

    if ((query != null && !query.trim().isEmpty()) || 
        (fechaInicio != null && !fechaInicio.isEmpty()) || 
        (fechaFin != null && !fechaFin.isEmpty())) {

        try (Connection conn = ConexionDB.getConnection()) {

            String sql = "SELECT d.id_doc, d.titulo, d.descripcion, d.ruta_archivo, "
                       + "t.nombre_tipo AS tipo, c.nombre_categoria AS categoria, d.fecha_carga "
                       + "FROM documentos d "
                       + "LEFT JOIN tipos_documento t ON d.id_tipo = t.id_tipo "
                       + "LEFT JOIN categorias c ON d.id_categoria = c.id_categoria "
                       + "WHERE (d.titulo LIKE ? OR d.descripcion LIKE ? OR t.nombre_tipo LIKE ?) ";

            if (fechaInicio != null && !fechaInicio.isEmpty()) {
                sql += "AND d.fecha_carga >= ? ";
            }
            if (fechaFin != null && !fechaFin.isEmpty()) {
                sql += "AND d.fecha_carga <= ? ";
            }

            sql += "ORDER BY d.fecha_carga DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            int index = 1;

            String filtro = "%" + query + "%";
            ps.setString(index++, filtro);
            ps.setString(index++, filtro);
            ps.setString(index++, filtro);

            if (fechaInicio != null && !fechaInicio.isEmpty()) {
                ps.setString(index++, fechaInicio);
            }
            if (fechaFin != null && !fechaFin.isEmpty()) {
                ps.setString(index++, fechaFin);
            }

            ResultSet rs = ps.executeQuery();
            boolean hayResultados = false;
%>

<h3>Resultados de búsqueda</h3>
<table>
    <tr>
        <th>ID</th><th>Título</th><th>Descripción</th><th>Tipo</th><th>Categoría</th><th>Fecha</th><th>Descargar</th>
    </tr>

<%
    while (rs.next()) {
        hayResultados = true;
%>
    <tr>
        <td><%= rs.getInt("id_doc") %></td>
        <td><%= rs.getString("titulo") %></td>
        <td><%= rs.getString("descripcion") %></td>
        <td><%= rs.getString("tipo") %></td>
        <td><%= rs.getString("categoria") %></td>
        <td><%= rs.getDate("fecha_carga") %></td>
        <td><a href="<%= rs.getString("ruta_archivo") %>" download>⬇ Descargar</a></td>
    </tr>
<%
    }

    if (!hayResultados) {
        out.println("<tr><td colspan='7' style='color:red;'>No se encontraron resultados.</td></tr>");
    }

} catch (Exception e) {
    out.println("<p style='color:red;'>Error en la búsqueda: " + e.getMessage() + "</p>");
}
    }
%>
</table>

<br>
<a href="funcional.jsp">⬅ Volver al panel</a> | <a href="logout.jsp">Cerrar sesión</a>

</body>
</html>
