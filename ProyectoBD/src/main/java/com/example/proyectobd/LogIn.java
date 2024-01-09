package com.example.proyectobd;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

public class LogIn extends DatosPerfil{
    @FXML
    public PasswordField TF_ContraUsuLog;
    @FXML
    public TextField TF_NombreUsuLog;
    @FXML
    public Button B_LogIn,B_Back;
    @FXML
    void ON_BBLogin(ActionEvent actionEvent) throws IOException, SQLException, NoSuchAlgorithmException {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        Datos datos=new Datos();
        String nombresito=TF_NombreUsuLog.getText(),contrasena=TF_ContraUsuLog.getText();
        boolean perfil= datos.Perfil(nombresito,contrasena);
        if(TF_ContraUsuLog.getText().isEmpty()||TF_ContraUsuLog.getText().isEmpty()){
            alert.setHeaderText(null);
            alert.setTitle("Info");
            alert.setContentText("El usuario o el Password le falta informacion");
            alert.showAndWait();
        }
        else{
            if (perfil){
                datos.ventana(actionEvent,"Perfil.fxml","Perfil");
            }
            else {
                alert.setHeaderText(null);
                alert.setTitle("Error");
                alert.setContentText("No coincide password o usuario");
                alert.showAndWait();
            }
        }

    }

    @FXML
    void ON_BBack(ActionEvent actionEvent) throws IOException {
        Node source = (Node) actionEvent.getSource();
        Stage stage1 = (Stage) source.getScene().getWindow();
        stage1.close();

        FXMLLoader fxmlLoader = new FXMLLoader(SignIn.class.getResource("P_Principal.fxml"));
        Scene scene = new Scene(fxmlLoader.load());
        Stage stage = new Stage();
        stage.setResizable(false);
        stage.setTitle("Bienvenido");
        stage.setScene(scene);
        stage.show();
    }
}
