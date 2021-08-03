use PersonalTrainer;

-- Use an aggregate to count the number of Clients.
-- 500 rows
--------------------

select count(*) from client;

-- Use an aggregate to count Client.BirthDate.
-- The number is different than total Clients. Why?
-- 463 rows
--------------------

select count(BirthDate) from client;

-- Group Clients by City and count them.
-- Order by the number of Clients desc.
-- 20 rows
--------------------

select City, count(*) from client
group by City
order by count(*) desc;

-- Calculate a total per invoice using only the InvoiceLineItem table.
-- Group by InvoiceId.
-- You'll need an expression for the line item total: Price * Quantity.
-- Aggregate per group using SUM().
-- 1000 rows
--------------------

select InvoiceId, sum(price*quantity) as total_per_invoice 
from invoicelineitem
group by InvoiceId;

-- Calculate a total per invoice using only the InvoiceLineItem table.
-- (See above.)
-- Only include totals greater than $500.00.
-- Order from lowest total to highest.
-- 234 rows
--------------------

select InvoiceId, sum(price*quantity) as total_per_invoice 
from invoicelineitem
group by InvoiceId
having  sum(price*quantity) > 500
order by sum(price*quantity) ASC;

-- Calculate the average line item total
-- grouped by InvoiceLineItem.Description.
-- 3 rows
--------------------

select Description, avg(price * quantity) AvgTotal
from invoicelineitem
group by Description;

-- Select ClientId, FirstName, and LastName from Client
-- for clients who have *paid* over $1000 total.
-- Paid is Invoice.InvoiceStatus = 2.
-- Order by LastName, then FirstName.
-- 146 rows
--------------------

select c.ClientId, c.FirstName, c.LastName, sum(il.price * il.quantity) as PaidTotal
from Client c
inner join invoice i on c.ClientId = i.ClientId
inner join invoicelineitem il on i.InvoiceId = il.InvoiceId
where i.InvoiceStatus=2
group by c.ClientId, c.FirstName, c.LastName
having sum(il.price * il.quantity) > 1000
order by c.LastName ASC, c.FirstName ASC;

-- Count exercises by category.
-- Group by ExerciseCategory.Name.
-- Order by exercise count descending.
-- 13 rows
--------------------

select ec.Name CategoryName, count(e.ExerciseId) ExerciseCount 
from exercisecategory ec
inner join exercise e on ec.ExerciseCategoryId = e.ExerciseCategoryId
group by ec.Name
order by count(e.ExerciseId) DESC;

-- Select Exercise.Name along with the minimum, maximum,
-- and average ExerciseInstance.Sets.
-- Order by Exercise.Name.
-- 64 rows
--------------------

select e.Name ExerciseName, min(ei.Sets) MinSets, avg(ei.Sets) AvgSets, max(ei.Sets) MaxSets
from Exercise e
inner join exerciseinstance ei on e.ExerciseId = ei.ExerciseId
group by e.ExerciseCategoryId, e.Name 
order by e.Name;

-- Find the minimum and maximum Client.BirthDate
-- per Workout.
-- 26 rows
-- Sample: 
-- WorkoutName, EarliestBirthDate, LatestBirthDate
-- '3, 2, 1... Yoga!', '1928-04-28', '1993-02-07'
--------------------

select w.Name WorkoutName, min(c.BirthDate) EarliestBirthDate, max(c.BirthDate) LatestBirthDate
from client c
inner join clientworkout cw on c.ClientId = cw.ClientId
inner join workout w on cw.WorkoutId = w.WorkoutId
group by w.WorkoutId, w.Name;

-- Count client goals.
-- Be careful not to exclude rows for clients without goals.
-- 500 rows total
-- 50 rows with no goals
--------------------

select c.ClientId, count(cg.GoalId) GoalCount
from client c 
left outer join clientgoal cg on c.ClientId = cg.ClientId
group by c.ClientId
order by count(cg.GoalId) ASC;

-- Select Exercise.Name, Unit.Name, 
-- and minimum and maximum ExerciseInstanceUnitValue.Value
-- for all exercises with a configured ExerciseInstanceUnitValue.
-- Order by Exercise.Name, then Unit.Name.
-- 82 rows
--------------------

select e.Name ExerciseName, u.Name UnitName, min(eiu.Value) MinimumValue, max(eiu.Value) MaximumValue
from exercise e
inner join exerciseinstance ei on e.ExerciseId = ei.ExerciseId
inner join exerciseinstanceunitvalue eiu on ei.ExerciseInstanceId = eiu.ExerciseInstanceId
inner join unit u on eiu.UnitId = u.UnitId
group by e.ExerciseId, e.Name, u.UnitId, u.Name
order by e.Name, u.Name;

-- Modify the query above to include ExerciseCategory.Name.
-- Order by ExerciseCategory.Name, then Exercise.Name, then Unit.Name.
-- 82 rows
--------------------

select ec.Name CategoryName, e.Name ExerciseName, u.Name UnitName, min(eiu.Value) MinimumValue, max(eiu.Value) MaximumValue
from exercisecategory ec
inner join exercise e on ec.ExerciseCategoryId = e.ExerciseCategoryId
inner join exerciseinstance ei on e.ExerciseId = ei.ExerciseId
inner join exerciseinstanceunitvalue eiu on ei.ExerciseInstanceId = eiu.ExerciseInstanceId
inner join unit u on eiu.UnitId = u.UnitId
group by e.ExerciseId, e.Name, u.UnitId, u.Name, ec.Name
order by ec.Name, e.Name, u.Name;

-- Select the minimum and maximum age in years for
-- each Level.
-- To calculate age in years, use the MySQL function DATEDIFF.
-- 4 rows
--------------------

select l.Name, 
		min(datediff(curdate(), c.BirthDate) / 365) MinAge,
        max(datediff(curdate(), c.BirthDate) / 365) MaxAge
from level l 
inner join workout w on l.LevelId = w.LevelId
inner join clientworkout cw on w.WorkoutId = cw.WorkoutId
inner join client c on cw.ClientId = c.ClientId
group by l.Name;

-- Stretch Goal!
-- Count logins by email extension (.com, .net, .org, etc...).
-- Research SQL functions to isolate a very specific part of a string value.
-- 27 rows (27 unique email extensions)
--------------------

select substring_index(EmailAddress, '.' , -1),
		count(EmailAddress)
from login
group by substring_index(EmailAddress, '.' , -1)
order by count(EmailAddress) DESC;



-- Stretch Goal!
-- Match client goals to workout goals.
-- Select Client FirstName and LastName and Workout.Name for
-- all workouts that match at least 2 of a client's goals.
-- Order by the client's last name, then first name.
-- 139 rows
--------------------

select w.Name WorkoutName, concat(c.FirstName,' ', c.LastName) ClientName, count(cg.GoalId) 
from client c
inner join clientworkout cw on c.ClientId = cw.ClientId
inner join workout w on cw.WorkoutId = w.WorkoutId
inner join clientgoal cg on c.ClientId = cg.ClientId
group by w.WorkoutId, w.Name, c.ClientId, c.FirstName, c.LastName
having count(cg.GoalId) > 1
order by c.LastName, c.FirstName;