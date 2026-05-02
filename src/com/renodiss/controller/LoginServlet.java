package com.renodiss.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.renodiss.util.ConexionDB;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        try (Connection conn = ConexionDB.getConnection()) {
            // ✅ Incluimos id_usuario para usarlo en otras operaciones
            String sql = "SELECT id_usuario, nombre, rol, estado FROM usuarios WHERE correo=? AND contrasena=SHA2(?,256)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, correo);
            stmt.setString(2, contrasena);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String estado = rs.getString("estado");
                String rol = rs.getString("rol");

                // ✅ Verificamos si el usuario está activo
                if (!"activo".equalsIgnoreCase(estado)) {
                    request.setAttribute("mensajeError", "Usuario inactivo. Contacte al administrador.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                // ✅ Crear sesión y guardar datos del usuario
                HttpSession session = request.getSession();
                session.setAttribute("id_usuario", rs.getInt("id_usuario")); // 🔹 se agregó esta línea
                session.setAttribute("usuario", rs.getString("nombre"));
                session.setAttribute("rol", rol);
                session.setAttribute("correo", correo);

                // ✅ Redirigir según rol
                if (rol != null) {
                    switch (rol.toLowerCase()) {
                        case "funcional":
                            response.sendRedirect("funcional.jsp");
                            break;
                        case "qa":
                            response.sendRedirect("qa.jsp");
                            break;
                        case "soporte":
                            response.sendRedirect("soporte.jsp");
                            break;
                        default:
                            response.sendRedirect("error.jsp");
                            break;
                    }
                } else {
                    response.sendRedirect("login.jsp");
                }

            } else {
                // ✅ Si las credenciales son incorrectas
                request.setAttribute("mensajeError", "Correo o contraseña incorrectos.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            // ✅ Captura de error SQL
            e.printStackTrace();
            response.setContentType("text/plain");
            e.printStackTrace(response.getWriter());
        }
    }
}
