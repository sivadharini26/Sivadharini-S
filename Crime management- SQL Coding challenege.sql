use examples;

CREATE TABLE Crime (
CrimeID INT PRIMARY KEY,
IncidentType VARCHAR(255),
IncidentDate DATE,
Location VARCHAR(255),
Description TEXT,
Status VARCHAR(20)
);
CREATE TABLE Victim (
VictimID INT PRIMARY KEY,
CrimeID INT,
Name VARCHAR(255),
age int,
ContactInfo VARCHAR(255),
Injuries VARCHAR(255),
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);
CREATE TABLE Suspect (
SuspectID INT PRIMARY KEY,
CrimeID INT,
Name VARCHAR(255),
age int,
Description TEXT,
CriminalHistory TEXT,
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

INSERT INTO Crime
VALUES
(1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
(2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under
Investigation'),
(3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed');
INSERT INTO Victim 
VALUES
(1, 1, 'John Doe',35, 'johndoe@example.com', 'Minor injuries'),
(2, 2, 'Jane Smith', 45,'janesmith@example.com', 'Deceased'),
(3, 3, 'Alice Johnson',23, 'alicejohnson@example.com', 'None');
INSERT INTO Suspect 
VALUES
(1, 1, 'Robber 1',36, 'Armed and masked robber', 'Previous robbery convictions'),
(2, 2, 'Unknown', 18,'Investigation ongoing', NULL),
(3, 3, 'Suspect 1',25, 'Shoplifting suspect', 'Prior shoplifting arrests');

select * from Crime;
select * from Victim;
select * from suspect;

/* 1. Select all open incidents*/
SELECT * FROM Crime WHERE Status = 'Open';

/* 2. Find the total number of incidents*/
SELECT COUNT(*) AS TotalIncidents FROM Crime;

/* 3. List all unique incident types*/
SELECT DISTINCT IncidentType FROM Crime;

/* 4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'.*/
SELECT * FROM Crime WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

/* 5. List persons involved in incidents in descending order of age */

SELECT VictimID, CrimeID, Name, ContactInfo, Injuries, Age, NULL AS Description, NULL AS CriminalHistory FROM Victim
UNION ALL
SELECT SuspectID, CrimeID, Name, NULL AS ContactInfo, NULL AS Injuries, Age, Description, CriminalHistory FROM Suspect
ORDER BY Age DESC;

/* 6. Find the average age of persons involved in incidents */
SELECT AVG(Age) AS AverageAge
FROM (SELECT Age FROM Victim UNION ALL SELECT Age FROM Suspect) AS CombinedAges;

/* 7. List incident types and their counts, only for open cases*/
SELECT IncidentType, COUNT(*) AS Incident_Count FROM Crime WHERE Status = 'Open' GROUP BY IncidentType;

/* 8. Find persons with names containing 'Doe' */
SELECT Name FROM Victim WHERE Name LIKE '%Doe%';

/* 9. Retrieve the names of persons involved in open cases and closed cases*/
SELECT Name FROM Victim WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Open')
UNION
SELECT Name FROM Suspect WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Open');

SELECT Name FROM Victim WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Closed')
UNION
SELECT Name FROM Suspect WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Closed');

/* 10. List incident types where there are persons aged 30 or 35 involved*/
SELECT DISTINCT C.IncidentType FROM Crime C
JOIN (SELECT CrimeID FROM Victim WHERE Age = 30 UNION SELECT CrimeID FROM Suspect WHERE Age = 30 UNION 
SELECT CrimeID FROM Victim WHERE Age = 35 UNION SELECT CrimeID FROM Suspect WHERE Age = 35) AS Incidents30_35 ON C.CrimeID = Incidents30_35.CrimeID;

/* 11. Find persons involved in incidents of the same type as 'Robbery'*/
SELECT Name, 'Victim' AS Role
FROM Victim JOIN Crime ON Victim.CrimeID = Crime.CrimeID WHERE IncidentType = 'Robbery'
UNION
SELECT Name, 'Suspect' AS Role
FROM Suspect JOIN Crime ON Suspect.CrimeID = Crime.CrimeID WHERE IncidentType = 'Robbery';

/* 12. List incident types with more than one open case*/
SELECT IncidentType FROM Crime WHERE Status = 'Open' GROUP BY IncidentType HAVING COUNT(*) > 1;

/* 13. List all incidents with suspects whose names also appear as victims in other incidents*/
SELECT DISTINCT C.*, S.Name AS SuspectName FROM Crime C
JOIN Suspect S ON C.CrimeID = S.CrimeID
JOIN Victim V ON C.CrimeID = V.CrimeID AND S.Name = V.Name;

/* 14. Retrieve all incidents along with victim and suspect details*/
SELECT C.*, V.Name AS VictimName, V.ContactInfo, V.Injuries, S.Name AS SuspectName, S.Description AS SuspectDescription, S.CriminalHistory
FROM Crime C
LEFT JOIN Victim V ON C.CrimeID = V.CrimeID
LEFT JOIN Suspect S ON C.CrimeID = S.CrimeID;

/* 15. Find incidents where the suspect is older than any victim */
SELECT C.IncidentType FROM Crime C
JOIN (SELECT CrimeID FROM Suspect WHERE Age > ANY (SELECT Age FROM Victim WHERE Victim.CrimeID = Suspect.CrimeID)) 
AS IncidentsWithOlderSuspects ON C.CrimeID = IncidentsWithOlderSuspects.CrimeID;

/* 16. Find suspects involved in multiple incidents*/
SELECT Name, COUNT(*) AS Incident_Count FROM Suspect
INNER JOIN Crime ON Suspect.CrimeID = Crime.CrimeID GROUP BY Name HAVING COUNT(*) > 1;

/* 17. List incidents with no suspects involved */
SELECT * FROM Crime
LEFT JOIN Suspect ON Crime.CrimeID = Suspect.CrimeID WHERE Suspect.SuspectID IS NULL;

/* 18. List all cases where at least one incident is of type 'Homicide' and all other incidents are of type 'Robbery'*/
SELECT c.CrimeID, c.IncidentType, c.IncidentDate, c.Location, c.Description, c.Status
FROM Crime c WHERE IncidentType = 'Homicide'
OR (IncidentType = 'Robbery' AND NOT EXISTS (SELECT 1 FROM Crime c2 WHERE c2.CrimeID = c.CrimeID AND c2.IncidentType != 'Robbery'));
  
/* 19. Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or 'No Suspect' if there are none*/

SELECT c.CrimeID, c.IncidentType, c.IncidentDate, c.Location, c.Description, c.Status,
COALESCE(s.Name, 'No Suspect') AS SuspectName
FROM Crime c LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;  

/* 20. List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault'*/
SELECT DISTINCT s.SuspectID, s.Name
FROM Suspect s JOIN Crime c ON s.CrimeID = c.CrimeID WHERE c.IncidentType IN ('Robbery', 'Assault');

