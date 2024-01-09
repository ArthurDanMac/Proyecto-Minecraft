package com.example.proyectobd;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

import static java.nio.charset.StandardCharsets.*;

public class Datos extends Conexion{
//    private String[] lugar={"Llanuras","Desierto","Sabana","Jungla","Tundra","Taiga","Pantano","Nether","End"};
    static String[] xmls={"Llanuras.fxml","Desierto.fxml","Sabana.fxml","Jungla.fxml","Tundra.fxml","Taiga.fxml","Pantano.fxml","Nether.fxml","End.fxml"};
    static int opcion;
    static int region;
    static String busqueda;

    public static void setRegion(int region) {
        Datos.region = region;
    }


    public boolean Perfil(String n,String c) throws SQLException, NoSuchAlgorithmException {
        boolean encontrado=false;
        DatosPerfil dp=new DatosPerfil();
        Statement sentencia=conet.createStatement();
        ResultSet rs=sentencia.executeQuery("select * from Jugadores");
        while (rs.next()){
            String nom= rs.getString("Nombre_Jugador");
            String contra= rs.getString("Contraseña");
            String correoE=rs.getString("Correo_Electronico");
            int saldo=Integer.parseInt(rs.getString("Saldo_Esmeraldas"));
            int id=Integer.parseInt(rs.getString("ID_Jugador"));
            if(n.equals(correoE)){
                System.out.println("contraseña de BD");
                System.out.println(contra);
                System.out.println("Contraseña introducida: "+c);
                System.out.println("contraseña introducida hasheada");
//                c=hashearCadena(c);//);
//                c=c.toUpperCase();
                System.out.println(c);
                if(c.equals(contra)){
                    dp.setNombre(nom);
                    dp.setCorreo(correoE);
                    dp.setSaldoUsuario(saldo);
                    dp.setIdUsuario(id);
                    dp.setContrasena(contra);
                    encontrado=true;
                }
            }
        }
        return encontrado;
    }

    public void SaldoDCompra() throws SQLException {
        DatosPerfil datosPerfil=new DatosPerfil();
        System.out.println("saldo anterior: "+datosPerfil.getSaldoUsuario());
        int saldo = 0;
        System.out.println("Id de usuario: "+datosPerfil.getIdUsuario());
        int id=datosPerfil.getIdUsuario();
        Connection com=Conetsion();
        PreparedStatement sentencia=com.prepareStatement("select * from Jugadores where ID_Jugador= ?");
        sentencia.setInt(1,id);
        ResultSet rs=sentencia.executeQuery();
        while (rs.next()){
            saldo=Integer.parseInt(rs.getString("Saldo_Esmeraldas"));
        }
        System.out.println("nuevo saldo: "+saldo);
        datosPerfil.setSaldoUsuario(saldo);
        System.out.println("corroborar: "+ datosPerfil.getSaldoUsuario());
    }

    public void ModificarPerfil(int id,String nuevonombre, String nuevocorreo, String nuevocontra,int saldo) throws SQLException {
        String sql="{call ModificarUsuario(?,?,?,?,?)}";
        System.out.println(sql);
        CallableStatement sentencia=conet.prepareCall(sql);
        sentencia.setInt(1,id);//ID
        sentencia.setString(2,nuevonombre);//nombre
        sentencia.setString(3,nuevocorreo);//correo
        sentencia.setString(4,nuevocontra);//contraseña
        sentencia.setInt(5,saldo);//saldo
        System.out.println("bandera");
        //sentencia.executeQuery();
        int rowsUpdated = sentencia.executeUpdate();
        if (rowsUpdated > 0) {
            System.out.println("El registro ha sido actualizado exitosamente.");
        }
    }

    public void RegistroUsuario(String nombre, String correo, String contrasena, int i) throws SQLException, NoSuchAlgorithmException {
        //contrasena=hashearCadena(contrasena);
        String sql="{call CrearUsuario(?,?,?,?)}";
        System.out.println(sql);
        CallableStatement sentencia=conet.prepareCall(sql);
        sentencia.setString(1,nombre);//nombre
        sentencia.setString(2,correo);//correo
        sentencia.setString(3,contrasena);//contraseña
        sentencia.setInt(4,1000);//saldo
        System.out.println("bandera");
        int rowsUpdated = sentencia.executeUpdate();
        if (rowsUpdated > 0) {
            System.out.println("El registro ha sido actualizado exitosamente.");
        }else
            System.out.println("no hay registro");
    }

    public boolean verificarCorreo(String c) throws SQLException {
        boolean correoexiste=false;
        String sql="select *from Jugadores";
        String correo;
        int i=0;
        Statement statement=conet.createStatement();
        ResultSet rs=statement.executeQuery(sql);
        while (rs.next()) {
            correo = rs.getString("Correo_Electronico");
            if (c.equals(correo)){
                i++;
            }
        }
        if(i>1) {
            correoexiste = true;
            return correoexiste;
        }
        else {
            return correoexiste;
        }
    }
    public void ComprarMaterial(String nombreMat,int id,int cant) throws SQLException {
        String sql="{call ComprarMaterialPorNombre(?,?,?)}";
        System.out.println(sql);
        CallableStatement sentencia=conet.prepareCall(sql);
        sentencia.setString(1,nombreMat);
        sentencia.setInt(2,id);
        sentencia.setInt(3,cant);
        int rowsUpdated = sentencia.executeUpdate();
        if (rowsUpdated > 0) {
            System.out.println("El registro ha sido actualizado exitosamente.");
        }
    }

    public void ComprarHerramienta(String nombreHerr, int id, int cant) throws SQLException {
        String sql="{call ComprarHerramientaPorNombre(?,?,?)}";
        System.out.println(sql);
        CallableStatement sentencia=conet.prepareCall(sql);
        sentencia.setString(1,nombreHerr);
        sentencia.setInt(2,id);
        sentencia.setInt(3,cant);
        int rowsUpdated = sentencia.executeUpdate();
        if (rowsUpdated > 0) {
            System.out.println("El registro ha sido actualizado exitosamente.");
        }
    }
    public void aldeanos() throws SQLException {
        int idAL,salarioAl,reg=region;
        reg++;
        System.out.println("ID de la region: "+reg);
        String nombreAl,nombreReg,regi=String.valueOf(reg);
        //String sql="select * from Aldeano where ID_Aldeano="+regi;
        String sql="select * from Aldeano where ID_Aldeano= ?";//"SELECT * FROM VistaRegionesConAldeano";
        PreparedStatement sentencia=conet.prepareStatement(sql);
        System.out.println(sql);
        //Statement sentencia=conet.createStatement();
        sentencia.setInt(1,reg);
        //ResultSet rs=sentencia.executeQuery(sql);
        ResultSet rs=sentencia.executeQuery();
        DatosAldeano da=new DatosAldeano();
        while (rs.next()){
            nombreAl= rs.getString("Nombre_Aldeano");
            salarioAl= Integer.parseInt(rs.getString("Salario_Esmeraldas"));
            idAL=Integer.parseInt(rs.getString("ID_Aldeano"));

            da.setNombre(nombreAl);
            da.setSalario(salarioAl);
            da.setIdAldeano(idAL);
            DatosAldeano.idAldeano=idAL;
            System.out.println(da.getNombre()+"\t"+da.getSalario()+"\t"+da.getIdAldeano());
        }
    }
    public String descripReg(int idReg) throws SQLException {
        String descp=null;
        String sql="{call DescripcionesRegiones(?)}";

        CallableStatement sentencia=conet.prepareCall(sql);

        System.out.println(sql);
        sentencia.setInt(1,idReg);

        ResultSet rs=sentencia.executeQuery();
        //  System.out.println(rs);
        while (rs.next()) {
            descp = rs.getString("Descripciones");
//            System.out.println(descp);
        }
        return descp;
    }

    public int regiones(int r){
        if(r<0||r>8) {
            if(r<0)
                r=8;
            else
                r=0;
        }
        return r;
    }
}