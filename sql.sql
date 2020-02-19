#Выведите поступления денег от пользователя с email 'vasya@mail.com'.
#В результат включите все столбцы таблицы и не меняйте порядка их вывода. Если, конечно, хотите успешно пройти проверку результата запроса )

SELECT * FROM billing WHERE `payer_email` = 'vasya@mail.com';

#######################################################################################################################################

#Добавьте в таблицу одну запись о платеже со следующими значениями:
#-email плательщика: 'pasha@mail.com'
#-email получателя: 'katya@mail.com'
#-сумма: 300.00
#-валюта: 'EUR'
#-дата операции: 14.02.2016
#-комментарий: 'Valentines day present)'

INSERT INTO billing (`payer_email`,`recipient_email`,`sum`,`currency`,`billing_date`,`comment`)
    VALUE ( 'pasha@mail.com','katya@mail.com',300.00, 'EUR', '2016-02-14', 'Valentines day present)');

#######################################################################################################################################

#Измените адрес плательщика на 'igor@mail.com' для всех записей таблицы, где адрес плательщика 'alex@mail.com'.

UPDATE billing SET `payer_email`='igor@mail.com' WHERE `payer_email`='alex@mail.com';

#######################################################################################################################################

#Удалите из таблицы записи, где адрес плательщика или адрес получателя установлен в неопределенное значение или пустую строку.

DELETE FROM billing WHERE `payer_email` IS NULL OR `recipient_email` IS NULL OR `payer_email` ='' OR `recipient_email` = '';

#######################################################################################################################################

#Выведите общее количество заказов компании.

SELECT COUNT(*) FROM `project`;

#######################################################################################################################################

#Выведите количество товаров в каждой категории. Результат должен содержать два столбца: 
#-название категории, 
#-количество товаров в данной категории.

SELECT `category`, COUNT(`sold_num`) FROM store GROUP BY `category`;

#######################################################################################################################################

#Выведите 5 категорий товаров, продажи которых принесли наибольшую выручку. Под выручкой понимается сумма произведений стоимости товара
#на количество проданных единиц. Результат должен содержать два столбца: 
#-название категории,
#-выручка от продажи товаров в данной категории.

SELECT `category`, SUM(`price` * `sold_num`) AS `LOL` FROM store GROUP BY `category` ORDER BY `LOL` DESC LIMIT 5;

#######################################################################################################################################

#Выведите в качестве результата одного запроса общее количество заказов, сумму стоимостей (бюджетов) всех проектов, средний срок
#исполнения заказа в днях.

SELECT COUNT(`project_name`),SUM(`budget`), AVG(DATEDIFF(`project_finish`,`project_start`)) FROM `project`; 

#######################################################################################################################################

#Выведите все позиций списка товаров принадлежащие какой-либо категории с названиями товаров и названиями категорий. Список должен
# быть отсортирован по названию товара, названию категории. Для соединения таблиц необходимо использовать оператор INNER JOIN.

SELECT `good`.`name` AS `good_name`,`category`.`name` AS `category_name` FROM `category_has_good`
    INNER JOIN `category` ON `category_has_good`.`category_id`=`category`.`id`
    INNER JOIN `good` ON `category_has_good`.`good_id`=`good`.`id`
    ORDER BY `good`.`name`, `category`.`name`;

#######################################################################################################################################

#Выведите список клиентов (имя, фамилия) и количество заказов данных клиентов, имеющих статус "new".

SELECT client.first_name, client.last_name, count(1) AS new_sale_num FROM client
	INNER JOIN sale ON client.id = sale.client_id
    INNER JOIN status ON sale.status_id = status.id WHERE status.name = "new"
    GROUP BY client.first_name, client.last_name; 

#######################################################################################################################################

#Выведите список товаров с названиями товаров и названиями категорий, в том числе товаров, не принадлежащих ни одной из категорий.

SELECT good.name AS good_name, category.name AS category_name FROM good
    LEFT OUTER JOIN category_has_good ON good.id=category_has_good.good_id 
    LEFT OUTER JOIN category ON category.id=category_has_good.category_id;

#######################################################################################################################################

#Выведите список товаров с названиями категорий, в том числе товаров, не принадлежащих ни к одной из категорий, в том числе 
#категорий не содержащих ни одного товара.

SELECT good.name AS good_name, category.name AS category_name FROM good
    LEFT OUTER JOIN category_has_good ON good.id=category_has_good.good_id 
    LEFT OUTER JOIN category ON category.id=category_has_good.category_id
UNION
SELECT good.name AS good_name, category.name AS category_name FROM good
    RIGHT OUTER JOIN category_has_good ON good.id=category_has_good.good_id 
    RIGHT OUTER JOIN category ON category.id=category_has_good.category_id;

#######################################################################################################################################

#Выведите список всех источников клиентов и суммарный объем заказов по каждому источнику. Результат должен включать также записи для
#источников, по которым не было заказов.

SELECT source.name AS source_name, SUM(sale.sale_sum) AS sale_sum FROM source
    LEFT OUTER JOIN client ON source.id=client.source_id 
    LEFT OUTER JOIN sale ON sale.client_id=client.id
    GROUP BY source.name; 

#######################################################################################################################################

#Выведите названия товаров, которые относятся к категории 'Cakes' или фигурируют в заказах текущий статус которых 'delivering'.
#Результат не должен содержать одинаковых записей. В запросе необходимо использовать оператор UNION для объединения выборок
#по разным условиям.

SELECT good.name AS good_name FROM good
    INNER JOIN category_has_good ON good.id=category_has_good.good_id
    INNER JOIN category ON category.id=category_has_good.category_id
    WHERE category.name='Cakes'
UNION
SELECT good.name AS good_name FROM good
    INNER JOIN sale_has_good ON good.id=sale_has_good.good_id
    INNER JOIN sale ON sale.id=sale_has_good.sale_id
    INNER JOIN status ON status.id = sale.status_id
    WHERE status.name='delivering';

#######################################################################################################################################

#Выведите список всех категорий продуктов и количество продаж товаров, относящихся к данной категории. Под количеством продаж товаров
#подразумевается суммарное количество единиц товара данной категории, фигурирующих в заказах с любым статусом.

SELECT category.name AS name, COUNT(sale.sale_sum) AS sale_num FROM category 
    LEFT OUTER JOIN category_has_good ON category.id = category_has_good.category_id
    LEFT OUTER JOIN good ON category_has_good.good_id = good.id
    LEFT OUTER JOIN sale_has_good ON good.id = sale_has_good.good_id
    LEFT OUTER JOIN sale ON sale_has_good.sale_id = sale.id
    GROUP BY category.name;

#######################################################################################################################################

#Выведите список источников, из которых не было клиентов, либо клиенты пришедшие из которых не совершали заказов или
#отказывались от заказов. Под клиентами, которые отказывались от заказов, необходимо понимать клиентов, у которых есть заказы,
#которые на момент выполнения запроса находятся в состоянии 'rejected'. В запросе необходимо использовать
#оператор UNION для объединения выборок по разным условиям.

SELECT source.name AS source_name FROM source
    WHERE NOT EXISTS(SELECT * FROM client WHERE source.id=client.source_id)
UNION
SELECT source.name AS source_name FROM source
    INNER JOIN client ON source.id=client.source_id
    INNER JOIN sale ON sale.client_id=client.id
    INNER JOIN status ON status.id=sale.status_id
    WHERE status.name='rejected';
    
#######################################################################################################################################