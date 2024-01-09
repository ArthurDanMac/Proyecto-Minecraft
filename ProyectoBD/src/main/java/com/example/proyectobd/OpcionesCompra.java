package com.example.proyectobd;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

public class OpcionesCompra implements Initializable {
    @FXML
    public Button B_Seleccion,B_Busqueda,B_Cancelar,B_Buscar;
    @FXML
    public TextField TF_MatBuscar,TF_HerrBuscar;
    @FXML
    public RadioButton RB_MatBuscar,RB_Precio,RB_HerrBuscar;
    @FXML
    public ImageView IMG_Buscar,IMG_Region;
    @FXML
    public ChoiceBox<String> CB_Precios;

    public void ON_Seleccion(ActionEvent actionEvent) throws IOException {
        Conexion conexion=new Conexion();
        conexion.ventana(actionEvent,"SelectRegion.fxml","Selecciona una Region");
    }

    public void ON_Busqueda(ActionEvent actionEvent) {
        B_Busqueda.setVisible(false);
        B_Seleccion.setVisible(false);

        IMG_Buscar.setVisible(false);
        IMG_Region.setVisible(false);

        B_Cancelar.setVisible(true);
        B_Buscar.setVisible(true);

        RB_HerrBuscar.setVisible(true);
        RB_Precio.setVisible(true);
        RB_MatBuscar.setVisible(true);

        TF_HerrBuscar.setVisible(true);
        TF_MatBuscar.setVisible(true);

        CB_Precios.setVisible(true);
    }

    public void ON_RB_Mat(ActionEvent actionEvent) {
        TF_MatBuscar.setDisable(false);
        TF_HerrBuscar.setDisable(true);
        CB_Precios.setDisable(true);

        B_Buscar.setDisable(false);

        Datos.opcion =1;
    }

    public void ON_RB_Prec(ActionEvent actionEvent) {
        TF_MatBuscar.setDisable(true);
        TF_HerrBuscar.setDisable(true);
        CB_Precios.setDisable(false);

        B_Buscar.setDisable(false);

        Datos.opcion=2;
    }

    public void ON_RB_Herr(ActionEvent actionEvent) {
        TF_MatBuscar.setDisable(true);
        TF_HerrBuscar.setDisable(false);
        CB_Precios.setDisable(true);

        B_Buscar.setDisable(false);

        Datos.opcion=3;
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        CB_Precios.getItems().addAll("1", "2", "3","4","5","6","7","8","9","10","11","12","13","14","15");
        ToggleGroup group = new ToggleGroup();
        RB_Precio.setToggleGroup(group);
        RB_MatBuscar.setToggleGroup(group);
        RB_HerrBuscar.setToggleGroup(group);
    }

    public void ON_Cancelar(ActionEvent actionEvent) {
        B_Busqueda.setVisible(true);
        B_Seleccion.setVisible(true);

        IMG_Buscar.setVisible(true);
        IMG_Region.setVisible(true);

        B_Cancelar.setVisible(false);
        B_Buscar.setVisible(false);

        RB_HerrBuscar.setVisible(false);
        RB_Precio.setVisible(false);
        RB_MatBuscar.setVisible(false);

        TF_HerrBuscar.setVisible(false);
        TF_MatBuscar.setVisible(false);

        CB_Precios.setVisible(false);
    }

    public void ON_Buscar(ActionEvent actionEvent) throws IOException {
        Conexion conexion=new Conexion();
        System.out.println("la opcion es: "+Datos.opcion);
        switch (Datos.opcion){
            case 1:
                System.out.println(TF_MatBuscar.getText());
                Datos.busqueda=TF_MatBuscar.getText();
                conexion.ventana(actionEvent,"Busquedas.fxml","Esto Buscaste");
                break;
            case 2:
                System.out.println(CB_Precios.getValue());
                Datos.busqueda=CB_Precios.getValue();
                conexion.ventana(actionEvent,"Busquedas.fxml","Esto Buscaste");

                break;
            case 3:
                System.out.println(TF_HerrBuscar.getText());
                Datos.busqueda=TF_HerrBuscar.getText();
                conexion.ventana(actionEvent,"Busquedas.fxml","Esto Buscaste");
                break;
            default:
                Alert alert=new Alert(Alert.AlertType.ERROR);
                alert.setHeaderText(null);
                alert.setTitle("Error");
                alert.setContentText("Opcion no valida, busque de nuevo");
                alert.showAndWait();
                break;
        }
    }
}
