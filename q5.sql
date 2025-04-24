--Name: Iok Weng Chan
--Student ID: 10453571

--Jane rolled a 5
UPDATE Player
SET LocationID = LocationID + 5
WHERE Name = 'Jane';

--Read the description of the location and its name
SELECT L.Name, P.`Location Description` FROM Player AS P 
LEFT JOIN Location AS L ON L.ID = P.LocationID 
WHERE P.Name = 'Jane';
--In this case, Jane is on 'Victoria' and Jane pay the cost of the property which is done 
--by the trigger (land_on_property) 

--Finally, store Jane's move and changes into the Audit_Trail table by inserting Jane's Token 
--as an instance and the trigger (update_audit) will complete the whole instance.
INSERT INTO Audit_Trail(Token) VALUES ((SELECT Token FROM Player WHERE Name = 'Jane'));

