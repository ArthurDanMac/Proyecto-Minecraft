package com.example.proyectobd;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;

import java.io.IOException;
import java.net.URL;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;
import java.util.Optional;
import java.util.ResourceBundle;

public class Controlador extends Datos implements Initializable {
    @FXML
    public Button B_Izq, B_Der, B_Perfil, B_CambiarVista, B_Comprar;
    @FXML
    public Label L_nombreAldeano, L_salario;
    @FXML
    public TableColumn COL_idMat, col_tipo, col_categoria, col_precio;
    @FXML
    public TableView<Map> TB_materiales;
    @FXML
    public TableColumn COL_idHerr, col_tipHerr, col_componente, col_catHerr, col_precioHerr;
    @FXML
    public TableView<Map> TB_herramientas;
    @FXML
    public ImageView IMG_fondo, IMG_iconoRegion, IMG_aldeano;
    @FXML
    public TableView TB_ProductoAldeano;
    @FXML
    public TableColumn COL_CategoriaA, COL_PrecioA;
    Boolean vista = true, productos;//producto=true--> materiales  producto=false-->herramientas
    String nombreHerramienta, nombreMaterial;
    int cantidad,precio;

    public void ON_BIzq(ActionEvent actionEvent) throws IOException {
        region--;
        region = regiones(region);
        System.out.println("\n la region es: " + region + " y su xml es: " + xmls[region]);

        ventana(actionEvent, xmls[region], "Tienda");
    }

    public void ON_BDer(ActionEvent actionEvent) throws IOException {
        region++;
        region = regiones(region);
        System.out.println("\n la region es: " + region + " y su xml es: " + xmls[region]);
        ventana(actionEvent, xmls[region], "Tienda");
    }

    public void ON_BPerfil(ActionEvent actionEvent) throws IOException {
        ventana(actionEvent, "Perfil.fxml", "Perfil");
    }


    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        try {
            conet.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        Conexion c = new Conexion();
        Connection com = null;
        try {
            com = c.Conetsion();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        if (com == null){
            System.exit(0);
            System.out.println("Se cerro por un error");
        }
        else {
            Tablas tablas = new Tablas();
            Datos datos = new Datos();
            try {
                tablas.tablaMaterialesRegion(COL_idMat, col_categoria, col_precio, col_tipo, TB_materiales);
                tablas.tablaHerramientasRegion(COL_idHerr, col_tipHerr, col_componente, col_catHerr, col_precioHerr, TB_herramientas);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            try {
                datos.aldeanos();
                tablas.tablaAldeanoProductoRegion(TB_ProductoAldeano, COL_CategoriaA, COL_PrecioA);

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

            System.out.println("Controlador");
            System.out.println(region);
            System.out.println(DatosAldeano.nombre + "\t\t" + DatosAldeano.salario + "\t" + DatosAldeano.idAldeano);
            System.out.println("");
            L_nombreAldeano.setText(DatosAldeano.nombre);//datosAldeano.getNombre());
            L_salario.setText(String.valueOf(DatosAldeano.salario));
        }
    }

    public void ON_Cambiar(ActionEvent actionEvent) {
        nombreHerramienta = null;
        nombreMaterial = null;
        if (vista == false) {
            TB_herramientas.setVisible(true);
            TB_materiales.setVisible(true);
            B_Comprar.setDisable(false);

            TB_ProductoAldeano.setVisible(false);
            vista = true;
        } else {
            TB_herramientas.setVisible(false);
            TB_materiales.setVisible(false);
            B_Comprar.setDisable(true);

            TB_ProductoAldeano.setVisible(true);
            vista = false;
        }
    }

    public void ClicMat(MouseEvent mouseEvent) throws SQLException {
        productos = true;
        int index = TB_materiales.getSelectionModel().getSelectedIndex();
        if (index <= -1 || index > TB_materiales.getItems().size()) {
            return;
        }
        nombreMaterial = (String) col_tipo.getCellData(index);
        //idProductoSelec = (int) COL_idMat.getCellData(index);
        // id =
        precio= (int) col_precio.getCellData(index);
        System.out.println(col_tipo.getCellData(index));
    }

    public void ON_Comprar(ActionEvent actionEvent) throws SQLException, IOException {
        if ((nombreMaterial != null && productos == true) || (nombreHerramienta != null && productos == false)) {
            String numero=null;
            DatosPerfil datosPerfil=new DatosPerfil();
            int idUsu=datosPerfil.getIdUsuario();
            if (productos) {//PRODUCTOS == false --> materiales
                System.out.println("Nombre de Material a Comprar: " + nombreMaterial);
                numero= null;
                int cantidadMat = 0;
                do {
                    System.out.println("oli");
                    TextInputDialog dialog = new TextInputDialog();
                    dialog.setTitle("MATERIAL A COMPRAR");
                    dialog.setHeaderText(null);
                    dialog.setContentText("Escribe la cantidad de: " + nombreMaterial + " a comprar");

                    Optional<String> texto = dialog.showAndWait();
                    if (texto.isPresent()) {
                        numero = texto.get();
                        System.out.println("El usuario escribió: " + texto);
                    } else {
                        System.out.println("no escribio nada");
                        break;
                    }
                } while (!esEntero(numero));
                System.out.println(numero);
                if (numero == null) {
                    System.out.println("compra cancelada");
                } else {
                    cantidadMat = Integer.parseInt(numero);
                    cantidad=cantidadMat*precio;
                    if(cantidad<=datosPerfil.getSaldoUsuario()){
                        System.out.println(nombreMaterial+"\t"+idUsu+"\t"+cantidadMat);
                        ComprarMaterial(nombreMaterial, idUsu, cantidadMat);
                        SaldoDCompra();
                        System.out.println("comprado");
                        ventana(actionEvent,xmls[region],"Tienda");

                    }else{
                        Alert alert=new Alert(Alert.AlertType.ERROR);
                        alert.setHeaderText(null);
                        alert.setTitle("Error de Compra");
                        alert.setContentText("No tienes suficiente saldo");
                        alert.showAndWait();
                    }
                }
                nombreMaterial = null;
            } else {
                System.out.println("Nombre de Herramienta a Comprar: " + nombreHerramienta);
                numero = null;
                int cantidadHerr = 0;
                do {
                    System.out.println("oli");
                    TextInputDialog dialog = new TextInputDialog();
                    dialog.setTitle("HERRAMIENTA A COMPRAR");
                    dialog.setHeaderText(null);
                    dialog.setContentText("Escribe la cantidad de: " + nombreHerramienta + " a comprar");
                    Optional<String> texto = dialog.showAndWait();
                    //aqui
                    if (texto.isPresent()) {
                        numero = texto.get();
                        System.out.println("El usuario escribió: " + texto);
                        System.out.println("Que es lo mismo que: "+numero);
                    } else {
                        System.out.println("no escribio nada");
                        break;
                    }
                } while (!esEntero(numero));

                if (numero == null) {
                    System.out.println("compra cancelada");
                } else {
                    cantidadHerr = Integer.parseInt(numero);
                    cantidad=cantidadHerr*precio;

                    if(cantidad<=datosPerfil.getSaldoUsuario()) {
                        System.out.println(nombreHerramienta + "\t" + idUsu + "\t" + cantidadHerr);
                        ComprarHerramienta(nombreHerramienta, idUsu, cantidadHerr);
                        SaldoDCompra();
                        System.out.println("comprado");
                        ventana(actionEvent,xmls[region],"Tienda");

                    }else{
                        Alert alert=new Alert(Alert.AlertType.ERROR);
                        alert.setHeaderText(null);
                        alert.setTitle("Error de Compra");
                        alert.setContentText("No tienes suficiente saldo");
                        alert.showAndWait();
                    }
                }

                nombreHerramienta = null;
            }

        } else {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setContentText("No se ha elegido algún producto");
            alert.setResizable(false);
            alert.setHeaderText(null);
            alert.showAndWait();
        }
    }

    public void ClicHerr(MouseEvent mouseEvent) {
        productos = false;
        precio=0;
        int index = TB_herramientas.getSelectionModel().getSelectedIndex();
        if (index <= -1 || index > TB_herramientas.getItems().size()) {
            return;
        }
        nombreHerramienta = (String) col_tipHerr.getCellData(index);
        precio =(int) col_precioHerr.getCellData(index);
        System.out.println("el precio es de: "+precio);
        System.out.println(col_tipHerr.getCellData(index));
    }

    public static boolean esEntero(String cadena) {
        String[] numeros = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"};
        int num;
        if(cadena.length()>2)
            return false;
        else {
            if(cadena.equals("10")) {
                Integer.parseInt(cadena);
                return true;
            }
            else {
                for (int i = 0; i < numeros.length; i++) {
                    if (cadena.equals(numeros[i])) {
                        num = Integer.parseInt(cadena);
                        if (num > 0 && num < 10)
                            return true;
                    }
                }
            }
            return false;
        }
    }
}