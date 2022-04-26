### 操作流程
##### 1. 建立omeka-s network
```
docker network create omeka-network
```
##### 2. 建立mysql container
```
docker run --name omeka-mysql -d -e MYSQL_ROOT_PASSWORD=my-secret-pw --net omeka-network mysql:8.0.28-oracle
```
```sql
mysql -u root -p
CREATE DATABASE `omeka_db`;
CREATE USER 'omeka-user'@'%' IDENTIFIED BY 'omeka-pw';
GRANT ALL PRIVILEGES ON omeka_db.* TO 'omeka-user'@'%';
FLUSH PRIVILEGES;
```

##### 3. 下載omeka-s.zip安裝檔，並打包自己寫的dockerfile
```
docker build -t f121476536/omeka-edtsao:v0.1 .
docker run --name omeka-edtsao -d -p 8007:80 --link omeka-mysql:omeka-mysql --net omeka-network f121476536/omeka-edtsao:v0.1
```

##### 4. host透過瀏覽器登入
> apache把/var/www/html設定為預設目錄，因此需要透過瀏覽器開啟 http://localhost:8007/omeka-s 即可。

##### 相關debug指令
```
ping omeka-mysql
awk 'END{print $1}' /etc/hosts
sed -i 's#skip-name-resolve#\# skip-name-resolve#g' /etc/my.cnf
sed -i 's#\# skip-name-resolve#skip-name-resolve#g' /etc/my.cnf
Warning | 1285 | MySQL is started in --skip-name-resolve mode; you must restart it without this switch for this grant to work
SELECT User,Host FROM mysql.user;
```