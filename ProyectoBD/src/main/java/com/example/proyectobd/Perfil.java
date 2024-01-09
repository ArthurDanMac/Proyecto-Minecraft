package com.example.proyectobd;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;

import java.io.IOException;

import java.net.URL;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class Perfil extends DatosPerfil implements Initializable {

    @FXML
    public Button B_Comprar, B_Guardar, B_Editar, B_CambiarInv, B_Inventario, B_Cancelar;
    @FXML
    public PasswordField PSWD_ContraUsu;
    @FXML
    public Label L_NomUsu, L_Correo, L_Saldo;
    @FXML
    public TextField TF_NuevoNom, TF_NuevoCorreo;
    @FXML
    public TableView TB_inventarioMats;
    @FXML
    public TableColumn COL_TipoMats, COL_categoriaMats, COL_precioMats, COL_cantidadMats;
    @FXML
    public TableView TB_inventarioHerr;
    @FXML
    public TableColumn COL_TipoHerr, COL_cantidadHerr, COL_categoriaHerr, COL_precioHerr, COL_ComponHerr;

    @FXML
    public ImageView IMG_Inv, IMG_Compra;
    boolean inventario = false;
    private String NuevonombreDeUsuario = null, NuevocorreoDeUsuario = null, NuevocontraUsuario = null;


    public void ON_BComprar(ActionEvent actionEvent) throws IOException {
        Conexion conexion = new Conexion();
        conexion.ventana(actionEvent, "OpcionesCompra.fxml", "Como quieres Comprar?");
    }

    public void ON_Guardar(ActionEvent actionEvent) throws IOException, SQLException {
        B_Editar.setVisible(true);
        B_Guardar.setVisible(false);
        TF_NuevoCorreo.setVisible(false);
        TF_NuevoNom.setVisible(false);
        PSWD_ContraUsu.setDisable(true);
        L_NomUsu.setVisible(true);
        L_Correo.setVisible(true);
        if (TF_NuevoNom.getText().isEmpty() && TF_NuevoCorreo.getText().isEmpty() && PSWD_ContraUsu.getText().isEmpty()) {
            Alert alert = new Alert(Alert.AlertType.INFORMATION);
            alert.setTitle("No hay cambios");
            alert.setContentText("No hay modificaciones que hacer");
            alert.setHeaderText(null);
            alert.showAndWait();
        } else {

            if (TF_NuevoNom.getText().isEmpty())
                NuevonombreDeUsuario = nombreUsuario;
            else
                NuevonombreDeUsuario = TF_NuevoNom.getText();


            if (TF_NuevoCorreo.getText().isEmpty())
                NuevocorreoDeUsuario = correoUsuario;
            else
                NuevocorreoDeUsuario = TF_NuevoCorreo.getText();


            if (PSWD_ContraUsu.getText().isEmpty())
                NuevocontraUsuario = contrasenaUsuario;
            else
                NuevocontraUsuario = PSWD_ContraUsu.getText();


            System.out.println("viejos datos");
            System.out.println(nombreUsuario + "\t" + correoUsuario + "\t" + contrasenaUsuario);
            Alert alert = new Alert(Alert.AlertType.INFORMATION);

            if (NuevonombreDeUsuario.length() > 5 || NuevocontraUsuario.length() > 8 || NuevocorreoDeUsuario.length() > 5) {
                Boolean caracter = false, numero = false, correoE = false;

                for (int i = 0; i < NuevocontraUsuario.length(); i++) {
                    if (Character.isUpperCase(NuevocontraUsuario.charAt(i)))
                        caracter = true;
                }
                if (NuevocontraUsuario.contains("0") || NuevocontraUsuario.contains("1") || NuevocontraUsuario.contains("2") ||
                        NuevocontraUsuario.contains("3") || NuevocontraUsuario.contains("4") || NuevocontraUsuario.contains("5") ||
                        NuevocontraUsuario.contains("6") || NuevocontraUsuario.contains("7") || NuevocontraUsuario.contains("8") ||
                        NuevocontraUsuario.contains("9")) {
                    numero = true;
                }
                if (caracter == true && numero == true) {
                    NuevocorreoDeUsuario = NuevocorreoDeUsuario.toLowerCase();
                    Datos datos = new Datos();
                    correoE = datos.verificarCorreo(NuevocorreoDeUsuario);
                    if (!correoE) {
                        System.out.println("Nuevos datos");
                        System.out.println(idUsuario + "\t" + NuevonombreDeUsuario + "\t" + NuevocorreoDeUsuario + "\t" + NuevocontraUsuario + "\t" + saldoUsuario);
                        datos.ModificarPerfil(idUsuario, NuevonombreDeUsuario, NuevocorreoDeUsuario, NuevocontraUsuario, saldoUsuario);

                        Conexion conexion = new Conexion();
                        conexion.ventana(actionEvent, "LogIn.fxml", "Tu Perfil");
                    } else {
                        Alert alerta = new Alert(Alert.AlertType.ERROR);
                        alerta.setHeaderText(null);
                        alerta.setTitle("Error");
                        alerta.setContentText("Ya hay un correo similar");
                        alerta.showAndWait();
                    }
                } else {
                    alert.setHeaderText(null);
                    alert.setTitle("Info");
                    alert.setContentText("La contraseña no contiene mayúsculas y/o numeros");
                    alert.showAndWait();
                }
            }else {
                alert.setHeaderText(null);
                alert.setTitle("Info");
                alert.setContentText("Nombre, contraseña o correo cortos");
                alert.showAndWait();
            }

        }
    }

    public void ON_Edit(ActionEvent actionEvent) {
        B_Editar.setVisible(false);
        TF_NuevoCorreo.setVisible(true);
        TF_NuevoNom.setVisible(true);
        PSWD_ContraUsu.setDisable(false);
        PSWD_ContraUsu.setText("");
        PSWD_ContraUsu.setEditable(true);
//        TF_NuevoCorreo.getText(nombreDeUsuario);
//        TF_NuevoNom.getText(nombreDeUsuario);
        B_Guardar.setVisible(true);
        L_NomUsu.setVisible(false);
        L_Correo.setVisible(false);
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        Conexion c=new Conexion();
        Connection com= null;
        try {
            com = c.Conetsion();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        if(com==null)
            System.exit(0);
        else {
            Tablas tablas = new Tablas();
            System.out.println(getNombre());//nombreUsuario);
            L_NomUsu.setText(nombreUsuario);
            L_Correo.setText(getCorreo());
            L_Saldo.setText(String.valueOf(getSaldoUsuario()));

            try {
                tablas.tablaMaterialesJ(TB_inventarioMats, COL_TipoMats, COL_categoriaMats, COL_precioMats, COL_cantidadMats);
                tablas.tablaHerramientasJ(TB_inventarioHerr, COL_TipoHerr, COL_cantidadHerr, COL_categoriaHerr, COL_precioHerr, COL_ComponHerr);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }

    public void ON_BCambiarInven(ActionEvent actionEvent) {
        if (inventario == true) {
            TB_inventarioHerr.setVisible(false);
            TB_inventarioMats.setVisible(true);
            inventario = false;
        } else {
            TB_inventarioHerr.setVisible(true);
            TB_inventarioMats.setVisible(false);
            inventario = true;
        }
    }

    public void ON_Binventario(ActionEvent actionEvent) {
        B_Comprar.setVisible(false);
        B_Inventario.setVisible(false);
        IMG_Compra.setVisible(false);
        IMG_Inv.setVisible(false);

        TB_inventarioHerr.setVisible(true);
        B_CambiarInv.setVisible(true);
        B_Cancelar.setVisible(true);
        inventario = true;
    }

    public void ON_BCancelar(ActionEvent actionEvent) {
        B_Comprar.setVisible(true);
        B_Inventario.setVisible(true);
        IMG_Compra.setVisible(true);
        IMG_Inv.setVisible(true);

        TB_inventarioHerr.setVisible(false);
        TB_inventarioMats.setVisible(false);
        B_CambiarInv.setVisible(false);
        B_Cancelar.setVisible(false);
        inventario = false;
    }
}
