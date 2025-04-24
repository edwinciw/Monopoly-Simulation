--Name: Iok Weng Chan
--Student ID: 10453571

--Mary rolled a 6, and then a 5, but Mary was sent to Jail so we need to add the roll separately 
--for the trigger 'release_from_Jail' to activate and allow Mary play normally
UPDATE Player
SET LocationID = LocationID + 6
WHERE Name = 'Mary';


UPDATE Player
SET LocationID = LocationID + 5
WHERE Name = 'Mary';

--Read the description of the location and its name
SELECT L.Name, P.`Location Description` FROM Player AS P 
LEFT JOIN Location AS L ON L.ID = P.LocationID 
WHERE P.Name = 'Mary';
--In this case, Mary is on 'Co-Op' and Mary pay the cost of the property which is done 
--by the trigger (land_on_property) 


--Finally, store Mary's move and changes into the Audit_Trail table by inserting Mary's Token 
--as an instance and the trigger (update_audit) will complete the whole instance.
INSERT INTO Audit_Trail(Token) VALUES ((SELECT Token FROM Player WHERE Name = 'Mary'));
