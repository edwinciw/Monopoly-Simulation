--Name: Iok Weng Chan
--Student ID: 10453571

--Bill rolled a 6, then a 3
UPDATE Player
SET LocationID = LocationID + 6 + 3
WHERE Name = 'Bill';

--Read the description of the location and its name
SELECT L.Name, P.`Location Description` FROM Player AS P 
LEFT JOIN Location AS L ON L.ID = P.LocationID 
WHERE P.Name = 'Bill';

--Do what the description said
UPDATE Player
SET `Balance (£)` = `Balance (£)` + 100
WHERE Name = 'Bill';

--Finally, store Bill's move and changes into the Audit_Trail table by inserting Bill's Token 
--as an instance and the trigger (update_audit) will complete the whole instance.
INSERT INTO Audit_Trail(Token) VALUES ((SELECT Token FROM Player WHERE Name = 'Bill'));
