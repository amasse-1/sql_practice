use PersonalTrainer;

-- A1: select all from the exercise table
select * from Exercise;

-- A2: select all from the client table
select * from Client;

-- A3: select all from client where city is Metairie is the city 
select * from Client
where City = "Metairie";

-- A4: searching for a specific client, will bring back no results 
select * from Client
where ClientId = "818u7faf-7b4b-48a2-bf12-7a26c92de20c";

-- A5: how many rows are in the Goal table
select * from Goal; 

-- A6: selecting name and levelid from workout table
select Name, LevelId from Workout;

-- A7: selecting name, levelid and notes from workout table where level id is 2
select Name, LevelId, Notes from Workout
where LevelId = 2;

-- A8: selec first and last name as well as city from client where city is Metairie, Kenner, or Gretna
select FirstName, LastName, City from Client
where City = "Metairie" OR City = "Kenner" OR City = "Gretna";

-- A9: select first and last names as well as birthdate from clients where clients born in 1980s
select FirstName, LastName, BirthDate from Client
where Birthdate LIKE "198%";

-- A10: same as the last but with between keyword
select FirstName, LastName, BirthDate from Client
where Birthdate BETWEEN "1980-01-01" AND "1989-12-31";

-- A11: how many logins end with the .gov extension on the email
select * from login 
where EmailAddress LIKE "%.gov";

-- A12: how many logins do not end in .com extension on the email
select * from login 
where EmailAddress NOT LIKE "%.com";

-- A13: select clients names who dont have a birthdate
select FirstName, LastName from Client
where BirthDate is null;

-- A14: selecting name of each ExerciseCategoryId that HAS a ParentCategoryId
select Name from exercisecategory
where ParentCategoryId is not null;

-- A15: select names and notes of workouts that are level 3 and where the notes contain the word "you"
select Name, Notes from workout
where LevelId = 3 AND Notes LIKE "%you%";

-- A16: select firstname, lastname, city from clients who have lastnames that start with l, m, or n and who live in LaPlace
select FirstName, LastName, City from client
where (LastName like "L%" or  "M%" or "N%")
and City like "LaPlace";

/* A17: Select InvoiceId, Description, Price, Quantity, ServiceDate and the line item total, a calculated value, from InvoiceLineItem, 
 where the line item total is between 15 and 25 dollars. */
 select InvoiceId, Description, Price, Quantity, ServiceDate, Price*Quantity AS line_item_total from InvoiceLineItem
 where Price*Quantity BETWEEN 15 AND 25; -- would not allow me to use the alias for the where statement
 
 -- A18: check to see if there is an email for the client, Estrella Bazely.
 select * from client
 where FirstName = "Estrella" and LastName = "Bazely";
-- pt2: check to see if there is an login record for the client id
select * from login
where ClientId = "87976c42-9226-4bc6-8b32-23a8cd7869a5";
-- email is 'ebazelybf@123-reg.co.uk'

-- A19: What are the Goals of the Workout with the Name 'This Is Parkour'?
-- query 1: find out workoutid of this is parkour 
select WorkoutId from workout
where Name = "This Is Parkour"; 
-- query 2: using workoutid (12) match with the goalid in workoutgoal
select * from workoutgoal
where WorkoutId = 12;

-- query 3: now take the goalid's (3, 8, 15) and find them in the goal table matching the name 
select * from goal 
where GoalId = 3 or GoalId = 8 or GoalId = 15;

