## DDL定义，操作数据库、表，CRUD

### 操作库

C=create创建

```sql
create database db1;
create database if not exists db1;
create database db1 character set gbk;
create database if not exists db1 character set utf8;
```

R=retrieve查询

```sql
show databases; -- 查询所有数据库的名称
show create database db1; -- 查询指定的数据库的创建语句
```

U=update修改

```sql
alter database db1 character set utf8;
```

D=delete删除

```sql
drop database db1;
drop database if exists db3;
```

使用数据库

```sql
use db1;
select database(); -- 查看当前使用数据库
```

### 操作表

C=create创建

```sql
create table tb1(
    id int,
    name varchar(20),
    age int,
    score double(5,2), -- 5=一共多少位，2=小数点后位数
    birthday date,
    insert_time timestamp
   );
create table tb2 like tb1;
```

R=retrieve查询

```sql
show tables; -- 查询一个数据库中的所有表
desc tb1; -- 查询表结构
```

U=update修改

```sql
alter table tb1 rename to tbone;
show create table tb1;
alter table tb1 character set utf8;
alter table tb1 add gender varchar(10);
alter table tb1 change gender sex varchar(20);
alter table tb1 modify gender int [not null];
alter table tb1 drop gender;
```

D=delete删除

```sql
drop table tb1;
drop table if exists tb1;
```
