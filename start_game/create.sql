--Name: Iok Weng Chan
--Student ID: 10453571

--Create a database to simulate the 2024 monopolee tournament with respect to the Crows Foot diagram

--Tables:
--The Location table assign each space on the game board to a number in order going
--clockwise from 'Go' with ID 0
CREATE TABLE Location(
	ID INT NOT NULL PRIMARY KEY,
	Name VARCHAR(58) NOT NULL
);

--The Bonus table contains information about the bonuses on the game board 
--each with a description
CREATE TABLE Bonus(
	ID INT NOT NULL,
	Name VARCHAR(58) NOT NULL,
	Description TEXT,
	PRIMARY KEY (ID),
	FOREIGN KEY (ID) REFERENCES Location(ID)
);

--The Player table contains the players' names with their token in use and 
--their status in the game, the tokens that are not used also be in the player table.
CREATE TABLE Player(
	Name VARCHAR(30),
	Token VARCHAR(15) NOT NULL PRIMARY KEY,
	LocationID INT NOT NULL DEFAULT 0,
	`Balance (£)` INT,
	`Under custody` INT DEFAULT 0,  --This attribute is either 0 or 1, 0 being free and 1 being under custody
	`Location Description` TEXT,
	FOREIGN KEY (LocationID) REFERENCES Location(ID)
);


--The Properties table contains information about each property on the game board and their owner
CREATE TABLE Properties(
	ID INT NOT NULL PRIMARY KEY,
	Name VARCHAR(58),
	`Cost (£)` INT DEFAULT 0,
	Colour VARCHAR(24),
	`Owned By` VARCHAR(15),
	FOREIGN KEY (ID) REFERENCES Location(ID),
	FOREIGN KEY (`Owned By`) REFERENCES Player(Token)
);


--The Audit_Trail table is for storing the moves and changes of the players after they made a move with
--their rolls
CREATE TABLE Audit_Trail(
	Token VARCHAR(15) NOT NULL,
	Ending_Location VARCHAR(58) NOT NULL DEFAULT 'Go',
	`Balance (£)` INT,
	`Round No.` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (Token, `Round No.`),
	FOREIGN KEY (Token) REFERENCES Player(Token)
);



--Triggers for a few rules of the monopolee game:
--This trigger activates when we update the player's location whilst they are under custody
CREATE TRIGGER release_from_Jail
AFTER UPDATE of LocationID ON Player
WHEN OLD.`Under custody` = 1
BEGIN
	--Only when a player roll specifically a 6, they can be free
	SELECT CASE
	WHEN NEW.LocationID - OLD.LocationID = 6
		THEN Name
		ELSE (RAISE(ROLLBACK, 'Under custody, skip round with no action'))
	END
	FROM Player WHERE `Under custody` = 1;
	
	UPDATE Player SET LocationID = 4, `Under custody` = 0 WHERE Token = NEW.Token;
END;


--This trigger simulates the situation when a player steps on or passes the 'Go' space
CREATE TRIGGER passing_Go
AFTER UPDATE of LocationID ON Player
WHEN NEW.LocationID > 15
BEGIN
	--Count the number of times the player passes 'Go' and add that many multiples of £200 to the player's balance
	UPDATE Player SET `Balance (£)` = `Balance (£)` + 200*((NEW.LocationID - (NEW.LocationID % 16))/16)  --Passing 'Go' reward
	WHERE LocationID > 15;
	
	--This is needed for the foreign key constraint in the Location table
	UPDATE Player SET LocationID = NEW.LocationID % 16 WHERE LocationID > 15;
END;

--This trigger simulates the situation when a player lands on a property
CREATE TRIGGER land_on_property
AFTER UPDATE of LocationID ON Player
WHEN NEW.LocationID % 2 = 1 AND NEW.LocationID <> OLD.LocationID AND NEW.LocationID < 15
BEGIN
	--Reduce the balance  of the player from the cost of the property
	UPDATE Player 
	SET `Balance (£)` = `Balance (£)` - 
	(SELECT `Cost (£)` FROM Properties WHERE NEW.LocationID % 16 = ID) * 
	--Setting multiplier
	CASE
		--Check whether the owner of the property owns all the properties with the colour of the property with the LocationID of the player landed on 
		WHEN 
		(SELECT COUNT(*) FROM Properties WHERE Colour = (SELECT Colour FROM Properties WHERE NEW.LocationID % 16 = Properties.ID) AND `Owned By` = (SELECT `Owned By` FROM Properties WHERE NEW.LocationID % 16 = ID))
		IS (SELECT COUNT(*) FROM Properties WHERE Colour = (SELECT Colour FROM Properties WHERE NEW.LocationID % 16 = Properties.ID))
			--If yes, set the multiplier to 2
			THEN 2
		--If no, set the multiplier to 1
		ELSE 1
	End
	WHERE Token = NEW.Token;
	
	
	--Pay the owner of the cost of the property, nothing happens when the property is not owned by anyone
	UPDATE Player 
	SET `Balance (£)` = `Balance (£)` + 
	(SELECT `Cost (£)` FROM Properties WHERE NEW.LocationID % 16 = ID) * 
	--Setting multiplier
	CASE
		--Check whether the owner of the property owns all the properties with the colour of the property with the LocationID of the player landed on 
		WHEN 
		(SELECT COUNT(*) FROM Properties WHERE Colour = (SELECT Colour FROM Properties WHERE NEW.LocationID % 16 = Properties.ID) AND `Owned By` = (SELECT `Owned By` FROM Properties WHERE NEW.LocationID % 16 = ID)) 
		IS (SELECT COUNT(*) FROM Properties WHERE Colour = (SELECT Colour FROM Properties WHERE NEW.LocationID % 16 = Properties.ID))
			--If yes, set the multiplier to 2
			THEN 2
		--If no for both cases, set the multiplier to 1
		ELSE 1
	End
	WHERE Token = (SELECT `Owned By` FROM Properties WHERE NEW.LocationID % 16 = ID); 

	
	--Set 'Owned By' to the player that lands on it if it is NULL otherwise set it back to the player name in that 'Owned By' entry
	UPDATE Properties
	SET `Owned By` = 
	CASE
		WHEN
		(SELECT `Owned By` FROM Properties WHERE NEW.LocationID % 16 = ID) IS NULL
			THEN NEW.Token
		ELSE (SELECT `Owned By` FROM Properties WHERE NEW.LocationID % 16 = ID)
	END
	WHERE ID = NEW.LocationID;
END;


--This trigger send players to 'Jail' after they landed on 'Go To Jail' and they are under custody
CREATE TRIGGER send_Jail
AFTER UPDATE of LocationID ON Player
WHEN NEW.LocationID = 12
BEGIN
	UPDATE Player SET LocationID = 4, 'Under custody' = 1 WHERE Token = NEW.Token;
END;


--Triggers for convenience:
--This trigger simplifies the step needed to update the Audit_Trail table by only needing to input the player's token
CREATE TRIGGER update_audit
AFTER INSERT 
ON Audit_Trail
BEGIN
	UPDATE Audit_Trail 
	SET Ending_Location = (SELECT Location.Name FROM Location, Player, Audit_Trail WHERE NEW.Token = Player.Token and Player.LocationID = Location.ID),
	`Balance (£)` = (SELECT Player.`Balance (£)` FROM Player, Audit_Trail WHERE NEW.Token = Player.Token),
	`Round No.` = (SELECT COUNT(Audit_Trail.Token) FROM Audit_Trail WHERE Audit_Trail.Token = NEW.Token)
	WHERE Audit_Trail.Token = NEW.Token and Audit_Trail.`Round No.` = 0;
END;

--This trigger will automatically update 'Location Description' on the player table 
--when 'LocationID' has been changed
CREATE TRIGGER location_des_update
AFTER UPDATE of LocationID 
ON Player
WHEN NEW.LocationID <> OLD.LocationID
BEGIN
	UPDATE Player SET `Location Description` = CASE
	WHEN NEW.LocationID % 2 IS 1
		THEN 'Property'
		ELSE (SELECT Description FROM Bonus WHERE ID = NEW.LocationID)
	END
	WHERE Token = NEW.Token;
END;

--This trigger updates 'Location Description' after you insert value to the 'LocationID' into the player table 
CREATE TRIGGER location_des_insert
AFTER INSERT  
ON Player
WHEN NEW.LocationID <> 0
BEGIN
	UPDATE Player SET `Location Description` = CASE
	WHEN NEW.LocationID % 2 IS 1
		THEN 'Property'
		ELSE (SELECT Description FROM Bonus WHERE ID = NEW.LocationID)
	END
	WHERE Token = NEW.Token;
END;
