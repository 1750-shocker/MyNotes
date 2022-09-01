# SQL分类

1. DDL(data definition language)数据定义语言

   用于定义数据库对象，表，列

2. DML(data manipulation language)数据操作语言

   用于对表中的数据增删改

3. DQL(data query language)数据查询语言

   用于查询表中的数据

4. DCL(data control language)数据控制语言

   用于定义数据库的访问权限和安全级别，创建用户

## DDL

### 操作库

#### 创建create

```sql
CREATE DATABASE db1;
CREATE DATABASE IF NOT EXISTS db1; -- 如果不存在该数据库
CREATE DATABASE db1 CHARACTER SET gbk; -- 指定字符集
CREATE DATABASE IF NOT EXISTS db1 CHARACTER SET utf8; 
```

#### 查询retrieve

```sql
SHOW DATABASES; -- 查询所有数据库的名称
SHOW CREATE DATABASE db1; -- 查询指定的数据库的创建语句(可以看到数据库字符集)
```

#### 修改update

```sql
ALTER DATABASE db1 CHARACTER SET utf8; -- 修改数据库字符集
```

#### 删除delete

```sql
DROP DATABASE db1;
DROP DATABASE IF EXISTS db3;
```

#### 使用

```sql
SELECT DATABASE(); -- 查看当前使用数据库，括号是一部分
USE db1;
```

### 操作表

#### 创建create

```sql
CREATE TABLE tb1(
    id int,
    name varchar(20),
    age int,
    score double(5,2), -- 5=一共多少位，2=小数点后位数
    birthday date,
    insert_time timestamp
   );
CREATE TABLE tb2 LIKE tb1; -- 复制一份
```

#### 查询retrieve

```sql
SHOW TABLES; -- 查询一个数据库中的所有表
SHOW CREATE TABLE tb1; -- 查看表创建语句，包括字符集等
DESC tb1; -- 查询表结构
```

#### 修改update

```sql
ALTER TABLE tb1 RENAME TO tbone; -- 改名
ALTER TABLE tb1 CHARACTER SET utf8; -- 修改表字符集
ALTER TABLE tb1 ADD gender varchar(10); -- 添加列
ALTER TABLE tb1 CHANGE gender sex varchar(20); -- 修改列，名字和类型 
ALTER TABLE tb1 MODIFY gender int [not null]; -- 修改列，类型
ALTER TABLE tb1 DROP gender; -- 删除列
```

#### 删除delete

```sql
DROP TABLE tb1;
DROP TABLE IF EXISTS tb1;
```

## DML

### 增

```sql
INSERT INTO tb1(id,age,name) VALUES(1,21,`freddy`); -- 除了数字，其他都要用单引号括起来
INSERT INTO tb1 VALUES(所有值); -- 省略字段指定，则必须将所有字段给值
```

DQL:查询表中内容：select * from tb1;

### 删

```sql
DELETE FROM tb1 [WHERE id=1]; -- 不加条件则一句一句全删
TRUNCATE TABLE tb1; -- 删除表再创建一个空的出来相当于删除所有记录而不一句一句执行
```

### 改

```sql
UPDATE tb1 SET id=1, age=21 [WHERE id=2]; -- 不加条件，修改所有
```

## DQL 查询语句

语法：

```
SELECT 
	字段列表
FROM
	表名列表
WHERE
	条件列表
GROUP BY
	分组字段
HAVING
	分组之后的条件
ORDER BY
	排序
LIMIT
	分页限定
```

### 基础查询

```sql
SELECT * FROM student;
SELECT name,age FROM student;
SELECT DISTINCT address FROM student; -- 去除重复结果，比如结果是合肥，重庆，合肥，芜湖，南京，操作后只有合肥，重庆，芜湖，南京
SELECT name,math,english,math + english FROM student; -- 计算和，当加数有一个为null时，结果为null
SELECT name,math,english,math + IFNULL(english, 0) FROM student; -- 当english值为null时用0替代
SELECT name,math,english,math + IFNULL(english, 0) AS 总分 FROM student; -- 起别名,可以把as替换成一个空格，适用于任何列名之后，结果中该列列名用别名显示
```

### 条件查询

```sql
SELECT * FROM student WHERE chinese = 89;
SELECT * FROM student WHERE chinese != 89;
SELECT * FROM student WHERE chinese>=60 AND chinese <=80;
SELECT * FROM student WHERE chinese BETWEEN 60 AND 80;
SELECT * FROM student WHERE chinese=55 OR chinese = 75 OR english=98;
SELECT * FROM student WHERE chinese IN (55, 75, 22) OR english=98; -- 括号里写符合条件的值
SELECT * FROM student WHERE math IS NULL;
SELECT * FROM student WHERE math IS NOT NULL;

-- LIKE 模糊查询 _下划线占1位，%占任意位
SELECT * FROM student WHERE NAME LIKE '赵%'; -- 百分号表示任意多个字符
SELECT * FROM student WHERE NAME LIKE '_平_'; -- 下划线表示任意单个字符
```

### 排序查询

```sql
SELECT * FROM student ORDER BY math; -- 默认升序
SELECT * FROM student ORDER BY math ASC;
SELECT * FROM student ORDER BY math DESC; -- 按照数学降序
SELECT * FROM student ORDER BY math DESC, english DESC; -- 成绩一样的按照英语降序排。第二条件只在第一条件相同时才应用
```

### 聚合函数

统计某一列数据，例如最高分选总分计算，数学的平均分选数学分计算

count：计算几行（选的那列不应该有空）

max：计算最大值

min：计算最小值

sum：计算和

avg：计算平均值

```sql
SELECT COUNT(math) FROM student; -- 聚合函数不计算null值，如果8行数据有一个有null，结果得7，一般选择非空列运算，可以写*号，count(*)，这样一定能统计出总共几行
SELECT MIN(IFNULL(math,0)) FROM student; -- 聚合函数忽略null
SELECT MAX(chinese) FROM student;
SELECT MIN(chinese) FROM student;
```

### 分组查询

聚合函数默认将==一整列==数据拿来算，分组会将该列按照另一个字段（性别）的不同值（男，女）来分成对应的不同组（男生一列，女生一列)，再分别对这些组聚合计算

**使用**`GROUP BY`**时，查询的字段只能为分组字段和聚合函数，其他无意义**

![分组查询](assets/01.png)

```sql
SELECT gender, AVG(math), COUNT(id) FROM student GROUP BY gender;
SELECT gender, AVG(math), COUNT(id) FROM student WHERE math>70 GROUP BY gender; -- where筛选哪些字段参与分组，表达式不可以是聚合
SELECT gender, AVG(math), COUNT(id) FROM student WHERE math>=70 GROUP BY gender HAVING COUNT(id)>2; -- having在分组结束之后过滤，如果数量不到2则不出现
SELECT gender, AVG(math), COUNT(id) AS 人数 FROM student WHERE math>=70 GROUP BY gender HAVING 人数>2; -- AS起别名，表达式可以写聚合
```

因为where在分组前执行聚合还没到执行的时候，所以不可以聚合，having在分组结束后执行，可以用聚合

### 分页查询

limit是mysql专用的

```sql
SELECT * FROM student LIMIT 0,3; -- 0是索引开始，3是每页显示3条
SELECT * FROM student LIMIT 0,3; -- 每页显示3条数据，查询第1页数据
SELECT * FROM student LIMIT 3,3; -- 每页显示3条数据，查询第2页数据
SELECT * FROM student LIMIT 6,3; -- 每页显示3条数据，查询第3页数据
-- 开始索引=（页码-1）*每页条数
```
