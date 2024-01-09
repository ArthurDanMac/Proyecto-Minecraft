package com.example.proyectobd;

public class DatosPerfil {
    static String nombreUsuario, correoUsuario, contrasenaUsuario;
    static int saldoUsuario;
    static int idUsuario;

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        DatosPerfil.idUsuario = idUsuario;
    }

    public int getSaldoUsuario() {
        return saldoUsuario;
    }

    public void setSaldoUsuario(int saldoUsuario) {
        DatosPerfil.saldoUsuario = saldoUsuario;
    }

    public String getNombre() {
        return nombreUsuario;
    }

    public void setNombre(String nombre) {
        this.nombreUsuario = nombre;
    }

    public String getCorreo() {
        return correoUsuario;
    }

    public void setCorreo(String correo) {
        this.correoUsuario = correo;
    }

    public String getContrasena() {
        return contrasenaUsuario;
    }

    public void setContrasena(String contrasena) {
        this.contrasenaUsuario = contrasena;
    }


}
