 CREATE TABLE tab_category(
	cid INT PRIMARY KEY AUTO_INCREMENT,
	cnmae VARCHAR(100) NOT NULL UNIQUE
 );
 CREATE TABLE tab_route(
	rid INT PRIMARY KEY AUTO_INCREMENT,
	rname VARCHAR(10) NOT NULL UNIQUE,
	price DOUBLE,
	cid INT,
	FOREIGN KEY (cid) REFERENCES tab_category(cid) -- 外键名称省略，自动分配
 );
 CREATE TABLE tab_user(
	uid INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(100) UNIQUE NOT NULL,
	`password` VARCHAR(30) NOT NULL,
	`name` VARCHAR(100),
	birthday DATE,
	sex CHAR(1) DEFAULT '男',
	telephone VARCHAR(11),
	email VARCHAR(100)
 );
 CREATE TABLE tab_favorite(
	rid INT,
	`date` DATETIME,
	uid INT,
	PRIMARY KEY(rid,uid),
	FOREIGN KEY(rid) REFERENCES tab_route(rid),
	FOREIGN KEY(uid) REFERENCES tab_user(uid)
 );