<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login - ReNoDiSS</title>


<meta charset="UTF-8">
<title>Login - ReNoDiSS</title>

<link rel="manifest" href="manifest.json">
<meta name="theme-color" content="#1976d2">

<script src="script.js"></script>

</head>

<body>
    <h2>Acceso a ReNoDiSS</h2>

    <form action="LoginServlet" method="post">
        <label>Correo:</label><br>
        <input type="text" name="correo" required><br><br>

        <label>Contraseña:</label><br>
        <input type="password" name="contrasena" required><br><br>

        <input type="submit" value="Ingresar">
    </form>

    <p style="color:red">
        ${mensajeError}
    </p>
</body>
</html>
