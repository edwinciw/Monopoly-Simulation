--Name: Iok Weng Chan
--Student ID: 10453571

--Norman rolled a 4
UPDATE Player
SET LocationID = LocationID + 4
WHERE Name = 'Norman';

--Read the description of the location and its name
SELECT L.Name, P.`Location Description` FROM Player AS P 
LEFT JOIN Location AS L ON L.ID = P.LocationID 
WHERE P.Name = 'Norman';
--In this case, Norman is on 'Community Chest 1' and we will now read the Description of 'Community Chest 1'

--Do what the description said
UPDATE Player
SET `Balance (£)` = `Balance (£)` + 100
WHERE Name = 'Norman';

--Finally, store Jane's move and changes into the Audit_Trail table by inserting Jane's Token 
--as an instance and the trigger (update_audit) will complete the whole instance.
INSERT INTO Audit_Trail(Token) VALUES ((SELECT Token FROM Player WHERE Name = 'Norman'));