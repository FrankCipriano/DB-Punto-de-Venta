/*-BASE DE DATOS PARA PUNTO DE VENTA CON MARIADB*/

create database PDVenta;
show databases;
use PDVenta;

/*-CREACION DE LA ENTIDAD CATEGORIA-PRODUCTO*/
CREATE TABLE CategoriaProducto(
	CategoriaProductoID			INT NOT NULL auto_increment,
    Descripcion					VARCHAR(80) NOT NULL,
    FechaActualizacion			DATE NOT NULL,
    constraint pk_Categoria primary key(CategoriaProductoID)
);
/*-CREACION DE LA ENTIDAD PRODUCTO*/
CREATE TABLE Producto(
	ProductoID					INT NOT NULL auto_increment,
    CategoriaProductoID			INT NOT NULL,
    Descripcion					VARCHAR(60) NOT NULL,
    FechaRegistro				DATETIME NOT NULL,
    PrecioMayor					DOUBLE NOT NULL,
    PrecioUnitario				DOUBLE NOT NULL,
    Imagen						MEDIUMBLOB,
    LinkImagen					TINYTEXT,
    constraint pk_Producto primary key(ProductoID),
    constraint fk_Producto_CategoriaProductoID foreign key(CategoriaProductoID)
    references CategoriaProducto(CategoriaProductoID) match simple
    on update no action
    on delete no action
);

/*-CREACION DE LA ENTIDAD EXISTENCIA*/
CREATE TABLE Existencia(
	ExistenciaID				INT NOT NULL auto_increment,
    ProductoID					INT NOT NULL,
    Unidades					INT NOT NULL,
    FechaVencimiento			DATE NOT NULL,
    constraint pk_Existencia primary key(ExistenciaID),
    constraint fk_Existencia_ProductoID foreign key(ProductoID)
    references Producto(ProductoID) match simple
    on update no action
    on delete no action
);
/*-CREACION DE LA ENTIDAD PROVEEDOR*/
CREATE TABLE Proveedor(
	ProveedorID					INT NOT NULL auto_increment,
    Nombre						VARCHAR(45) NOT NULL,
    Telefono					VARCHAR(40) NOT NULL,
    Direccion					VARCHAR(60),
    Empresa						VARCHAR(60) NOT NULL,
    Email						VARCHAR(45) NOT NULL,
    NIT							VARCHAR(12) NOT NULL,
    constraint pk_Proveedor primary key(ProveedorID)
);
/*-CREACION DE LA ENTIDAD COMPRA*/
CREATE TABLE Compra(
	CompraID					INT NOT NULL auto_increment,
    ProveedorID					INT NOT NULL,
    Fecha						DATE NOT NULL,
    Monto						DOUBLE NOT NULL,
    constraint pk_Compra primary key(CompraID),
    constraint fk_Compra_ProveedorID foreign key(ProveedorID)
    references Proveedor(ProveedorID) match simple
    on update no action
    on delete no action
);
/*-CREACION DE LA ENTIDAD DETALLE-COMPRA*/
CREATE TABLE DetalleCompra(
	DetalleCompraID				INT NOT NULL auto_increment,
    ProductoID					INT NOT NULL,
    ProveedorID					INT NOT NULL,
    DescripcionCompra			VARCHAR(60) NOT NULL,
    Cantidad					INT NOT NULL,
    PesoProducto				INT NOT NULL,
    Costo						DOUBLE NOT NULL,
    SubTotal					DOUBLE NOT NULL,
    constraint pk_DetalleCompra primary key(DetalleCompraID),
    constraint fk_DetalleCompra_ProductoID foreign key(ProductoID)
    references Producto(ProductoID) match simple
    on update no action
    on delete no action,
    constraint fk_DetalleCompra_ProveedorID foreign key(ProveedorID)
    references Proveedor(ProveedorID) match simple
    on update no action
    on delete no action
);
/*-CREACION DE LA ENTIDAD CATEGORIA-PERSONAL*/
CREATE TABLE CategoriaPersonal(
	CategoriaPersonalID			INT NOT NULL auto_increment,
    Departamento				VARCHAR(40) NOT NULL,
    Puesto						VARCHAR(40) NOT NULL,
    Salario						DOUBLE NOT NULL,
    constraint pk_CategoriaPersonal primary key(CategoriaPersonalID)
);
/*-CREACION DE LA ENTIDAD PERSONAL*/
CREATE TABLE Personal(
	PersonalID					INT NOT NULL auto_increment,
    CategoriaPersonalID			INT NOT NULL,
    Nombre						VARCHAR(45) NOT NULL,
    Apellido					VARCHAR(45) NOT NULL,
    Direccion					VARCHAR(50) NOT NULL,
    CUI							VARCHAR(15) NOT NULL,
    Telefono					VARCHAR(40) NOT NULL,
    constraint pk_Personal primary key(PersonalID),
    constraint fk_Personal_CategoriaPersonalID foreign key(CategoriaPersonalID)
    references CategoriaPersonal(CategoriaPersonalID) match simple
    on update no action
    on delete no action
);
/*-CREACION DE LA ENTIDAD DB-USUARIO*/
CREATE TABLE DBUsuario(
	PersonalID					INT NOT NULL,
    Contrasenia					TINYTEXT NOT NULL,
    constraint pk_DBUsuario primary key(PersonalID),
    constraint fk_DBUsuario_PersonalID foreign key(PersonalID)
    references Personal(PersonalID) match simple
    on update no action
    on delete no action
);
/*-CREACION DE LA ENTIDAD CLIENTE*/
CREATE TABLE Cliente(
	ClienteID					INT NOT NULL auto_increment,
    Nombre						VARCHAR(45),
    Apellido					VARCHAR(45),
    Direccion					VARCHAR(50),
    NIT							VARCHAR(12),
    Telefono					VARCHAR(8),
    Email						VARCHAR(30),
    constraint pk_Cliente primary key(ClienteID)
);
/*-CREACION DE LA ENTIDAD CAJERO*/
CREATE TABLE Cajero(
	CajeroID					INT NOT NULL,
    constraint pk_Cajero primary key(CajeroID),
    constraint fk_Cajero_CajeroID foreign key(CajeroID)
    references Personal(PersonalID) match simple
    on update no action
    on delete no action
);
/*-CREACION DE LA ENTIDAD VENTA*/
CREATE TABLE Venta(
	VentaID						INT NOT NULL auto_increment,
    ClienteID					INT NOT NULL,
    CajeroID					INT NOT NULL,
    FechaFacturacion			DATETIME NOT NULL,
    TipoComprobante				VARCHAR(30) NOT NULL,
    NumeroSerie					VARCHAR(10) NOT NULL,
    Monto						DOUBLE NOT NULL,
    constraint pk_DetalleFactura primary key(VentaID),
    constraint fk_DetalleFactura_ClienteID foreign key(ClienteID)
    references Cliente(ClienteID) match simple
    on update no action
    on delete no action,
    constraint fk_DetalleFactura_CajeroID foreign key(CajeroID)
    references Cajero(CajeroID) match simple
    on update no action
    on delete no action
);
/*-CREACION DE LA ENTIDAD DETALLE-VENTA*/
CREATE TABLE DetalleVenta(
	DetalleVentaID				INT NOT NULL auto_increment,
    VentaID						INT NOT NULL,
    ProductoID					INT NOT NULL,
    CantidadProducto			INT NOT NULL,
    Precio						DOUBLE NOT NULL,
    SubTotal					DOUBLE NOT NULL,
    constraint pk_DetalleVenta primary key(DetalleVentaID),
    constraint fk_DetalleVenta_VentaID foreign key(VentaID)
    references Venta(VentaID) match simple
    on update no action
    on delete no action,
    constraint fk_DetalleVenta_ProductoID foreign key(ProductoID)
    references Producto(ProductoID) match simple
    on update no action
    on delete no action
);