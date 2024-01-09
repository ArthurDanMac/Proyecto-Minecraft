package com.example.proyectobd;
import javafx.event.ActionEvent;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.*;

public class Conexion {
    static Connection conet;
    public Connection Conetsion() throws SQLException {
        if (conet!=null)
            conet.close();
        Connection con=null;
        String url = "jdbc:sqlserver://LAPTOP-QAM84VNJ:1433;databaseName=MINECRAFT;TrustServerCertificate=True";
        try{
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("Driver OK");
        }
        catch (ClassNotFoundException e) {
            System.out.println("ERROR DE DRIVER: "+e);
        }
        try {
            con= DriverManager.getConnection(url,"sa","oda");
            System.out.println("Conexion exitosa");
            //setConet(con);
            conet=con;
        } catch (Exception e) {
            System.out.println("ERROR DE CONEXION: "+e);
        }
        return con;
    }
    public void ventana(ActionEvent e, String fxml, String titulo) throws IOException {
        Node source = (Node) e.getSource();
        Stage stage1 = (Stage) source.getScene().getWindow();
        stage1.close();

        FXMLLoader fxmlLoader = new FXMLLoader(SelectRegion.class.getResource(fxml));
        Scene scene = new Scene(fxmlLoader.load());
        Stage stage = new Stage();
        stage.setResizable(false);
        stage.setTitle(titulo);
        stage.setScene(scene);
        stage.show();
    }
}
