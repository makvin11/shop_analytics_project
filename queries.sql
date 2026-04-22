-- 1. Вывести все товары
SELECT * FROM products;

-- 2. Вывести названия всех категорий
SELECT name FROM categories;

-- 3. Найти самый дорогой товар
SELECT * FROM products ORDER BY price DESC LIMIT 1;

-- 4. Найти самый дешевый товар
SELECT * FROM products ORDER BY price ASC LIMIT 1;

-- 5. Вывести товары стоимостью дороже 50 000
SELECT * FROM products WHERE price > 50000;

-- 6. Вывести первые 10 продаж (по дате сортировки)
SELECT * FROM sales ORDER BY sale_date ASC LIMIT 10;

-- 7. Вывести продажи, где количество купленного товара больше 3
SELECT * FROM sales WHERE quantity > 3;

-- 8. Найти все чеки (total_amount) на сумму свыше 100 000
SELECT * FROM sales WHERE total_amount > 100000;

-- 9. Вывести товары, в названии которых есть слово "Книга"
SELECT * FROM products WHERE name LIKE '%Книга%';

-- 10. Вывести продажи за определенную дату
SELECT * FROM sales WHERE sale_date::date = '2023-05-15';

-- 11. Посчитать общее количество категорий
SELECT COUNT(*) FROM categories;

-- 12. Посчитать общее количество товаров в базе
SELECT COUNT(*) FROM products;

-- 13. Найти среднюю цену всех товаров
SELECT AVG(price) FROM products;

-- 14. Посчитать общую сумму всей выручки за всё время
SELECT SUM(total_amount) FROM sales;

-- 15. Найти максимальную сумму одного чека
SELECT MAX(total_amount) FROM sales;

-- 16. Найти минимальную сумму одного чека
SELECT MIN(total_amount) FROM sales;

-- 17. Посчитать общее количество проданных штук за всё время
SELECT SUM(quantity) FROM sales;

-- 18. Вывести ID товара и количество его продаж (в штуках)
SELECT product_id, SUM(quantity) FROM sales GROUP BY product_id;

-- 19. Вывести ID товара и общую сумму выручки по нему
SELECT product_id, SUM(total_amount) FROM sales GROUP BY product_id;

-- 20. Вывести ID товаров, общая выручка которых превысила 1 000 000
SELECT product_id, SUM(total_amount) as total FROM sales GROUP BY product_id HAVING SUM(total_amount) > 1000000;

-- 21. Посчитать количество продаж по дням
SELECT sale_date::date, COUNT(*) FROM sales GROUP BY sale_date::date ORDER BY sale_date::date;

-- 22. Найти день с максимальной выручкой
SELECT sale_date::date, SUM(total_amount) FROM sales GROUP BY sale_date::date ORDER BY SUM(total_amount) DESC LIMIT 1;

-- 23. Вывести название товара и название его категории
SELECT p.name as product, c.name as category FROM products p JOIN categories c ON p.category_id = c.category_id;

-- 24. Вывести список продаж с указанием названия товара
SELECT s.*, p.name FROM sales s JOIN products p ON s.product_id = p.product_id;

-- 25. Вывести названия категорий и общую сумму выручки по каждой из них
SELECT c.name, SUM(s.total_amount) FROM categories c 
JOIN products p ON c.category_id = p.category_id 
JOIN sales s ON p.product_id = s.product_id GROUP BY c.name;

-- 26. Вывести название категории, в которой самый дорогой средний чек
SELECT c.name, AVG(s.total_amount) FROM categories c 
JOIN products p ON c.category_id = p.category_id 
JOIN sales s ON p.product_id = s.product_id 
GROUP BY c.name ORDER BY AVG(s.total_amount) DESC LIMIT 1;

-- 27. Вывести информацию о продажах (Дата, Название товара, Категория, Сумма)
SELECT s.sale_date, p.name, c.name, s.total_amount 
FROM sales s 
JOIN products p ON s.product_id = p.product_id 
JOIN categories c ON p.category_id = c.category_id;

-- 28. Найти названия товаров, которые ни разу не продавались
SELECT p.name FROM products p LEFT JOIN sales s ON p.product_id = s.product_id WHERE s.sale_id IS NULL;

-- 29. Вывести товары, цена которых выше средней цены всех товаров
SELECT * FROM products WHERE price > (SELECT AVG(price) FROM products);

-- 30. Найти топ-3 самых продаваемых товара (по выручке)
SELECT p.name, c.name as category, SUM(s.total_amount) as revenue 
FROM sales s 
JOIN products p ON s.product_id = p.product_id 
JOIN categories c ON p.category_id = c.category_id 
GROUP BY p.name, c.name ORDER BY revenue DESC LIMIT 3;