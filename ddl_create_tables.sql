create database if not exists MovieCatalogue;

use MovieCatalogue;

create table if not exists `Genre`(
	`GenreID` int not null auto_increment, 
    `GenreName` varchar(30) not null, 
    PRIMARY KEY(`GenreID`)
);

create table if not exists `Director`(
	`DirectorID` int not null auto_increment, 
    `FirstName` varchar(30) not null, 
    `LastName` varchar(30) not null, 
    `BirthDate` date null, 
    PRIMARY KEY(`DirectorID`)
);

create table if not exists `Rating`(
	`RatingID` int not null auto_increment, 
    `RatingName` varchar(5) not null, 
    PRIMARY KEY(`RatingID`)
);

create table if not exists `Actor`(
	`ActorID` int not null auto_increment, 
    `FirstName` varchar(30) not null, 
    `LastName` varchar(30) not null, 
    `BirthDate` date null,
	PRIMARY KEY(`ActorID`)
);

create table if not exists `Movie`(
	`MovieID` int not null auto_increment,
    `GenreID` int not null, -- foreign key from Genre table
    `DirectorID` int null, -- foreign key from Director table
    `RatingID` int null, -- foreign key from Rating table
    `Title` varchar(128) not null, 
    `ReleaseDate` date null, 
    PRIMARY KEY(`MovieID`)
);

-- adding constraints for GenreID
alter table `Movie`
	add constraint `fk_MovieGenre` foreign key(`GenreID`) references `Genre`
    (`GenreID`) on delete no action;

-- adding constraints for DirectorID
alter table `Movie`
	add constraint `fk_MovieDirector` foreign key(`DirectorID`) references `Director`
    (`DirectorID`) on delete no action;
    
-- adding constraints for RatingID
alter table `Movie`
	add constraint `fk_MovieRating` foreign key(`RatingID`) references `Rating`
    (`RatingID`) on delete no action;

create table if not exists `CastMembers`(
	`CastMemberID` int not null auto_increment,
    `ActorID` int not null, -- foreign key from Actor table
    `MovieID` int not null, -- foreign key from Movie table
    `Role` varchar(50) not null, 
    PRIMARY KEY(`CastMemberID`)
);

-- adding constraints for ActorID
alter table `CastMembers`
	add constraint `fk_CastMemberActor` foreign key(`ActorID`) references `Actor`
    (`ActorID`) on delete no action;

-- adding constraints for MovieID
alter table `CastMembers`
	add constraint `fk_CastMemberMovie` foreign key(`MovieID`) references `Movie`
    (`MovieID`) on delete no action;


    
	