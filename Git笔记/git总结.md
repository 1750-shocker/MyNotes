#### 创建仓库关联本地项目（第一行代码）
1. github建仓库，这会包含一个README文件和gitignore文件

2. 本地项目文件夹git init

3. git clone https://github.com/xxx down下来是一个目录

4. 把目录里的文件拖出来放在项目的一级目录里，删掉空目录

5. 执行一下命令实现初始化

   ```git
   git add .
   git commit -m "First commit"
   git remote add origin(地址别名) https://gitxxxx
   git push origin master(分支名)
   ```