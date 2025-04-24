--Name: Iok Weng Chan
--Student ID: 10453571

--Insert the initial state of the game into the database created by 'create.sql'

INSERT INTO Location VALUES
(0, 'Go'),(1, 'Kilburn'),(2, 'Chance 1'),(3, 'Uni Place'),(4, 'Jail'),(5, 'Victoria'),(6, 'Community Chest 1'),
(7, 'Piccadilly'),(8, 'Free Parking'),(9, 'Oak House'),(10, 'Chance 2'),(11, 'Owens Park'),(12, 'Go To Jail'),
(13, 'AMBS'),(14, 'Community Chest 2'),(15, 'Co-Op');

INSERT INTO Bonus
VALUES  
(0,'Go', 'Collect £200'), (2,'Chance 1', 'Pay each of the other players £50'),(4,'Jail', 'No action. If a player is under custody then they must roll a 6 enable to continue playing, otherwise skip a round'), 
(6,'Community Chest 1', 'For winning a Beauty Contest, you win £100'), (8,'Free Parking', 'No action'), 
(10,'Chance 2', 'Move forward 3 spaces'), (12,'Go To Jail', 'Go to Jail, do not pass GO, do not collect £200'),(14,'Community Chest 2', 'Your library books are overdue. Pay a fine of £30');

INSERT INTO Player(Name, Token, LocationID, `Balance (£)`)
VALUES 
('Mary', 'Battleship', '8', 190),
('Bill', 'Dog', 11, 500),
('Jane', 'Car', 13, 150),
('Norman', 'Thimble', 1, 250);

INSERT INTO Player(Token)
VALUES ('Top hat'), ('Boot');


INSERT INTO Properties
VALUES  (1,'Kilburn', 120, 'Yellow', NULL), (3,'Uni Place', 100, 'Yellow', 'Battleship'), (5,'Victoria', 75, 'Green', 'Dog'), (7,'Piccadilly', 35, 'Green', NULL), 
(9,'Oak House', 100, 'Orange', 'Thimble'), (11,'Owens Park', 30, 'Orange', 'Thimble'), (13,'AMBS', 400, 'Blue', NULL), (15,'Co-Op', 30, 'Blue', 'Car');
