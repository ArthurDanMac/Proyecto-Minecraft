package com.example.proyectobd;

public class Productos_Materiales {
    String tipo_mat,categoria;
    int precio,idMat;

    public int getIdMat() {
        return idMat;
    }

    public void setIdMat(int idMat) {
        this.idMat = idMat;
    }

    public String getTipo_mat() {
        return tipo_mat;
    }

    public void setTipo_mat(String tipo_mat) {
        this.tipo_mat = tipo_mat;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public int getPrecio() {
        return precio;
    }

    public void setPrecio(int precio) {
        this.precio = precio;
    }
}
