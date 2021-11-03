/*
* скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы)
*/
-- посмотрим порфели, какой портфель кому принадлежит
/*
USE INVEST;
SELECT * FROM portfel p
LEFT JOIN users u
ON p.user_id = u.id 
*/
-- посмотрим id портфелей владеющих фондов в состав которых входят рубли,начиная с наименьшего количества
/*
USE INVEST;

SELECT id,stock,name_of_fond FROM users_fond uf 
WHERE name_of_fond in (SELECT name FROM fond_in fi WHERE rub > 0)
ORDER BY stock;
*/
-- SELECT name FROM fond_in fi WHERE rub > 0 -- фонды с рублями 
/*
 * представления 
 */
-- сделаем представление валютной составляющей фондов
/*USE INVEST;
DROP VIEW fcurr;

CREATE VIEW fcurr AS
SELECT name,usd,euro,rub,yen
FROM fond_in;
-- выберем из представления те фонды, где больше 10к долларов и меньше 10к рублей
SELECT * FROM fcurr WHERE usd > 10000 AND rub < 10000
*/
-- создадим представление таблицы всех валют и криповалют пользователей 
/*
USE INVEST;

CREATE VIEW coins AS
SELECT * FROM users_krypto uk
UNION
SELECT * FROM users_currensy uc;
-- узнаем какими монетами владеет указанный пользователь 
SELECT name,stock FROM coins WHERE id = 5;
*/

/*
 * хранимые процедуры / триггеры
 */

