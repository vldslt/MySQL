DROP DATABASE IF EXISTS INVEST;
CREATE DATABASE INVEST;
USE INVEST;

/*
 * создаём юзеров, заполняем их информацию
 */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
    firstname VARCHAR(30),
    lastname VARCHAR(30),
    email VARCHAR(100) UNIQUE,
    password_hash varchar(100)
);

/*
 * создаём портфели юзеров с позициями, у одного юзера может быть не один портфель
 */


DROP TABLE IF EXISTS portfel;
CREATE TABLE portfel (
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	owner VARCHAR(40),
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

/*
 * создаём валюты и их курс к основным валютам биржи
 */

DROP TABLE IF EXISTS currensy;
CREATE TABLE currensy (
	name VARCHAR(20) UNIQUE,
	usd DECIMAL(8, 3),
	euro DECIMAL(8, 3),
	rub DECIMAL(8, 3),
	yen DECIMAL(8, 3)
	-- PRIMARY KEY (name, usd, euro, rub, yen)
);

/*
 * создаём таблицу валют юзеров, id ссылается на портфель юзера, name на строку в общей таблице валют что бы определить курс на основные валюты биржи
 */

DROP TABLE IF EXISTS users_currensy;
CREATE TABLE users_currensy (
	id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(30),
	stock BIGINT,
	FOREIGN KEY (id) REFERENCES portfel(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (name) REFERENCES currensy(name) ON UPDATE CASCADE ON DELETE CASCADE
);

/*
 * создаём криптовалюты и их курс к основным криптовалютам биржи
 */

DROP TABLE IF EXISTS krypto;
CREATE TABLE krypto (
	name VARCHAR(30) UNIQUE,
	bitcoin DECIMAL(8, 3),
	xrm DECIMAL(8, 3),
	nem DECIMAL(8, 3),
	iota DECIMAL(8, 3)
	-- PRIMARY KEY (name, bitcoin, xrm, nem, iota)
);

/*
 * создаём таблицу криптовалют юзеров, id ссылается на портфель в котором они находятся, name на строку в общей таблице криптовалют что бы определить курс на основные криптовалюты биржи
 */

DROP TABLE IF EXISTS users_krypto;
CREATE TABLE users_krypto (
	id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(30),
	stock BIGINT,
	FOREIGN KEY (id) REFERENCES portfel(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (name) REFERENCES krypto(name) ON UPDATE CASCADE ON DELETE CASCADE
);

/*
 * создаём фонды. название фонда, общая стоимость, стоимость единицы - в порфелях юзеров и будут находится эти 'единицы'
 */

DROP TABLE IF EXISTS fond;
CREATE TABLE fond (
	name VARCHAR(40) PRIMARY KEY,
	total_price BIGINT,
	price1 DECIMAL(5,2)
);

/*
 * создаём таблицу с полным составом фондов
 * название фонда, и количество основных валют и криптовалют в составе фонда
 */

DROP TABLE IF EXISTS fond_in;
CREATE TABLE fond_in (
	name VARCHAR(40),
	usd BIGINT,
	euro BIGINT,
	rub BIGINT,
	yen BIGINT,
	bitcoin BIGINT,
	xrm BIGINT,
	nem BIGINT,
	iota BIGINT,
	-- PRIMARY KEY (name, usd, euro, rub, yen, bitcoin, xrm, nem, iota)
	FOREIGN KEY (name) REFERENCES fond(name) ON UPDATE CASCADE ON DELETE CASCADE
);

/*
 * создаём таблицу фондов в портфелях юзеров
 * id ссылается на портфель юзера
 * название фонда
 * количество единиц одного фонда в порфеле юзера
 */

DROP TABLE IF EXISTS users_fond;
CREATE TABLE users_fond (
	id BIGINT UNSIGNED NOT NULL,
	name_of_fond VARCHAR(20),
	stock BIGINT,
	FOREIGN KEY (id) REFERENCES portfel(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (name_of_fond) REFERENCES fond(name) ON UPDATE CASCADE ON DELETE CASCADE
);

/*
 * заполняем курс валют и криптовалют (соотношение столбца к строке)
 */

INSERT INTO currensy 
VALUES 
	('usd', 1, 1.2, 0.013, 0.0092),
	('euro', 0.83, 1, 0.011, 0.0077),
	('rub', 90.75, 75.74, 1, 0.7),
	('yen', 108.7, 130.34, 1.44, 1);

INSERT INTO krypto
VALUES 
	('bitcoin', 1, 0.265, 0.071, 2.2),
	('xrm', 3.78, 1, 0.26, 8.4),
	('nem', 14.085, 3.72, 1, 31.3),
	('iota', 0.45, 0.11, 0.032, 1);

/*
 *	заполняем юзеров и портфели
 */

INSERT users (firstname,lastname,email,password_hash) 
VALUES
	('Petya', 'Petrov', 'pp@p.p', 'eb392fbbf17f46d9905759f780f7a27823e00268'),
	('Jayde','Haag','hipolito81@example.org','eb392fbbf17f46d9905759f780f5a26423e00268'),
	('Melisa','Jaskolski','berg@example.com','194610ccbd560dc7a684619e9da4878b6773e043'),
	('Gerson','McGlynn','bette.sawayn@example.org','c39394ea1e064a18ab30c43021aa2c5b2c6ddcf2'),
	('Brandy','Volkman','jane97@example.net','66f21e872a21be7d8c1807e1ae069d95f7d479ea'),
	('Manuela','Waters','ygoyette@example.org','1e200f98f595269a11ef491d5fbb523cb8278172'),
	('Neoma','Crooks','crona.tyra@example.com','39d9a3161a8ffda36500f2a5bc10971de98c6041'),
	('Belle','Mosciski','nkreiger@example.net','0acaad89d04e24d5a43a8865dc9eb38a6f43b9d4'),
	('Denis','Goldner','kaya.harris@example.net','da3d2f1e0bc01edefdc1bac31c7c2710499940de'),
	('Jerad','Conroy','bernhard.ova@example.org','f40c283b301a41f71d1883ef1bec8af90d7dc17f'),
	('Raheem','Streich','jairo04@example.com','435c95c4157dce374b406c35b474237203a60a0d');

INSERT INTO portfel (user_id,owner)
VALUES 
	(1,'Margarett Koch II'),
	(2,'Mr. Branson Shields'),
	(2,'Mr.BS'),
	(3,'Lottie Schaden'),
	(4,'Dr. Wayne King'),
	(5,'Raegan Mertz'),
	(6,'Dr. Jarrett Orn'),
	(7,'Ibrahim Reichel IV'),
	(8,'Lea Little'),
	(8,'Jordon Lakin'),
	(10,'Ciara Harvey'),
	(10,'CiHar'),
	(10,'Ci'),
	(11,'Kari Waters');

/*
 * заполняем таблицы валюты и криптовалюты юзеров
 */

INSERT INTO users_currensy -- (id,name,stock)
VALUES 
	(1,'usd',333),
	(2,'rub',1000000),
	(3,'yen',120000),
	(3,'euro',1200),
	(11,'usd',487334),
	(8,'euro',474334),
	(6,'usd',57264),
	(4,'euro',613022),
	(8,'euro',660170),
	(3,'usd',839960),
	(1,'rub',562940),
	(6,'euro',367441),
	(2,'yen',867567),
	(9,'yen',847845),
	(9,'usd',817180),
	(5,'usd',445358),
	(11,'yen',369187),
	(8,'yen',978650),
	(9,'rub',752329),
	(7,'euro',636872),
	(10,'usd',425893),
	(9,'euro',487463),
	(3,'rub',916169),
	(2,'euro',534433),
	(7,'yen',706138),
	(5,'yen',702760),
	(7,'rub',335156),
	(9,'yen',296150),
	(11,'euro',887684),
	(10,'yen',447417),
	(7,'rub',951477),
	(9,'euro',467173);

INSERT INTO users_krypto -- (id,name,stock)
VALUES
	(10,'bitcoin',536),
	(2,'xrm',17391),
	(12,'bitcoin',7925),
	(10,'nem',14685),
	(11,'nem',10261),
	(6,'nem',37127),
	(12,'xrm',18925),
	(5,'iota',43877),
	(5,'xrm',32219),
	(11,'iota',36671),
	(2,'bitcoin',20575),
	(11,'xrm',3405),
	(12,'nem',22382),
	(1,'iota',5041),
	(13,'xrm',39464),
	(6,'iota',20512),
	(12,'xrm',18966),
	(2,'nem',25152),
	(7,'nem',11443),
	(14,'iota',17741),
	(4,'bitcoin',845),
	(10,'iota',22277),
	(14,'nem',33321),
	(10,'nem',26069),
	(10,'nem',24998),
	(5,'nem',37689),
	(1,'xrm',36534),
	(1,'iota',40704);
	
/*
 * заполняем фонды
 */

INSERT INTO fond
VALUES
	('golddragon',10000000000,100),
	('diamond',100000000000,30),
	('pxb',999999999999,0.1),
	('spac',900000000,10),
	('tesla',1000000000000,2.5),
	('kvaken',90000000000,150);


INSERT INTO fond_in
VALUES
	('golddragon',1000000,0,0,0,0,0,0,0),
	('diamond',0,0,0,1000,564165341,654165,6536532,30),
	('pxb',99999,6,6541,897465,4512,45,0,0),
	('spac',63,500000,546654,654654,566,0,0,10),
	('tesla',0,0,0,0,0,0,1000000,2000000000),
	('kvaken',0,0,0,90000000,150,0,0,0); 

INSERT INTO users_fond
VALUES 
	(12,'tesla',651),
	(1,'diamond',38),
	(12,'golddragon',333),
	(10,'tesla',844),
	(12,'diamond',900),
	(2,'pxb',442),
	(13,'spac',115),
	(8,'kvaken',860),
	(13,'kvaken',751),
	(1,'pxb',115),
	(14,'diamond',387),
	(14,'spac',277),
	(9,'kvaken',420),
	(6,'pxb',635),
	(1,'kvaken',476),
	(9,'pxb',936),
	(10,'spac',563),
	(6,'golddragon',125),
	(8,'diamond',240),
	(2,'tesla',328),
	(5,'kvaken',28),
	(1,'spac',894),
	(8,'pxb',315),
	(9,'tesla',302),
	(7,'spac',369),
	(4,'diamond',276);
