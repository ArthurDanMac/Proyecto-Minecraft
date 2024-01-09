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

public class SignIn extends Conexion {
    @FXML
    public PasswordField TF_ContraUsuSign;
    @FXML
    public TextField TF_NombreUsuSign, TF_Correo;
    @FXML
    public Button B_Signin, B_Back;

    public void ON_BBSignin(ActionEvent actionEvent) throws IOException, SQLException, NoSuchAlgorithmException {
        //mayor a 8 caracteres
        //con una mayuscula
        Alert alert = new Alert(Alert.AlertType.INFORMATION);

        String nombre = TF_NombreUsuSign.getText(), contrasena = TF_ContraUsuSign.getText(), correo = TF_Correo.getText();
        Boolean caracter = false, numero = false, correoE = false;
//        char[] caracterEsp={'!','¡','?','¿','#','$','%','&','@','*','+'};

        if (TF_NombreUsuSign.getText().isEmpty() || TF_ContraUsuSign.getText().isEmpty() || TF_Correo.getText().isEmpty()) {
            alert.setHeaderText(null);
            alert.setTitle("Info");
            alert.setContentText("Al usuario le falta informacion");
            alert.showAndWait();
        } else {
            if (nombre.length() > 5 || contrasena.length() > 8||correo.length()>5) {
                for (int i = 0; i < contrasena.length(); i++) {
                    if (Character.isUpperCase(contrasena.charAt(i)))
                        caracter = true;
                }
                if (contrasena.contains("0") || contrasena.contains("1") || contrasena.contains("2") ||
                        contrasena.contains("3") || contrasena.contains("4") || contrasena.contains("5") ||
                        contrasena.contains("6") || contrasena.contains("7") || contrasena.contains("8") ||
                        contrasena.contains("9")) {
                    numero = true;
                }
                if (caracter == true && numero == true) {
                    correo = correo.toLowerCase();
                    Datos datos = new Datos();
                    correoE = datos.verificarCorreo(correo);
                    if (correoE) {
                        alert.setTitle("Correo Existente");
                        alert.setHeaderText(null);
                        alert.setContentText("Ya existe un correo igual/similar");
                        alert.showAndWait();
                    } else {
                        System.out.println("Se hara un registro con los datos:");
                        System.out.println(nombre+"\t"+correo+"\t"+contrasena);
                        datos.RegistroUsuario(nombre, correo, contrasena, 1000);
                        ventana(actionEvent, "LogIn.fxml", "LogIn");
                    }
                } else {
                    alert.setHeaderText(null);
                    alert.setTitle("Info");
                    alert.setContentText("La contraseña no contiene mayúsculas y/o numeros");
                    alert.showAndWait();
                }
            } else {
                alert.setHeaderText(null);
                alert.setTitle("Info");
                alert.setContentText("Nombre, contraseña o correo cortos");
                alert.showAndWait();
            }
        }
    }

    public void ON_BBack(ActionEvent actionEvent) throws IOException {
        Node source = (Node) actionEvent.getSource();
        Stage stage1 = (Stage) source.getScene().getWindow();
        stage1.close();

        FXMLLoader fxmlLoader = new FXMLLoader(SignIn.class.getResource("P_Principal.fxml"));
        Scene scene = new Scene(fxmlLoader.load());
        Stage stage = new Stage();
        stage.setResizable(false);
        stage.setTitle("Registrate");
        stage.setScene(scene);
        stage.show();
    }
}
