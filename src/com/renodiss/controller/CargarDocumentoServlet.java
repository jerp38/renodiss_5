package com.renodiss.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import com.renodiss.util.ConexionDB;

@MultipartConfig
public class CargarDocumentoServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "documentos"; // Carpeta donde se guardarán los archivos

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer idUsuario = (Integer) session.getAttribute("id_usuario"); // asegúrate de guardar este dato al iniciar sesión

        if (idUsuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        int idTipo = Integer.parseInt(request.getParameter("id_tipo"));
        int idCategoria = Integer.parseInt(request.getParameter("id_categoria"));
        Part archivoPart = request.getPart("archivo");

        String nombreArchivo = archivoPart.getSubmittedFileName();

        // Ruta donde se guardará físicamente
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String filePath = uploadPath + File.separator + nombreArchivo;
        archivoPart.write(filePath);

        try (Connection conn = ConexionDB.getConnection()) {
            String sql = "INSERT INTO documentos (titulo, descripcion, ruta_archivo, fecha_carga, id_usuario, id_tipo, id_categoria) "
                       + "VALUES (?, ?, ?, CURDATE(), ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, titulo);
            ps.setString(2, descripcion);
            ps.setString(3, UPLOAD_DIR + "/" + nombreArchivo);
            ps.setInt(4, idUsuario);
            ps.setInt(5, idTipo);
            ps.setInt(6, idCategoria);

            ps.executeUpdate();
            response.sendRedirect("listaDocumentos.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error al subir documento: " + e.getMessage());
        }
    }
}
