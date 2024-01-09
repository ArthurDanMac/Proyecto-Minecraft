package com.example.proyectobd;

import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class MaterialesHerramientas implements Initializable {
    public TableView TB_Herramientas;
    public TableColumn COL_TipoHerramienta,COL_ComponenteH,COL_PrecioH,COL_CategoriaH;
    public TableView TB_Materiales;
    public TableColumn COL_TipoMaterial,COL_PrecioM,COL_CategoriaM;
    public Button B_Regresar,B_Cambiar;
    public TableView TB_Aldeanos;
    public TableColumn COL_NombreAldeanoA,COL_CantidadA,COL_PrecioA, COL_CategoriaA;
    public TableView TB_AldeanoRegion;
    public TableColumn COL_nombreAR, COL_salarioAR,COL_nombreRegAR;
    Boolean inventario=true;


    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        Tablas tablas=new Tablas();
        try {
            tablas.tablaMateriales(TB_Materiales,COL_TipoMaterial,COL_PrecioM,COL_CategoriaM);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        try {
            tablas.tablaHerramientas(TB_Herramientas,COL_TipoHerramienta,COL_ComponenteH,COL_PrecioH,COL_CategoriaH);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        try {
            tablas.tablaAldeanos(TB_Aldeanos,COL_NombreAldeanoA,COL_CantidadA,COL_PrecioA, COL_CategoriaA);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        try {
            tablas.tablaAldeanosRegion(TB_AldeanoRegion, COL_nombreAR, COL_salarioAR,COL_nombreRegAR);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void ON_Regresar(ActionEvent actionEvent) throws IOException {
        Conexion conexion=new Conexion();
        conexion.ventana(actionEvent,"P_Principal.fxml","Bienvenido!!!");
    }

    public void ON_Cambiar(ActionEvent actionEvent) {
        if(inventario==false){
            TB_Herramientas.setVisible(false);
            TB_Materiales.setVisible(false);
            TB_Aldeanos.setVisible(true);
            TB_AldeanoRegion.setVisible(true);
            inventario=true;
        }else {
            TB_Herramientas.setVisible(true);
            TB_Materiales.setVisible(true);
            TB_Aldeanos.setVisible(false);
            TB_AldeanoRegion.setVisible(false);
            inventario=false;
        }
    }
}
