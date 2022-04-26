<> 操作流程
0. docker network create omeka-network

1. docker run --name omeka-mysql -d -e MYSQL_ROOT_PASSWORD=my-secret-pw --net omeka-network mysql:8.0.28-oracle
1.1 先用root權限登入，並輸入密碼my-secret-pw
mysql -u root -p
CREATE DATABASE `omeka_db`;
CREATE USER 'omeka-user'@'%' IDENTIFIED BY 'omeka-pw';
GRANT ALL PRIVILEGES ON omeka_db.* TO 'omeka-user'@'%';
FLUSH PRIVILEGES;

2. 下載好omeka-s.zip，並打包自己寫的dockerfile
docker build -t f121476536/omeka-edtsao:v0.1 .
docker run --name omeka-edtsao -d -p 8007:80 --link omeka-mysql:omeka-mysql --net omeka-network f121476536/omeka-edtsao:v0.1

3. host登入
apache把/var/www/html設定為預設目錄，因此需要透過瀏覽器開啟 http://localhost:8007/omeka-s 即可
#ping omeka-mysql
#awk 'END{print $1}' /etc/hosts

<!-- sed -i 's#skip-name-resolve#\# skip-name-resolve#g' /etc/my.cnf
sed -i 's#\# skip-name-resolve#skip-name-resolve#g' /etc/my.cnf
#Warning | 1285 | MySQL is started in --skip-name-resolve mode; you must restart it without this switch for this grant to work
#SELECT User,Host FROM mysql.user; -->