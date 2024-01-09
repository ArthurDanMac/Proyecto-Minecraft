package com.example.proyectobd;
import javafx.fxml.FXML;
import javafx.event.ActionEvent;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.image.ImageView;
import javafx.stage.Stage;

import java.io.IOException;

public class P_Principal {
    @FXML

    public ImageView IMG_Fondo;

    @FXML
    public Button B_Quite,B_login,B_Register,B_Credits,B_MatsHerr,B_Jugadores;

    Conexion conexion=new Conexion();
    public void On_Quit(ActionEvent actionEvent) {
        System.exit(0);
    }
    public void ON_logIn(ActionEvent actionEvent) throws IOException {
        conexion.ventana(actionEvent,"LogIn.fxml","Log In");
    }

    public void ON_Register(ActionEvent actionEvent) throws IOException {
        conexion.ventana(actionEvent,"Sign_In.fxml","Sign In");
    }

    public void ON_MatsHerr(ActionEvent actionEvent) throws IOException {
        conexion.ventana(actionEvent,"Materiales&Herramientas.fxml","Productos");
    }

    public void ON_Jugadores(ActionEvent actionEvent) throws IOException {
        conexion.ventana(actionEvent,"Jugadores.fxml","Jugadores");
    }
}
