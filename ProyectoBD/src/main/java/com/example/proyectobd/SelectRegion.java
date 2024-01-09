package com.example.proyectobd;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.SplitPane;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.stage.Stage;
import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.sql.SQLXML;
import java.util.ResourceBundle;

public class SelectRegion extends Datos implements Initializable {
    @FXML
    public ImageView IMG_Tundra,IMG_Taiga,IMG_Pantano,iMG_Sabana,IMG_Desierto,IMG_Jungla,IMG_LLANURA;
    @FXML
    public SplitPane SCROLL;
    @FXML
    public Label L_DescLL,L_DescPant,L_DescJung,L_DescDesiert, L_DescSabn,L_DescTaig,L_DescTundra,L_DescNether, L_DescEnd;
   // int reg;
    @FXML
    public Button B_Llanura,B_Pantano,B_Jungla,B_Desierto,B_Sabana,B_Taiga, B_Tundra,B_Aceptar,B_Cambiar,B_Nether,B_End;



    public void ON_LLanura(ActionEvent mouseEvent) throws IOException {
        setRegion(0);
        ventana(mouseEvent,xmls[region],"Tienda");
    }

    public void ON_Pantano(ActionEvent actionEvent) throws IOException {
        // region=1;
        setRegion(6);
        ventana(actionEvent,xmls[region],"Tienda");
    }

    public void ON_Jungla(ActionEvent actionEvent) throws IOException {
       // region=2;
        setRegion(3);
        ventana(actionEvent,xmls[region],"Tienda");
    }

    public void ON_Desierto(ActionEvent actionEvent) throws IOException {
     //   region=3;
        setRegion(1);
        ventana(actionEvent,xmls[region],"Tienda");

    }

    public void ON_Sabana(ActionEvent actionEvent) throws IOException {
       // region=4;
        setRegion(2);
        ventana(actionEvent,xmls[region],"Tienda");
    }

    public void ON_Taiga(ActionEvent actionEvent) throws IOException {
        //region=5;
        setRegion(5);
        ventana(actionEvent,xmls[region],"Tienda");

    }

    public void ON_Tundra(ActionEvent actionEvent) throws IOException {
      //  region=6;
        setRegion(4);
        ventana(actionEvent,xmls[region],"Tienda");

    }

    public void ON_Nether(ActionEvent actionEvent) throws IOException {
     //   region=7;
        setRegion(7);
        ventana(actionEvent,xmls[region],"Tienda");

    }

    public void ON_End(ActionEvent actionEvent) throws IOException {
        //region=8;
        setRegion(8);
        ventana(actionEvent,xmls[region],"Tienda");
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        try {
            L_DescLL.setText(descripReg(1));
            L_DescDesiert.setText(descripReg(2));
            L_DescSabn.setText(descripReg(3));
            L_DescJung.setText(descripReg(4));
            L_DescTundra.setText(descripReg(5));
            L_DescTaig.setText(descripReg(6));
            L_DescPant.setText(descripReg(7));
            L_DescNether.setText(descripReg(8));
            L_DescEnd.setText(descripReg(9));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}