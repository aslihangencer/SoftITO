
CREATE TABLE users( 
    id INTEGER PRIMARY KEY, 
    name TEXT NOT NULL, 
    surname TEXT NOT NULL, 
    age INTEGER NOT NULL, 
    city TEXT NOT NULL, 
    email TEXT UNIQUE NOT NULL, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
); 
/* 
Öncelikle users tablosu yoksa oluşturmak için CREATE TABLE komutunu kullandım. id alanını PRIMARY KEY yaptım.  
name, surname, city ve email string ifade oldukları için TEXT, age tam sayı olduğu için INTEGER kullandım.  
E-postaların birbirinden farklı olması için UNIQUE, gerekli bilgilerin boş bırakılmaması için NOT NULL kullandım. 
 DATETIME sayesinde de kullanıcının ne zaman kayıt olduğunu görebiliyoruz. 
*/ 
 
INSERT INTO users (name, surname, age, city, email) 
VALUES 
('Ayşe', 'Engin', 12, 'ADANA', 'ayşe.01@gmail.com'), 
('Yusuf', 'Yusuf', 25, 'BOLU', 'yyusuf@gmail.com'), 
('Canan', 'Yılmaz', 45, 'İSTANBUL', 'yılmaz_canan@gmail.com'); 
-- Kullanıcı bilgilerini girdim. 
 
SELECT * FROM users; 
/* 
id,name,surname,age,city,email,created_at 
1,Ayşe,Engin,12,ADANA,ayşe.01@gmail.com,2026-09-16 20:06:48 
2,Yusuf,Yusuf,25,BOLU,yyusuf@gmail.com,2026-09-16 20:06:48 
3,Canan,Yılmaz,45,İSTANBUL,yılmaz_canan@gmail.com,2026-09-16 20:06:48 
*/ 
 
UPDATE users SET email='ayşeengin.01@gmail.com' WHERE id=1; 
--Ayşe'nin id numarası üzerinden email adresini güncelledim. 
 
DELETE FROM users WHERE id=2; 
-- id numarası 2 olan Yusuf Yusuf kullanıcısı tablodan silindi. 
 
-- INNER JOIN ile users tablosu ile order tablosunu birleştirip, kullanıcıların siparişlerini listeledim. 
CREATE TABLE orders ( 
    order_id INTEGER PRIMARY KEY , 
    user_id INTEGER NOT NULL, 
    package_name TEXT NOT NULL, 
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_id) REFERENCES users(id) 
); 
--Orders tablosunu oluşturdum. order_id alanını PRIMARY KEY yaptım. user_id alanı users tablosundaki id alanına referans olacak şekilde FOREIGN KEY olarak tanımladım. 
INSERT INTO orders (user_id, package_name) 
VALUES 
(1, 'Öğrenci Paketi'), 
(1, 'Bireysel Paket'), 
(3, 'Aile Paketi'); 
 
SELECT  
    users.name, 
    users.email, 
    orders.order_id 
FROM users 
INNER JOIN orders 
    ON users.id = orders.user_id; 
    -- -- INNER JOIN sayesinde users ve orders tablolarını user_id üzerinden birleştirerek kullanıcı adı, email ve sipariş numarasını listeledim.