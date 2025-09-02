--Find each employee with their manager (self join on the Employee table).
SELECT 
E1.FirstName + ' ' + E1.LastName AS Employee,
E2.FirstName + ' ' + E2.LastName AS Manager
FROM Employee E1
LEFT JOIN Employee E2 ON E1.ReportsTo = E2.EmployeeID
 ---------------------------------------------------------------
--  Show each customer, the employee who sold them the invoice, invoice details and totals.
-- Order by total in descending order. If totals are equal, order by customer name descending
 SELECT 
    C.FirstName+' '+C.LastName AS CustomerName,
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    I.InvoiceID,
    I.InvoiceDate,
    I.Total
FROM Customer C
JOIN Invoice I
    ON C.CustomerID = I.CustomerID
JOIN Employee E
    ON E.EmployeeId=C.SupportRepId
ORDER BY  I.Total DESC , CustomerName
--------------------------------------------------------------------
-- Get the top 10 artists with the highest average gain when their tracks are in playlists.
-- If there is a tie in average gain, order alphabetically by artist name.
SELECT  TOP  10
AR.Name,PL.Name,
AVG(IL.UnitPrice*IL.Quantity) AS AverageGained
FROM Artist AR
JOIN Album AL ON AR.ArtistId=AL.ArtistId
JOIN Track TR ON TR.AlbumId=AL.AlbumId
JOIN InvoiceLine IL  ON IL.TrackId=TR.TrackId
JOIN Invoice I ON I.InvoiceId=IL.InvoiceId
JOIN Customer C ON C.CustomerId=I.CustomerId
JOIN PlaylistTrack PT ON PT.TrackId=TR.TrackId
JOIN Playlist PL ON PL.PlaylistId=PT.PlaylistId
GROUP BY AR.Name,PL.Name
ORDER BY AverageGained DESC,AR.Name
------------------------------------------------------
 -- Get the top 5 countries with the highest number of invoices
SELECT TOP 5 BillingCountry,COUNT(*) AS NO_INVOICES
FROM Invoice
GROUP BY BillingCountry
ORDER BY  NO_INVOICES DESC
-----------------------------
-- Show number of invoices per country (all countries, not just top 5)
SELECT  BillingCountry,COUNT(*) AS NO_INVOICES
FROM Invoice
GROUP BY BillingCountry
ORDER BY  NO_INVOICES DESC
-------------------------------
-- Show total money spent by each customer, ordered by highest total
SELECT  CustomerId ,
SUM(Total) AS TotalMoney
FROM Invoice
GROUP BY CustomerId
ORDER BY TotalMoney DESC
---------------------------------
-- Get the single top customer who spent the most money.
SELECT TOP 1 CustomerId ,
SUM(Total) AS TotalMoney
FROM Invoice
GROUP BY CustomerId
ORDER BY TotalMoney DESC
-----------------------------------
-- Show each customer’s full name, ID, and total money spent. 
-- Ordered by total money spent descending
SELECT Customer.FirstName,Customer.LastName,Customer.CustomerId,
SUM(Total) AS TotalMoney
FROM Customer
JOIN Invoice
ON Customer.CustomerId=Invoice.CustomerId
GROUP BY Customer.FirstName,Customer.LastName,Customer.CustomerId
ORDER BY TotalMoney DESC
-----------------------------------------------
-- Show the top 10 customers by money spent with their full name and ID.

SELECT TOP 10
FirstName+' '+LastName AS FullName,Customer.CustomerId,
SUM(Total) AS TotalMoney
FROM Customer
JOIN Invoice
ON Customer.CustomerId=Invoice.CustomerId
GROUP BY Customer.FirstName,Customer.LastName,Customer.CustomerId
ORDER BY TotalMoney DESC
----------------------------------------------------
-- Get the top customer with their name, ID, billing city and total money spent
SELECT TOP 1
FirstName+' '+LastName AS FullName,Customer.CustomerId,Invoice.BillingCity,
SUM(Total) AS TotalMoney
FROM Customer
JOIN Invoice
ON Customer.CustomerId=Invoice.CustomerId
GROUP BY Customer.FirstName,Customer.LastName,Customer.CustomerId,Invoice.BillingCity
ORDER BY TotalMoney DESC
-------------------------------------------------------
-- Show distinct artists in the Rock genre, with count of their Rock tracks.
-- Ordered by number of Rock tracks descending.
SELECT DISTINCT A.Name AS ArtistName , G.Name, COUNT(T.TrackId) AS RockTrackCount
FROM Track T
JOIN Album AL ON T.AlbumId = AL.AlbumId
JOIN Artist A ON AL.ArtistId = A.ArtistId
JOIN Genre G ON T.GenreId = G.GenreId
WHERE G.Name = 'Rock'
GROUP BY A.Name, G.Name
ORDER BY RockTrackCount DESC
-----------------------------------------------------------
-- Get the artist who gained the highest total revenue.

SELECT TOP 1
Artist.Name,SUM(InvoiceLine.Quantity*InvoiceLine.UnitPrice) AS TheGain
FROM Artist
JOIN Album ON Artist.ArtistId= Album.ArtistId
JOIN Track ON Track.AlbumId=Album.AlbumId
JOIN InvoiceLine ON InvoiceLine.TrackId=Track.TrackId
GROUP BY Artist.Name
ORDER BY TheGain DESC
-------------------------------------------------------------
