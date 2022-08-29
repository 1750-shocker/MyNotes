## DML操作表数据

增删改

增：

```sql
insert into tb1(id,age,name)values(1,21,freddy);
insert into tb1 values(所有值); -- 除了数字，其他都要用单引号括起来
```

DQL:查询表中内容：select * from tb1;

删：

```sql
delete from tb1 [where 条件]; -- 不加条件=一句一句全删
truncate table  tb1; -- 删除表再创建一个空的出来
```

改：

```sql
update tb1 set id=1, age=21 [where id=2]; -- 不加条件，修改所有
```
