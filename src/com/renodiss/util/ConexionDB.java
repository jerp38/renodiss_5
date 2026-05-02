package com.renodiss.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    /*
    private static final String URL = "jdbc:mysql://localhost:3306/renodiss";
    private static final String USER = "root";
    private static final String PASS = "";

    public static Connection getConnection() throws SQLException {
        try {
            // Cargar explícitamente el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        // Retornar la conexión
        return DriverManager.getConnection(URL, USER, PASS);
*/
/*#Conexion Axure
//Comentario*/

    public static Connection getConnection() throws SQLException {

        String host = "service-admin-php.mysql.database.azure.com";
        String port = "3306";
        String database = "renodiss";

        String user = "adminphp";
        String password = "Abc123456";

        String url = "jdbc:mysql://" + host + ":" + port + "/" + database
                   + "?useSSL=true"
                   + "&requireSSL=true"
                   + "&verifyServerCertificate=false"
                   + "&serverTimezone=UTC";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return DriverManager.getConnection(url, user, password);


    }
}
