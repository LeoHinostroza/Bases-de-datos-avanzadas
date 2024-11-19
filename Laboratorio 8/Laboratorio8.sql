--creacion de tablas--

create table dim_tiempo(
	id_tiempo serial primary key,
	año int not null,
	mes int not null,
	dia int not null,
	trimestre int not null
);

create table dim_libro(
	id_libro serial primary key,
	titulo varchar(100) not null,
	autor varchar(100)not null,
	genero varchar(100) not null,
	precio_unitario decimal (10,2) not null
);

create table dim_cliente(
	id_cliente serial primary key,
	nombre_cliente varchar(100) not null,
	edad int not null,
	genero char(1) check (genero in ('M','F')),
	ciudad varchar(100) not null
);

create table dim_tienda (
	id_tienda serial primary key,
	nombre_tienda varchar(50) not null,
	ciudad varchar(100) not null,
	pais varchar (100) not null
);


create table hechos_ventas_libros (
	id_venta serial primary key,
	id_tiempo int not null,
	id_libro int not null,
	id_cliente int not null,
	id_tienda int not null,
	cantidad int not null,
	precio_total decimal (10,2) not null,
	foreign key (id_tiempo) references dim_tiempo(id_tiempo),
	foreign key (id_libro) references dim_libro(id_libro),
	foreign key (id_cliente) references dim_cliente(id_cliente),
	foreign key (id_tienda) references dim_tienda(id_tienda)
);


--inserciones en las tablas--

insert into dim_tiempo (año, mes, dia, trimestre) VALUES
(2024, 11, 1, 3),
(2024, 7, 2, 4),
(2024, 11, 3, 4);

insert into dim_libro (titulo, autor, genero, precio_unitario) VALUES
('Cien años de soledad', 'Gabriel García Márquez', 'Novela', 20.50),
('El Principito', 'Antoine de Saint-Exupéry', 'Ficción', 15.99),
('1984', 'George Orwell', 'Distopía', 12.00),
('Harry Potter y la piedra filosofal', 'J.K. Rowling', 'Fantasía', 25.00),
('Don Quijote de la Mancha', 'Miguel de Cervantes', 'Clásico', 18.75);

insert into dim_cliente (nombre_cliente, edad, genero, ciudad) VALUES
('Juan Pérez', 30, 'M', 'Ciudad de México'),
('Ana López', 25, 'F', 'Guadalajara'),
('Carlos García', 35, 'M', 'Monterrey'),
('María Sánchez', 28, 'F', 'Querétaro'),
('Luis Hernández', 40, 'M', 'Puebla');

insert into dim_tienda (nombre_tienda, ciudad, pais) VALUES
('Librería Central', 'Ciudad de México', 'México'),
('Lecturas Ilustradas', 'Guadalajara', 'México'),
('Ficción y Más', 'Monterrey', 'México');

	
insert into hechos_ventas_libros (id_tiempo, id_libro, id_cliente, id_tienda, cantidad, precio_total) VALUES
(1, 1, 1, 1, 2, 41.00),
(2, 2, 2, 2, 1, 15.99),
(3, 3, 3, 3, 3, 36.00),
(1, 4, 4, 1, 4, 100.00),
(2, 5, 5, 2, 1, 18.75),
(3, 1, 2, 3, 2, 41.00),
(1, 3, 3, 1, 5, 60.00),
(2, 2, 4, 2, 3, 47.97),
(3, 4, 5, 3, 2, 50.00),
(1, 5, 1, 1, 1, 18.75);

--creacion de consultas de analisis--

--total de ventas--

create view total_ventas_por_genero_y_mes as
select 
    dl.genero, 
    dt.mes, 
    sum(hvl.precio_total) as total_ventas
from 
    hechos_ventas_libros hvl
join 
    dim_libro dl on hvl.id_libro = dl.id_libro
join 
    dim_tiempo dt on hvl.id_tiempo = dt.id_tiempo
group by 
    dl.genero, dt.mes
order by 
    dl.genero, dt.mes;



-- libros vendidos por tienda y autor--

create view cantidad_libros_por_tienda_y_autor as
select 
    dt.nombre_tienda, 
    dl.autor, 
    sum(hvl.cantidad) as total_libros
from 
    hechos_ventas_libros hvl
join 
    dim_tienda dt on hvl.id_tienda = dt.id_tienda
join 
    dim_libro dl on hvl.id_libro = dl.id_libro
group by 
    dt.nombre_tienda, dl.autor
order by 
    dt.nombre_tienda, dl.autor;



--ingresos totales por ciudad de cliente y trimestre--

create view ingresos_por_ciudad_y_trimestre as
select 
    dc.ciudad, 
    dt.trimestre, 
    sum(hvl.precio_total) as ingresos_totales
from 
    hechos_ventas_libros hvl
join 
    dim_cliente dc on hvl.id_cliente = dc.id_cliente
join 
    dim_tiempo dt on hvl.id_tiempo = dt.id_tiempo
group by 
    dc.ciudad, dt.trimestre
order by 
    dc.ciudad, dt.trimestre;



--total de ventas de cliente--

create view total_ventas_y_libros_por_cliente as
select 
    dc.nombre_cliente, 
    sum(hvl.precio_total) as total_gastado, 
    sum(hvl.cantidad) as total_libros_comprados
from 
    hechos_ventas_libros hvl
join 
    dim_cliente dc on hvl.id_cliente = dc.id_cliente
group by 
    dc.nombre_cliente
order by 
    total_gastado desc;





select *from total_ventas_por_genero_y_mes
select *from cantidad_libros_por_tienda_y_autor
select *from ingresos_por_ciudad_y_trimestre
select *from total_ventas_y_libros_por_cliente



