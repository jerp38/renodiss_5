package com.renodiss.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import com.renodiss.util.ConexionDB;

public class EliminarDocumentoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idDocStr = request.getParameter("id_doc");

        if (idDocStr == null || idDocStr.isEmpty()) {
            response.sendRedirect("listaDocumentos.jsp?error=Id inválido");
            return;
        }

        int idDoc = Integer.parseInt(idDocStr);

        try (Connection conn = ConexionDB.getConnection()) {
            // Primero obtenemos la ruta del archivo para eliminarlo físicamente
            String selectSql = "SELECT ruta_archivo FROM documentos WHERE id_doc = ?";
            PreparedStatement selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setInt(1, idDoc);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                String ruta = rs.getString("ruta_archivo");

                // Eliminamos el registro en la BD
                String deleteSql = "DELETE FROM documentos WHERE id_doc = ?";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                deleteStmt.setInt(1, idDoc);
                deleteStmt.executeUpdate();

                // Eliminamos el archivo físico
                String filePath = getServletContext().getRealPath("") + File.separator + ruta;
                File archivo = new File(filePath);
                if (archivo.exists()) {
                    archivo.delete();
                }
            }

            response.sendRedirect("listaDocumentos.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error al eliminar documento: " + e.getMessage());
        }
    }
}
