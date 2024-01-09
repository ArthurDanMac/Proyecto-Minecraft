package com.example.proyectobd;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

public class Listas extends Conexion{
    //todas las herramientas y materiales solos y por aldeano(P_Principal>>Mundo)
    public ObservableList<Map> dameMateriales() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sentencia="SELECT * FROM VistaMateriales";
        Statement vista= conet.createStatement();
        ResultSet rs=vista.executeQuery(sentencia);
        try{
            while(rs.next()){
                Productos_Materiales pm=new Productos_Materiales();
                Map<String, Object> col=new HashMap<>();
                pm.setTipo_mat(rs.getString("Tipo_Material"));
                pm.setPrecio(Integer.parseInt(rs.getString("Precio_Esmeralda")));
                pm.setCategoria(rs.getString("Categoria"));

//    public TableView TB_Materiales;
//    public TableColumn COL_TipoMaterial,COL_PrecioM,COL_CategoriaM
                col.put("COL_CategoriaM",pm.getCategoria());
                col.put("COL_TipoMaterial",pm.getTipo_mat());
                col.put("COL_PrecioM",pm.getPrecio());
                inven.add(col);
            }
        }catch (SQLException e) {
            System.out.println(e);
        }
        return inven;
    }
    public ObservableList<Map> dameHerramientas() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sentencia="SELECT * FROM VistaHerramientas";
        Statement vista= conet.createStatement();
        ResultSet rs=vista.executeQuery(sentencia);
        while(rs.next()){
            ProductosHerramientas ph=new ProductosHerramientas();
            Map<String, Object> col=new HashMap<>();
            ph.setTipoHerramienta(rs.getString("Tipo_Herramienta"));
            ph.setComponente(rs.getString("Componente"));
            ph.setPrecio(Integer.parseInt(rs.getString("Precio_Esmeralda")));
            ph.setCategoria(rs.getString("Categoria"));
//TB_Herramientas;
//TableColumn COL_TipoHerramienta,COL_ComponenteH,COL_PrecioH,COL_CategoriaH;
            col.put("COL_TipoHerramienta",ph.getTipoHerramienta());
            col.put("COL_ComponenteH",ph.getComponente());
            col.put("COL_CategoriaH",ph.getCategoria());
            col.put("COL_PrecioH",ph.getPrecio());

            inven.add(col);
        }
        return inven;
    }
    public ObservableList<Map> dameProductosALdeanos() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sentencia="SELECT * FROM VistaProductosPorAldeano";
        Statement vista= conet.createStatement();
        ResultSet rs=vista.executeQuery(sentencia);
        while (rs.next()){
            DatosProductoAldeano dpa=new DatosProductoAldeano();
            Map<String, Object> lista=new HashMap<>();
            dpa.setNombreAldeano(rs.getString("Nombre_Aldeano"));
            dpa.setCantidad(Integer.parseInt(rs.getString("Cantidad")));
            dpa.setPrecio(Integer.parseInt(rs.getString("Precio_Esmeralda")));
            dpa.setCategoria(rs.getString("Categoria"));
            //COL_NombreAldeanoA,COL_CantidadA,COL_PrecioA, COL_CategoriaA
            lista.put("COL_NombreAldeanoA",dpa.getNombreAldeano());
            lista.put("COL_CantidadA",dpa.getCantidad());
            lista.put("COL_PrecioA",dpa.getPrecio());
            lista.put("COL_CategoriaA",dpa.getCategoria());

            inven.add(lista);
        }
        return inven;
    }

    public ObservableList<Map> dameAldeanoRegion() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sql="SELECT * FROM VistaRegionesConAldeano";
        Statement vista= conet.createStatement();
        ResultSet rs=vista.executeQuery(sql);

        while (rs.next()){
            DatosProductoAldeano dpa=new DatosProductoAldeano();
            Map<String, Object> lista=new HashMap<>();

            dpa.setNombreAldenoR(rs.getString("Nombre_Aldeano"));
            dpa.setSalario(Integer.parseInt(rs.getString("Salario_Esmeraldas")));
            dpa.setNombreRegion(rs.getString("Nombre_Region"));

            //COL_nombreAR, COL_salarioAR,COL_nombreRegAR
            lista.put("COL_nombreAR",dpa.getNombreAldenoR());
            lista.put("COL_salarioAR",dpa.getSalario());
            lista.put("COL_nombreRegAR",dpa.getNombreRegion());

            inven.add(lista);
        }
        return inven;
    }


    //vista de todos los jugadores (P_Principal>>Jugadores)
    public ObservableList<Map> dameJugadores() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sentencia="SELECT * FROM VistaInventarioJugadores";
        Statement vista= conet.createStatement();
        ResultSet rs=vista.executeQuery(sentencia);
        while (rs.next()){
            Map<String, Object> lista=new HashMap<>();
            DatosJugadores jugadores=new DatosJugadores();
            jugadores.setNombreJ(rs.getString("Nombre_Jugador"));
            jugadores.setCategoriaJ(rs.getString("Categoria"));
            jugadores.setCantidadJ(Integer.parseInt(rs.getString("Cantidad")));
            //COL_NombreJ, COL_Categoria,COL_Cantidad
            lista.put("COL_NombreJ",jugadores.getNombreJ());
            lista.put("COL_Categoria",jugadores.getCategoriaJ());
            lista.put("COL_Cantidad",jugadores.getCantidadJ());

            inven.add(lista);
        }
        return inven;
    }



    //inventario de Jugador con sesión iniciada(Perfil)
    public ObservableList<Map> dameInventarioMatsJ() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        DatosPerfil datosPerfil=new DatosPerfil();
        String sql="{call ObtenerMaterialesEnInventarioJugador(?)}";
        CallableStatement sentencia=conet.prepareCall(sql);
        int id=datosPerfil.getIdUsuario();
        System.out.println(sql);
        sentencia.setInt(1,id);
        System.out.println("El id del jugador es el: "+id);

        ResultSet rs=sentencia.executeQuery();

            while (rs.next()){
                DatosInventarioJugadores dij = new DatosInventarioJugadores();
                Map<String, Object> lista = new HashMap<>();

                dij.setCantidadMaterial(Integer.parseInt(rs.getString("Cantidad")));
                dij.setCategoriaMaterial(rs.getString("Categoria"));
                dij.setPrecioMaterial(Integer.parseInt(rs.getString("Precio_Esmeralda")));
                dij.setTipoMaterial(rs.getString("Tipo_Material"));
                //TB_inventarioMats;
                //TableColumn COL_TipoMats,COL_categoriaMats,COL_precioMats,COL_cantidadMats;
                lista.put("COL_TipoMats", dij.getTipoMaterial());
                lista.put("COL_categoriaMats", dij.getCategoriaMaterial());
                lista.put("COL_precioMats", dij.getPrecioMaterial());
                lista.put("COL_cantidadMats", dij.getCantidadMaterial());

                inven.add(lista);
            }
        return inven;
    }

    public ObservableList dameInventarioHerrJ() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        DatosPerfil datosPerfil=new DatosPerfil();
        String sql="{call ObtenerHerramientasEnInventarioJugador(?)}";
        CallableStatement sentencia=conet.prepareCall(sql);
        int id=datosPerfil.getIdUsuario();

        System.out.println(sql);
        sentencia.setInt(1,id);
        System.out.println("El id del jugador es el: "+id);
        ResultSet rs=sentencia.executeQuery();
        while (rs.next()) {
            DatosInventarioJugadores dij = new DatosInventarioJugadores();
            Map<String, Object> lista = new HashMap<>();
            dij.setTipoHerramienta(rs.getString("Tipo_Herramienta"));
            dij.setCantidadHerramienta(Integer.parseInt(rs.getString("Cantidad")));
            dij.setCategoriaHerramienta(rs.getString("Categoria"));
            dij.setComponenteHerramienta(rs.getString("Componente"));
            dij.setPrecioHerramienta(Integer.parseInt(rs.getString("Precio_Esmeralda")));

            lista.put("COL_TipoHerr", dij.getTipoHerramienta());
            lista.put("COL_cantidadHerr", dij.getCantidadHerramienta());
            lista.put("COL_categoriaHerr", dij.getCategoriaHerramienta());
            lista.put("COL_precioHerr", dij.getPrecioHerramienta());
            lista.put("COL_ComponHerr", dij.getComponenteHerramienta());
            inven.add(lista);
        }
        return inven;
    }



    //busquedas de producto (Busqueda)
    public ObservableList<Map> dameBusquedaMateriales() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sql="{call ObtenerInformacionMaterialPorNombre(?)}";
        CallableStatement sentencia=conet.prepareCall(sql);
        String palabra=Datos.busqueda;
        System.out.println("Material a buscar: "+palabra);
        sentencia.setString(1,palabra);
        ResultSet rs=sentencia.executeQuery();
        while (rs.next()){
            DatosDeBusqueda ddb=new DatosDeBusqueda();
            Map<String, Object> lista = new HashMap<>();

            ddb.setTipoMaterial(rs.getString("Tipo_Material"));
            ddb.setCategoriaM(rs.getString("Categoria"));
            ddb.setPrecioM(Integer.parseInt(rs.getString("Precio_Esmeralda")));
            ddb.setAldeanoM(rs.getString("Nombre_Aldeano"));
            ddb.setRegionM(rs.getString("Nombre_Region"));
            //COL_TipoMaterial, COL_CategoriaMats,COL_PrecioMats,COL_ALdeanoMats,COL_RegionMats
            lista.put("COL_TipoMaterial",ddb.getTipoMaterial());
            lista.put("COL_CategoriaMats",ddb.getCategoriaM());
            lista.put("COL_PrecioMats",ddb.getPrecioM());
            lista.put("COL_ALdeanoMats",ddb.getAldeanoM());
            lista.put("COL_RegionMats",ddb.getRegionM());

            inven.add(lista);
        }
        return inven;
    }

    public ObservableList<Map> dameBusquedaPrecio() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sql="{call ObtenerProductosPorPrecio(?)}";
        CallableStatement sentencia=conet.prepareCall(sql);
        int palabra=1;
        palabra=Integer.parseInt(Datos.busqueda);
        System.out.println("Precio minimo: "+palabra);
        sentencia.setInt(1,palabra);
        ResultSet rs=sentencia.executeQuery();
        while (rs.next()){
            DatosDeBusqueda ddb=new DatosDeBusqueda();
            Map<String, Object> lista = new HashMap<>();
            ddb.setPrecioP(Integer.parseInt(rs.getString("Precio_Esmeralda")));
            ddb.setCategoriaP(rs.getString("Categoria_Producto"));
            ddb.setAldeanoP(rs.getString("Nombre_Aldeano"));
            ddb.setRegionP(rs.getString("Nombre_Region"));
            //TB_Precio;
            //TableColumn COL_CategroriaPrecios,COL_PrecioPrecios,COL_AldeanoPrecios,COL_RegionPrecios;
            lista.put("COL_CategroriaPrecios",ddb.getCategoriaP());
            lista.put("COL_PrecioPrecios",ddb.getPrecioP());
            lista.put("COL_AldeanoPrecios",ddb.getAldeanoP());
            lista.put("COL_RegionPrecios",ddb.getRegionP());

            inven.add(lista);
        }
        return inven;
    }

    public ObservableList<Map> dameBusquedaHerramientas() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sql="{call ObtenerInformacionHerramientaPorNombre(?)}";
        CallableStatement sentencia=conet.prepareCall(sql);
        String palabra=Datos.busqueda;
        System.out.println("Herramienta a buscar: "+palabra);
        sentencia.setString(1,palabra);
        ResultSet rs=sentencia.executeQuery();
        while (rs.next()){
            System.out.println("prueba");
            DatosDeBusqueda ddb=new DatosDeBusqueda();
            Map<String, Object> lista = new HashMap<>();

            ddb.setTipoHerramienta(rs.getString("Tipo_Herramienta"));
            ddb.setComponenteH(rs.getString("Componente"));
            ddb.setCategoriaH(rs.getString("Categoria"));
            ddb.setPrecioH(Integer.parseInt(rs.getString("Precio_Esmeralda")));
            ddb.setAldeanoH(rs.getString("Nombre_Aldeano"));
            ddb.setRegionH(rs.getString("Nombre_Region"));
            //TB_Herramientas;
            //TableColumn COL_TipoHerr,COL_ComponenteHerr,COL_CategoriaHerr,COL_PrecioHerr,COL_AldeanoHerr,COL_RegionHerr
            lista.put("COL_TipoHerr",ddb.getTipoHerramienta());
            lista.put("COL_ComponenteHerr",ddb.getComponenteH());
            lista.put("COL_CategoriaHerr",ddb.getCategoriaH());
            lista.put("COL_PrecioHerr",ddb.getPrecioH());
            lista.put("COL_AldeanoHerr",ddb.getAldeanoH());
            lista.put("COL_RegionHerr",ddb.getRegionH());

            inven.add(lista);
        }
        return inven;
    }



    //materiales y herramineta de cada region(tienda)
    public ObservableList<Map> dameMaterialesRegion() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sql="{call ObtenerMaterialesPorRegion(?)}";

        CallableStatement sentencia= conet.prepareCall(sql);
        int reg=Datos.region;
        reg++;
        sentencia.setInt(1,reg);
        ResultSet rs=sentencia.executeQuery();

            while(rs.next()){
                Productos_Materiales pm=new Productos_Materiales();
                Map<String, Object> col=new HashMap<>();
                pm.setTipo_mat(rs.getString("Tipo_Material"));
                pm.setPrecio(Integer.parseInt(rs.getString("Precio_Esmeralda")));
                pm.setCategoria(rs.getString("Categoria_Producto"));
                pm.setIdMat(Integer.parseInt(rs.getString("ID_Producto")));
                //COL_idMat,col_categoria,col_precio,col_tipo,materiales
                col.put("COL_idMat",pm.getIdMat());
                col.put("col_categoria",pm.getCategoria());
                col.put("col_tipo",pm.getTipo_mat());
                col.put("col_precio",pm.getPrecio());
                inven.add(col);
            }
        return inven;
    }

    public ObservableList<Map> dameHerramientasRegion() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sql="{call ObtenerHerramientasPorRegion(?)}";
        CallableStatement sentencia= conet.prepareCall(sql);
        int reg=Datos.region;
        reg++;
        sentencia.setInt(1,reg);
        ResultSet rs=sentencia.executeQuery();
        while(rs.next()){
            ProductosHerramientas ph=new ProductosHerramientas();
            Map<String, Object> col=new HashMap<>();
            ph.setTipoHerramienta(rs.getString("Tipo_Herramienta"));
            ph.setComponente(rs.getString("Componente"));
            ph.setPrecio(Integer.parseInt(rs.getString("Precio_Esmeralda")));
            ph.setCategoria(rs.getString("Categoria_Producto"));
            ph.setIdHerrs(Integer.parseInt(rs.getString("ID_Producto")));
            //COL_idHerr,col_tipHerr,col_componente,col_catHerr,col_precioHerr
            col.put("COL_idHerr",ph.getIdHerrs());
            col.put("col_tipHerr",ph.getTipoHerramienta());
            col.put("col_componente",ph.getComponente());
            col.put("col_catHerr",ph.getCategoria());
            col.put("col_precioHerr",ph.getPrecio());

            inven.add(col);
        }
        return inven;
    }

    public ObservableList<Map> dameAldeanoProductoRegion() throws SQLException {
        ObservableList<Map> inven = FXCollections.observableArrayList();
        String sql="{call ObtenerProductosPorAldeano(?)}";
        //DatosAldeano aldeano=new DatosAldeano();
        int id=DatosAldeano.idAldeano;
        CallableStatement sentencia= conet.prepareCall(sql);
        sentencia.setInt(1,id);
        ResultSet rs=sentencia.executeQuery();

        while (rs.next()){
            DatosAldeanoProductoRegion productoRegion=new DatosAldeanoProductoRegion();
            Map<String, Object> col=new HashMap<>();
            productoRegion.setCategoriaAPR(rs.getString("Categoria_Producto"));
            productoRegion.setPrecioAPR(Integer.parseInt(rs.getString("Precio_Esmeralda")));
            //COL_CategroriaA,COL_PrecioA
            col.put("COL_CategoriaA",productoRegion.getCategoriaAPR());
            col.put("COL_PrecioA",productoRegion.getPrecioAPR());

            inven.add(col);
        }
        return inven;
    }


}
