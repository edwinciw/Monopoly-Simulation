--Name: Iok Weng Chan
--Student ID: 10453571

--Mary rolled a 4
UPDATE Player
SET LocationID = LocationID + 4
WHERE Name = 'Mary';

--Read the description of the location and its name
SELECT L.Name, P.`Location Description` FROM Player AS P 
LEFT JOIN Location AS L ON L.ID = P.LocationID 
WHERE P.Name = 'Mary';
--In this case, Mary was on 'Go To Jail' and Mary got sent to 'Jail' by the trigger 'send_Jail'

--Finally, store Mary's move and changes into the Audit_Trail table by inserting Mary's Token 
--as an instance and the trigger (update_audit) will complete the whole instance.
INSERT INTO Audit_Trail(Token) VALUES ((SELECT Token FROM Player WHERE Name = 'Mary'));
