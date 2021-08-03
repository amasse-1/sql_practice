use moviecatalogue;

insert into Actor (ActorID, FirstName, LastName, BirthDate) values
(1, 'Bill', 'Murray', '1950/9/21'), 
(2, 'Dan', 'Aykroyd', '1952/7/1'),
(3, 'John', 'Candy', '1950/10/31'), 
(4, 'Steve', 'Martin', NULL), 
(5, 'Sylvester', 'Stallone', NULL);

insert into Director (DirectorID, FirstName, LastName, BirthDate) values 
(1, 'Ivan', 'Reitman', '1946/10/27'), 
(2, 'Ted', 'Kotcheff', NULL);

insert into Rating (RatingID, RatingName) values
(1, 'G'), 
(2, 'PG'), 
(3, 'PG-13'), 
(4, 'R');

insert into Genre (GenreID, GenreName) values
(1, 'Action'), 
(2, 'Comedy'), 
(3, 'Drama'), 
(4, 'Horror');

insert into Movie (MovieID, GenreID, DirectorID, RatingID, Title, ReleaseDate) values
(1, 1, 2, 4, 'Rambo: First Blood', '1982/10/22'), 
(2, 2, NULL, 4, 'Planes, Trains, & Automobiles', '1987/11/25'), 
(3,2,1,2, 'Ghostbusters', NULL), 
(4,2,NULL,2, 'The Great Outdoors', '1988/6/17');

insert into CastMembers (CastMemberID, ActorID, MovieID, Role) values
(1,5,1, 'John Rambo'), 
(2,4,2,'Neil Page'),
(3,3,2,'Del Griffin'),
(4,1,3,'Dr.Peter Venkman'),
(5,2,3,'Dr.Raymond Stanz'),
(6,2,4,'Roman Craig'),
(7,3,4, 'Chet Ripley');

-- update the title of ghostbusters to append (1984) and the release date to 6/8/1984
update movie set
Title = 'Ghostbusters(1984)', 
ReleaseDate = '1984/6/8'
where MovieID = 3;

-- update name of Action to Action/Adventure
update genre set
GenreName = 'Action/Adventure'
where GenreID = 1;

-- delete rambo first blood from the movie table at (MovieID 1)
delete from CastMembers where MovieID = 1; -- must do it from CastMembers first
delete from Movie where MovieID = 1; 

-- add a column that is the DateofDeath of the actors (if applicable for some)
alter table Actor add DateOfDeath date null;

-- update John Candy's DateOfDeath
update actor 
set DateOfDeath = '1994/3/4'
where ActorID = 3;