module com.example.proyectobd {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;
    requires com.microsoft.sqlserver.jdbc;

    opens com.example.proyectobd to javafx.fxml;
    exports com.example.proyectobd;
}