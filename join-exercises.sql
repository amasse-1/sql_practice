use personaltrainer;

-- Select all columns from ExerciseCategory and Exercise.
-- The tables should be joined on ExerciseCategoryId.
-- This query returns all Exercises and their associated ExerciseCategory.
-- 64 rows
--------------------

select * from exercisecategory 
inner join exercise 
on exercisecategory.ExerciseCategoryId = exercise.ExerciseCategoryId;

-- Select ExerciseCategory.Name and Exercise.Name
-- where the ExerciseCategory does not have a ParentCategoryId (it is null).
-- Again, join the tables on their shared key (ExerciseCategoryId).
-- 9 rows
--------------------

select exercisecategory.Name, Exercise.Name from exercisecategory 
inner join exercise on exercisecategory.ExerciseCategoryId = exercise.ExerciseCategoryId
where ParentCategoryId is NULL;

-- The query above is a little confusing. At first glance, it's hard to tell
-- which Name belongs to ExerciseCategory and which belongs to Exercise.
-- Rewrite the query using an aliases. 
-- Alias ExerciseCategory.Name as 'CategoryName'.
-- Alias Exercise.Name as 'ExerciseName'.
-- 9 rows
--------------------

select exercisecategory.Name as ExerciseName, Exercise.Name as CategoryName from exercisecategory 
inner join exercise on exercisecategory.ExerciseCategoryId = exercise.ExerciseCategoryId
where ParentCategoryId is NULL;

-- Select FirstName, LastName, and BirthDate from Client
-- and EmailAddress from Login 
-- where Client.BirthDate is in the 1990s.
-- Join the tables by their key relationship. 
-- What is the primary-foreign key relationship?
-- 35 rows
--------------------

select c.FirstName, c.LastName, c.BirthDate, l.EmailAddress from Client c
inner join login l on c.ClientId = l.ClientId
where c.BirthDate between '1990-1-1' and '1999-12-31';

-- Select Workout.Name, Client.FirstName, and Client.LastName
-- for Clients with LastNames starting with 'C'?
-- How are Clients and Workouts related?
-- 25 rows
--------------------

select c.FirstName, c.LastName, w.Name from client c
inner join clientworkout cw on cw.ClientId = c.ClientId
inner join workout w on cw.WorkoutId = w.WorkoutId
where c.LastName like 'C%';

-- Select Names from Workouts and their Goals.
-- This is a many-to-many relationship with a bridge table.
-- Use aliases appropriately to avoid ambiguous columns in the result.
--------------------

select w.Name as WorkoutName, g.Name as GoalName from workout w
inner join workoutgoal wg on wg.WorkoutId = w.WorkoutId
inner join goal g on wg.GoalId = g.GoalId;

-- Select FirstName and LastName from Client.
-- Select ClientId and EmailAddress from Login.
-- Join the tables, but make Login optional.
-- 500 rows
--------------------

select l.ClientId,
		c.FirstName, 
		c.LastName, 
        l.EmailAddress 
from client c
left outer join login l on c.ClientId = l.ClientId;

-- Using the query above as a foundation, select Clients
-- who do _not_ have a Login.
-- 200 rows
--------------------

select l.ClientId,
		c.FirstName, 
		c.LastName, 
        l.EmailAddress 
from client c
left outer join login l on c.ClientId = l.ClientId
where l.EmailAddress is NULL;

-- Does the Client, Romeo Seaward, have a Login?
-- Decide using a single query.
-- nope :(
--------------------

select l.ClientId,
		c.FirstName, 
		c.LastName, 
        l.EmailAddress 
from client c
left outer join login l on c.ClientId = l.ClientId
where c.FirstName = 'Romeo' and c.LastName = 'Seaward';

-- Select ExerciseCategory.Name and its parent ExerciseCategory's Name.
-- This requires a self-join.
-- 12 rows
--------------------
    
select ec.Name ExericseCategory, pc.Name ParentCategory from exercisecategory ec
inner join exercisecategory pc on ec.ParentCategoryId = pc.ExerciseCategoryId;
    
-- Rewrite the query above so that every ExerciseCategory.Name is
-- included, even if it doesn't have a parent.
-- 16 rows
--------------------

select ec.Name ExericseCategory, pc.Name ParentCategory from exercisecategory ec
left outer join exercisecategory pc on ec.ParentCategoryId = pc.ExerciseCategoryId;
    
-- Are there Clients who are not signed up for a Workout?
-- 50 rows
--------------------

select c.FirstName, c.LastName, cw.WorkoutId from client c
left outer join clientworkout cw on c.ClientId = cw.ClientId
where cw.WorkoutId is null;

-- Which Beginner-Level Workouts satisfy at least one of Shell Creane's Goals?
-- Goals are associated to Clients through ClientGoal.
-- Goals are associated to Workouts through WorkoutGoal.
-- 6 rows, 4 unique rows
--------------------

select w.WorkoutId, w.Name WorkoutName from client c 
inner join clientgoal cg on c.ClientId = cg.ClientId
inner join workoutgoal wg on cg.GoalId = wg.GoalId
inner join Workout w on wg.WorkoutId = w.WorkoutId
where c.FirstName = 'Shell' and c.LastName = 'Creane' and w.LevelId = 1;

-- Select all Workouts. 
-- Join to the Goal, 'Core Strength', but make it optional.
-- You may have to look up the GoalId before writing the main query.
-- If you filter on Goal.Name in a WHERE clause, Workouts will be excluded.
-- Why?
-- 26 Workouts, 3 Goals
--------------------

select w.Name WorkoutName, g.Name GoalName from workout w 
left outer join workoutgoal wg on w.WorkoutId = wg.WorkoutId and wg.GoalId = 10
left outer join goal g on wg.GoalId = g.GoalId;

-- The relationship between Workouts and Exercises is... complicated.
-- Workout links to WorkoutDay (one day in a Workout routine)
-- which links to WorkoutDayExerciseInstance 
-- (Exercises can be repeated in a day so a bridge table is required) 
-- which links to ExerciseInstance 
-- (Exercises can be done with different weights, repetions,
-- laps, etc...) 
-- which finally links to Exercise.
-- Select Workout.Name and Exercise.Name for related Workouts and Exercises.
--------------------

select w.Name WorkoutName, e.Name ExerciseName from workout w 
inner join workoutday wd on w.WorkoutId = wd.WorkoutId
inner join workoutdayexerciseinstance wdei on wd.WorkoutDayId = wdei.WorkoutDayId
inner join exerciseinstance ei on wdei.ExerciseInstanceId = ei.ExerciseInstanceId
inner join exercise e on ei.ExerciseId = e.ExerciseId;

-- An ExerciseInstance is configured with ExerciseInstanceUnitValue.
-- It contains a Value and UnitId that links to Unit.
-- Example Unit/Value combos include 10 laps, 15 minutes, 200 pounds.
-- Select Exercise.Name, ExerciseInstanceUnitValue.Value, and Unit.Name
-- for the 'Plank' exercise. 
-- How many Planks are configured, which Units apply, and what 
-- are the configured Values?
-- 4 rows, 1 Unit, and 4 distinct Values
--------------------

select e.Name ExerciseName, uv.Value, u.Name UnitName from exercise e
inner join exerciseinstance ei on e.ExerciseId = ei.ExerciseId
left outer join exerciseinstanceunitvalue uv on ei.ExerciseInstanceId = uv.ExerciseInstanceId
left outer join unit u on uv.UnitId = u.UnitId
where e.Name = 'Plank';