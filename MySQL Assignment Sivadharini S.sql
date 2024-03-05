show databases;
use artgallery;
show tables;
CREATE TABLE Categories (
CategoryID INT PRIMARY KEY,
Name VARCHAR(100) NOT NULL);

CREATE TABLE Artworks (
ArtworkID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
ArtistID INT,
CategoryID INT,
Year INT,
Description TEXT,
ImageURL VARCHAR(255),
FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

CREATE TABLE Exhibitions (
ExhibitionID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
StartDate DATE,
EndDate DATE,
Description TEXT);

CREATE TABLE ExhibitionArtworks (
ExhibitionID INT,
ArtworkID INT,
PRIMARY KEY (ExhibitionID, ArtworkID),
FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\'s powerful anti-war mural.', 'guernica.jpg');

INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);


SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists LEFT JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
ORDER BY ArtworkCount DESC;

select a.Description from Artworks a join Artists t on t.ArtistID=a.ArtistID
where t.Nationality ='Spanish' or t.Nationality='Dutch'
order by a.year;

select Artists.name,count(Artworks.CategoryID) from Artists 
join Artworks on Artists.ArtistID = Artworks.ArtistID
join Categories on Categories.CategoryID = Artworks.CategoryID
group by Categories.name
having Artworks.CategoryID = 1;

 
select Artworks.Title,Artists.name,Categories.name from Artworks join ExhibitionArtworks on Artworks.ArtworkID=ExhibitionArtworks.ArtworkID
join Exhibitions on  ExhibitionArtworks.ExhibitionID=Exhibitions.ExhibitionID 
join Artists on Artists.ArtistID = Artworks.ArtistID
join Categories on Categories.CategoryID = Artworks.CategoryID
where Exhibitions.Title = 'Modern Art Masterpieces';

select Artists.name from Artists 
join Artworks on Artists.ArtistID = Artworks.ArtistID
group by Artists.name
having count(Artworks.ArtworkID) > 2;

SELECT Artworks.Title
FROM Artworks
JOIN ExhibitionArtworks ea1 ON Artworks.ArtworkID = ea1.ArtworkID
JOIN Exhibitions ex1 ON ea1.ExhibitionID = ex1.ExhibitionID
JOIN ExhibitionArtworks ea2 ON Artworks.ArtworkID = ea2.ArtworkID
JOIN Exhibitions ex2 ON ea2.ExhibitionID = ex2.ExhibitionID
WHERE ex1.Title = 'Modern Art Masterpieces'AND ex2.Title = 'Renaissance Art';

select Categories.Name,count(Artworks.CategoryID) from Artworks 
join Categories on Artworks.CategoryID=Categories.CategoryID 
group by categories.name;

select Artists.name from Artists join Artworks on Artists.ArtistID = Artworks.ArtistID  
group by Artists.name having count(Artworks.ArtworkID) > 3;

select Artworks.Title from Artworks join Artists 
on Artworks.ArtistID = Artists.ArtistID where Artists.Nationality='Spanish';

SELECT Exhibitions.Title FROM Exhibitions JOIN ExhibitionArtworks ea1 
ON Exhibitions.ExhibitionID = ea1.ExhibitionID
JOIN Artworks a1 ON ea1.ArtworkID = a1.ArtworkID 
JOIN ExhibitionArtworks ea2 ON Exhibitions.ExhibitionID = ea2.ExhibitionID 
JOIN Artworks a2 ON ea2.ArtworkID = a2.ArtworkID 
JOIN Artists av ON a1.ArtistID = av.ArtistID 
JOIN Artists al ON a2.ArtistID = al.ArtistID 
WHERE av.Name = 'Vincent van Gogh' AND al.Name = 'Leonardo da Vinci';

SELECT Artworks.Title
FROM Artworks
LEFT JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
WHERE ExhibitionArtworks.ArtworkID IS NULL;

SELECT Artists.Name
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(DISTINCT Artworks.CategoryID) = (SELECT COUNT(*) FROM Categories);

SELECT Categories.Name, COUNT(Artworks.ArtworkID) AS TotalArtworks
FROM Categories
LEFT JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name;

select Artists.name from Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
where Artworks.ArtistID > 2;

SELECT Categories.Name, AVG(Artworks.Year) AS AverageYear
FROM Categories
JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name
HAVING COUNT(Artworks.ArtworkID) > 1;

select Artworks.Title from Artworks join ExhibitionArtworks on  Artworks.ArtworkID= ExhibitionArtworks.ArtworkID
join Exhibitions on ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID 
where Exhibitions.Title='Modern art Masterpieces';

select Categories.name from Categories join Artworks on Artworks.CategoryID = Categories.CategoryID
group by Categories.name
having avg(Artworks.year) > (select avg(year) from Artworks);

SELECT Artworks.Title
FROM Artworks
LEFT JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
WHERE ExhibitionArtworks.ArtworkID IS NULL;

select Artists.name from Artists join Artworks on Artists.ArtistID=Artworks.ArtistID
join Categories on Categories.CategoryID=Artworks.CategoryID
where Artworks.CategoryID = (select Categories.CategoryID from Categories 
join Artworks on Artworks.CategoryID=Categories.CategoryID where Artworks.Title = 'Mona Lisa');

SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
LEFT JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
ORDER BY ArtworkCount;

