package com.example.proyectobd;

public class ProductosHerramientas {
    String tipoHerramienta,componente,categoria;
    int precio,idHerrs;

    public int getIdHerrs() {
        return idHerrs;
    }

    public void setIdHerrs(int idHerrs) {
        this.idHerrs = idHerrs;
    }

    public String getTipoHerramienta() {
        return tipoHerramienta;
    }

    public void setTipoHerramienta(String tipoHerramienta) {
        this.tipoHerramienta = tipoHerramienta;
    }

    public String getComponente() {
        return componente;
    }

    public void setComponente(String componente) {
        this.componente = componente;
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
