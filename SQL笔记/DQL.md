## DQL 查询语句

语法：

select 字段列表

from 表名列表

where 条件列表

group by 分组字段

having 分组之后的条件

order by 排序

limit 分页限定

### 基础查询

```sql
select * from student;
select name,age from student;
select distinct address from student; -- 去除重复结果集
select name,math,english,math+english from student; 
-- 计算和，当加数有一个为null时，结果为null
select name,math,english,math+ifnull(english, 0) from student; 
-- 当english值为null时用0替代
select name,math,english,math+ifnull(english, 0) as 总分 from student; 
-- 起别名,可以把as替换成一个空格，适用于任何列名之后
```

### 条件查询

```sql
SELECT * FROM student WHERE chinese = 89;
SELECT * FROM student WHERE chinese>=60 AND chinese <=80;
SELECT * FROM student WHERE chinese BETWEEN 50 AND 60;
SELECT * FROM student WHERE chinese=55 OR chinese = 75 OR english=98;
SELECT * FROM student WHERE chinese IN (55, 75) OR english=98;
SELECT * FROM student WHERE math IS NULL;
SELECT * FROM student WHERE math IS NOT NULL;

-- LIKE 模糊查询 _下划线占1位，%占任意位
SELECT * FROM student WHERE NAME LIKE '赵%';
SELECT * FROM student WHERE NAME LIKE '_平_';
```

### 排序查询

```sql
SELECT * FROM student ORDER BY math; -- 默认升序
SELECT * FROM student ORDER BY math ASC;
SELECT * FROM student ORDER BY math DESC;
-- 按照数学降序，成绩一样的按照英语降序排。第二条件只在第一条件相同时才应用
SELECT * FROM student ORDER BY math DESC, english DESC;
```

### 聚合函数

将一列数据作为一个整体，进行纵向计算（传入列名）

count：计算个数

max：计算最大值

min：计算最小值

sum：计算和

avg：计算平均值

```sql
SELECT COUNT(math) FROM student; -- 聚合函数排除null值，一般选择非空列运算
SELECT COUNT(IFNULL(math,0)) FROM student;
SELECT MAX(chinese) FROM student;
SELECT MIN(chinese) FROM student;
```

### 分组查询

```sql
SELECT gender, AVG(math),COUNT(id) FROM student GROUP BY gender;
-- select后面的字段都将作为结果中的一列数据
-- 使用group by指定字段，所有该字段值相同的行分为一组
-- 没有分组时所有行为一组，所以使用聚合函数的结果只有一列一行，分两组的结果是一列两行
-- select后面加分组的字段或者聚合函数
SELECT gender, AVG(math),COUNT(id) FROM student WHERE math>70 GROUP BY gender;
-- where筛选哪些字段参与分组，不可以用聚合函数
SELECT gender, AVG(math),COUNT(id) FROM student WHERE math>=70 GROUP BY gender HAVING COUNT(id)>2;
SELECT gender, AVG(math),COUNT(id) AS 人数 FROM student WHERE math>=70 GROUP BY gender HAVING 人数>2;
-- having：分组之后的条件，不符合不出现，可以用聚合函数
```

### 分页查询

```sql
SELECT * FROM student LIMIT 0,3;-- 0是索引开始，3是每页显示3条
-- 开始索引=（页码-1）*每页条数
```
