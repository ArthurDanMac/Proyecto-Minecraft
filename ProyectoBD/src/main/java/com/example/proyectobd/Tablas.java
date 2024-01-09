package com.example.proyectobd;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.MapValueFactory;

import java.sql.*;
import java.util.Map;

public class Tablas {


    public void tablaMateriales(TableView Materiales,TableColumn Tipo,TableColumn Precio,TableColumn Cat) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> lista=listas.dameMateriales();

//    public TableView TB_Materiales;
//    public TableColumn COL_TipoMaterial,COL_PrecioM,COL_CategoriaM
        Cat.setCellValueFactory(new MapValueFactory<>("COL_CategoriaM"));
        Precio.setCellValueFactory(new MapValueFactory<>("COL_PrecioM"));
        Tipo.setCellValueFactory(new MapValueFactory<>("COL_TipoMaterial"));

        Materiales.setItems(lista);
    }

    public void tablaHerramientas(TableView Herramientas,TableColumn Tipo,TableColumn Comp,TableColumn Prec,TableColumn Cat) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> lista=listas.dameHerramientas();
        //TB_Herramientas;
//TableColumn COL_TipoHerramienta,COL_ComponenteH,COL_PrecioH,COL_CategoriaH
        Tipo.setCellValueFactory(new MapValueFactory<>("COL_TipoHerramienta"));
        Comp.setCellValueFactory(new MapValueFactory<>("COL_ComponenteH"));
        Cat.setCellValueFactory(new MapValueFactory<>("COL_CategoriaH"));
        Prec.setCellValueFactory(new MapValueFactory<>("COL_PrecioH"));

        Herramientas.setItems(lista);
    }

    public void tablaMaterialesJ(TableView mats, TableColumn tipM, TableColumn categM, TableColumn precM, TableColumn cantM) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> lista=listas.dameInventarioMatsJ();
        //TB_inventarioMats;
        //TableColumn COL_TipoMats,COL_categoriaMats,COL_precioMats,COL_cantidadMats;
        tipM.setCellValueFactory(new MapValueFactory<>("COL_TipoMats"));
        categM.setCellValueFactory(new MapValueFactory<>("COL_categoriaMats"));
        precM.setCellValueFactory(new MapValueFactory<>("COL_precioMats"));
        cantM.setCellValueFactory(new MapValueFactory<>("COL_cantidadMats"));

        mats.setItems(lista);
    }

    public void tablaHerramientasJ(TableView herr, TableColumn tipoH,TableColumn cantH, TableColumn catH,TableColumn precH,TableColumn compH) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> lista=listas.dameInventarioHerrJ();
        //TB_inventarioHerr;
        //TableColumn COL_TipoHerr,COL_cantidadHerr,COL_categoriaHerr,COL_precioHerr,COL_ComponHerr;
        tipoH.setCellValueFactory(new MapValueFactory<>("COL_TipoHerr"));
        cantH.setCellValueFactory(new MapValueFactory<>("COL_cantidadHerr"));
        catH.setCellValueFactory(new MapValueFactory<>("COL_categoriaHerr"));
        precH.setCellValueFactory(new MapValueFactory<>("COL_precioHerr"));
        compH.setCellValueFactory(new MapValueFactory<>("COL_ComponHerr"));

        herr.setItems(lista);
    }

    public void tablaBusquedaMateriales(TableColumn Tip, TableColumn Cat, TableColumn Prec, TableColumn ALdean, TableColumn Reg, TableView Mater) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> list=listas.dameBusquedaMateriales();
        //TB_Materiales;
        //TableColumn COL_TipoMaterial, COL_CategoriaMats,COL_PrecioMats,COL_ALdeanoMats,COL_RegionMats
        Tip.setCellValueFactory(new MapValueFactory<>("COL_TipoMaterial"));
        Cat.setCellValueFactory(new MapValueFactory<>("COL_CategoriaMats"));
        Prec.setCellValueFactory(new MapValueFactory<>("COL_PrecioMats"));
        ALdean.setCellValueFactory(new MapValueFactory<>("COL_ALdeanoMats"));
        Reg.setCellValueFactory(new MapValueFactory<>("COL_RegionMats"));

        Mater.setItems(list);
    }

    public void tablaBusquedaPrecio(TableColumn Cat, TableColumn Prec, TableColumn Aldea, TableColumn Reg, TableView Precio) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> list=listas.dameBusquedaPrecio();
//        TB_Precio;
//        TableColumn COL_CategroriaPrecios,COL_PrecioPrecios,COL_AldeanoPrecios,COL_RegionPrecios;
        Cat.setCellValueFactory(new MapValueFactory<>("COL_CategroriaPrecios"));
        Prec.setCellValueFactory(new MapValueFactory<>("COL_PrecioPrecios"));
        Aldea.setCellValueFactory(new MapValueFactory<>("COL_AldeanoPrecios"));
        Reg.setCellValueFactory(new MapValueFactory<>("COL_RegionPrecios"));

        Precio.setItems(list);
    }

    public void tablaBusquedaHerramientas(TableColumn Tipo, TableColumn Comp, TableColumn Cat, TableColumn Prec, TableColumn Aldea, TableColumn Reg, TableView Herr) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> list=listas.dameBusquedaHerramientas();
        //TB_Herramientas;
        //TableColumn COL_TipoHerr,COL_ComponenteHerr,COL_CategoriaHerr,COL_PrecioHerr,COL_AldeanoHerr,COL_RegionHerr
        Tipo.setCellValueFactory(new MapValueFactory<>("COL_TipoHerr"));
        Comp.setCellValueFactory(new MapValueFactory<>("COL_ComponenteHerr"));
        Cat.setCellValueFactory(new MapValueFactory<>("COL_CategoriaHerr"));
        Prec.setCellValueFactory(new MapValueFactory<>("COL_PrecioHerr"));
        Aldea.setCellValueFactory(new MapValueFactory<>("COL_AldeanoHerr"));
        Reg.setCellValueFactory(new MapValueFactory<>("COL_RegionHerr"));

        Herr.setItems(list);
    }

    public void tablaMaterialesRegion(TableColumn id,TableColumn Cat, TableColumn Precio, TableColumn Tipo, TableView<Map> Materiales) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> lista=listas.dameMaterialesRegion();
        //COL_idMat,col_categoria,col_precio,col_tipo,materiales
        id.setCellValueFactory(new MapValueFactory<>("COL_idMat"));
        Cat.setCellValueFactory(new MapValueFactory<>("col_categoria"));
        Precio.setCellValueFactory(new MapValueFactory<>("col_precio"));
        Tipo.setCellValueFactory(new MapValueFactory<>("col_tipo"));

        Materiales.setItems(lista);
    }

    public void tablaHerramientasRegion(TableColumn id,TableColumn Tipo, TableColumn Comp, TableColumn Cat, TableColumn Prec, TableView<Map> Herramientas) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> lista=listas.dameHerramientasRegion();
        //COL_idHerr,col_tipHerr,col_componente,col_catHerr,col_precioHerr
        id.setCellValueFactory(new MapValueFactory<>("COL_idHerr"));
        Tipo.setCellValueFactory(new MapValueFactory<>("col_tipHerr"));
        Comp.setCellValueFactory(new MapValueFactory<>("col_componente"));
        Cat.setCellValueFactory(new MapValueFactory<>("col_catHerr"));
        Prec.setCellValueFactory(new MapValueFactory<>("col_precioHerr"));

        Herramientas.setItems(lista);
    }

    public void tablaAldeanos(TableView Aldeanos, TableColumn Nombre, TableColumn Cant, TableColumn Prec, TableColumn Cat) throws SQLException {
        //TB_Aldeanos,COL_NombreAldeanoA,COL_CantidadA,COL_PrecioA, COL_CategoriaA
        Listas listas=new Listas();
        ObservableList<Map> lista=listas.dameProductosALdeanos();
        //col_tipHerr,col_componente,col_catHerr,col_precioHerr
        Nombre.setCellValueFactory(new MapValueFactory<>("COL_NombreAldeanoA"));
        Cant.setCellValueFactory(new MapValueFactory<>("COL_CantidadA"));
        Prec.setCellValueFactory(new MapValueFactory<>("COL_PrecioA"));
        Cat.setCellValueFactory(new MapValueFactory<>("COL_CategoriaA"));

        Aldeanos.setItems(lista);
    }

    public void tablasJugadores(TableColumn Nombre, TableColumn Cat, TableColumn Cant,TableView Juga) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> lista=listas.dameJugadores();
        //COL_NombreJ, COL_Categoria,COL_Cantidad
        Nombre.setCellValueFactory(new MapValueFactory<>("COL_NombreJ"));
        Cat.setCellValueFactory(new MapValueFactory<>("COL_Categoria"));
        Cant.setCellValueFactory(new MapValueFactory<>("COL_Cantidad"));

        Juga.setItems(lista);
    }

    public void tablaAldeanoProductoRegion(TableView ProductoA, TableColumn Cat, TableColumn Prec) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> lista=listas.dameAldeanoProductoRegion();
//COL_CategroriaA,COL_PrecioA
        Cat.setCellValueFactory(new MapValueFactory<>("COL_CategoriaA"));
        Prec.setCellValueFactory(new MapValueFactory<>("COL_PrecioA"));

        ProductoA.setItems(lista);
    }

    public void tablaAldeanosRegion(TableView AldeanoR, TableColumn NombreA, TableColumn Salario, TableColumn NombreReg) throws SQLException {
        Listas listas=new Listas();
        ObservableList<Map> lista=listas.dameAldeanoRegion();
//COL_nombreAR, COL_salarioAR,COL_nombreRegAR
        NombreA.setCellValueFactory(new MapValueFactory<>("COL_nombreAR"));
        Salario.setCellValueFactory(new MapValueFactory<>("COL_salarioAR"));
        NombreReg.setCellValueFactory(new MapValueFactory<>("COL_nombreRegAR"));


        AldeanoR.setItems(lista);
    }
}
