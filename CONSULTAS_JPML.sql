/*
a) Crear la base de datos con el archivo create_restaurant_db.sql
b) Explorar la tabla “menu_items” para conocer los productos del menú.
1.- Realizar consultas para contestar las siguientes preguntas:
● Encontrar el número de artículos en el menú.
● ¿Cuál es el artículo menos caro y el más caro en el menú?
● ¿Cuántos platos americanos hay en el menú?
● ¿Cuál es el precio promedio de los platos?
c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados.
1.- Realizar consultas para contestar las siguientes preguntas:
● ¿Cuántos pedidos únicos se realizaron en total?
● ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?
● ¿Cuándo se realizó el primer pedido y el último pedido?
● ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?
*/

-----------------------------------------
--b) Explorar la tabla “menu_items” para conocer los productos del menú.
SELECT * FROM menu_items;

--● Encontrar el número de artículos en el menú.
/* RESPUESTA:
	32 artículos*/
SELECT COUNT(menu_item_id) FROM menu_items;

--● ¿Cuál es el artículo menos caro y el más caro en el menú?
/*RESPUESTA:
	5.00 el menos caro	
	19.95 el más caro
	*/
SELECT MAX (price) FROM menu_items;
SELECT MIN (price) FROM menu_items;

--● ¿Cuántos platos americanos hay en el menú?
/*RESPUESTA:
	Seis platos americanos.
	*/
SELECT COUNT(*) AS platos_americanos FROM menu_items WHERE category ='American';
--también:
SELECT * FROM menu_items WHERE category ='American';

--● ¿Cuál es el precio promedio de los platos?
/*RESPUESTA:
	13.286 (limitado a 3 decimales)
	*/
SELECT ROUND (AVG(price),3) FROM menu_items;

-----------------------------------------
--c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados:
SELECT * FROM order_details;

--● ¿Cuántos pedidos únicos se realizaron en total?
/*RESPUESTA:
	5,370 pedidos únicos.
	*/
SELECT COUNT (DISTINCT order_id) FROM order_details;

--● ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?
/*RESPUESTA:
	Fueron los pedidos 440, 2675, 3473, 4305 y 443. Cada uno con 14.
	*/	
SELECT order_id, COUNT(order_details_id) AS numero_articulos
	FROM order_details
	GROUP BY order_id
	ORDER BY numero_articulos DESC
	LIMIT 5;

--● ¿Cuándo se realizó el primer pedido y el último pedido?
/*RESPUESTA:
	Primer pedido: 1 de enero de 2023.
	Último pedido: 31 de enero de 2023.
	*/	
SELECT MIN(order_date) AS primer_pedido, MAX(order_date) AS ultimo_pedido
	FROM order_details;

--● ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?
/*RESPUESTA:
	702 pedidos.
	*/	
SELECT COUNT(*) FROM order_details WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05';

-----------------------------------------
--d) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.
/*1.- Realizar un left join entre entre order_details y menu_items con el identificador
item_id(tabla order_details) y menu_item_id(tabla menu_items)*/
SELECT order_details.order_id,
	   order_details.order_date, 
	   order_details.order_time, 
       order_details.item_id,
       menu_items.menu_item_id, 
       menu_items.item_name, 
       menu_items.category,
       menu_items.price
FROM order_details
LEFT JOIN menu_items
	ON order_details.item_id = menu_items.menu_item_id;

--CON ALIAS:
SELECT od.order_id,
	   od.order_date, 
	   od.order_time, 
       od.item_id,
       mi.menu_item_id, 
       mi.item_name, 
       mi.category,
       mi.price
FROM order_details AS od
LEFT JOIN menu_items AS mi
	ON od.item_id = mi.menu_item_id;

-----------------------------------------
/*e) Una vez que hayas explorado los datos en las tablas correspondientes y respondido las preguntas
planteadas, realiza un análisis adicional utilizando este join entre las tablas.*/

--● 1) ¿Cuales fueron las categorías más y menos vendidas del menú?
/*RESPUESTA:
	La categoría que generó más ventas fue la Italiana.
	La categoría que generó menos ventas fue la Americana.
	*/
SELECT menu_items.category, 
       SUM(menu_items.price) AS ventas_por_categoría
FROM order_details
LEFT JOIN menu_items
    ON order_details.item_id = menu_items.menu_item_id
GROUP BY menu_items.category
ORDER BY ventas_por_categoría;

--● 2) ¿Qué alimento se consume más por la noche (después de las 19 horas)?
/* Por número de órdenes se consume más la comida asiática, le sigue la italiana, la mexicana,
	y por último la americana.
	*/
-- Análisis con tablas dinámicas de excel.

--● 3) ¿Cuales son los producto más y menos vendidos?
/*RESPUESTA:
	El producto más vendido en los tres meses de análisis fue  "Korean Beef Bowl".
	El producto menos vendido en los tres meses de análisis fue "Chicken Tacos".
	*/
SELECT menu_items.item_name, 
       SUM(menu_items.price) AS ventas_por_producto
FROM order_details
LEFT JOIN menu_items
    ON order_details.item_id = menu_items.menu_item_id
GROUP BY menu_items.item_name
ORDER BY ventas_por_producto DESC
LIMIT 5;


--● 4) ¿Cuál es el mes en el que se vendió menos y más?
/*RESPUESTA:
	Febrero vendió menos, con $50,790.35 (32%)
	Marzo vendió más, con $54,610.34 (34%)
	*/
-- Análisis con tablas dinámicas de excel.

--● 5) ¿Cuál es la hora pico de compras?
/*RESPUESTA:
	Hay un pico entre las 12 y las 13 horas, y uno más hacia las 17 horas.
	Las horas de menos compras son en la apertura (10 AM) y al cierre (11 PM).
	*/
-- Análisis con tablas dinámicas de excel.



