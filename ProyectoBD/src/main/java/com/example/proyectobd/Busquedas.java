package com.example.proyectobd;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ScrollPane;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class Busquedas implements Initializable {
    @FXML
    public Button B_Regresar;

    @FXML
    public TableView TB_Precio;
    @FXML
    public TableColumn COL_CategroriaPrecios,COL_PrecioPrecios,COL_AldeanoPrecios,COL_RegionPrecios;

    @FXML
    public TableView TB_Herramientas;
    @FXML
    public TableColumn COL_TipoHerr,COL_ComponenteHerr,COL_CategoriaHerr,COL_PrecioHerr,COL_AldeanoHerr,COL_RegionHerr;

    @FXML
    public TableView TB_Materiales;
    @FXML
    public TableColumn COL_TipoMaterial, COL_CategoriaMats,COL_PrecioMats,COL_ALdeanoMats,COL_RegionMats;

    public void ON_Regresar(ActionEvent actionEvent) throws IOException {
        Datos datos=new Datos();
        datos.ventana(actionEvent,"OpcionesCompra.fxml","Como quieres Comprar?");
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        Tablas tablas=new Tablas();
        switch (Datos.opcion){
            case 1:
                try {
                    tablas.tablaBusquedaMateriales(COL_TipoMaterial, COL_CategoriaMats,COL_PrecioMats,COL_ALdeanoMats,COL_RegionMats,TB_Materiales);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                TB_Materiales.setVisible(true);
                break;
            case 2:
                try {
                    tablas.tablaBusquedaPrecio(COL_CategroriaPrecios,COL_PrecioPrecios,COL_AldeanoPrecios,COL_RegionPrecios,TB_Precio);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                TB_Precio.setVisible(true);
                break;
            case 3:
                try {
                    tablas.tablaBusquedaHerramientas(COL_TipoHerr,COL_ComponenteHerr,COL_CategoriaHerr,COL_PrecioHerr,COL_AldeanoHerr,COL_RegionHerr,TB_Herramientas);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                TB_Herramientas.setVisible(true);
                break;
        }
    }
}
