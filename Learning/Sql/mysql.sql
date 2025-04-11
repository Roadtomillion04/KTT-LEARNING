USE my_db;

CREATE TABLE Games (
		game_id INT PRIMARY KEY AUTO_INCREMENT,
		game_title VARCHAR(30) NOT NULL,
		game_activation_key CHAR(5),
  	game_publish_date DATE NOT NULL,
  	game_offline_support BOOLEAN NOT NULL DEFAULT TRUE

);

CREATE TABLE Players (
		player_id INT PRIMARY KEY AUTO_INCREMENT,
		player_name VARCHAR(30) NOT NULL,
		player_age CHAR(2),
  	player_join_date DATE NOT NULL,
  	player_purchases BOOLEAN NOT NULL DEFAULT FALSE

);


INSERT INTO Games(game_title, game_activation_key, game_publish_date, game_offline_support) 
VALUES ("GI", "10001", "2020-08-21", TRUE);
INSERT INTO Games(game_title, game_activation_key, game_publish_date, game_offline_support)
VALUES ("HSR", "10002", "2023-04-27", FALSE);
INSERT INTO Games(game_title, game_activation_key, game_publish_date, game_offline_support) 
VALUES ("ZZZ", "10003", "2024-06-04", TRUE);
INSERT INTO Games(game_title, game_activation_key, game_publish_date) 
VALUES ("F2M", "10004", "2010-05-01");


INSERT INTO Players(player_name, player_age, player_join_date, player_purchases) 
VALUES ("Aether", "19", "2021-08-21", TRUE);
INSERT INTO Players(player_name, player_age, player_join_date, player_purchases)
VALUES ("Stelle", "21", "2022-04-27", FALSE);
INSERT INTO Players(player_name, player_age, player_join_date, player_purchases) 
VALUES ("Wise", "24", "2025-03-04", TRUE);
INSERT INTO Players(player_name, player_age, player_join_date) 
VALUES ("Kiana", "20", "2010-05-01");


SELECT * FROM Games;

SELECT game_title FROM Games
WHERE game_offline_support = TRUE;

SELECT * FROM Players;

SELECT player_name FROM Players
WHERE player_age > 20;


SELECT * FROM Games
INNER JOIN Players WHERE game_id = player_id;

SELECT * FROM Games
LEFT JOIN Players AS left_join 
ON game_offline_support = 1;

SELECT * FROM Games
LEFT JOIN Players AS right_join 
ON player_purchases = 0;

SELECT * FROM Games
FULL JOIN Players AS full_join 
ON game_id = player_id;

