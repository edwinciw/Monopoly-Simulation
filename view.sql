--Name: Iok Weng Chan
--Student ID: 10453571

CREATE VIEW gameView AS
SELECT 
P.Name AS 'Player', 
CASE
    WHEN (SELECT Count(*) FROM Audit_Trail WHERE Token = P.Token) > 0
        THEN (SELECT MAX(`Round No.`) FROM Audit_Trail WHERE Token =  (SELECT Token From Player WHERE Name = P.Name))
    ELSE 0
END
AS `Round No.`,
L.Name AS 'Current Location',
P.`Balance (£)` AS 'Balance (£)', 
GROUP_CONCAT(Pr.Name) AS 'Properties Owned'
FROM Player AS P
LEFT JOIN Properties AS Pr ON P.Token = Pr.`Owned By`
LEFT JOIN Location AS L ON P.LocationID = L.ID
LEFT JOIN Bonus AS B ON P.LocationID  = B.ID
WHERE P.Name NOT NULL
GROUP BY P.Name, P.`Balance (£)`
ORDER BY P.Name ASC;
