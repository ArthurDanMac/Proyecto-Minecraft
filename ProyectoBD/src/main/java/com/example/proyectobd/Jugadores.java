package com.example.proyectobd;

import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class Jugadores implements Initializable {
    public TableColumn COL_NombreJ, COL_Categoria,COL_Cantidad;
    public TableView TB_Jugadores;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        Tablas tablas=new Tablas();
        try {
            tablas.tablasJugadores(COL_NombreJ, COL_Categoria,COL_Cantidad,TB_Jugadores);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void ON_Regresar(ActionEvent actionEvent) throws IOException {
       Conexion conexion=new Conexion();
       conexion.ventana(actionEvent,"P_Principal.fxml","Bienvenido!!!");
    }
}
