drop database if exists ParkShare;
create database ParkShare;
use ParkShare;

-- User table
create table User (
	id bigint,
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    password varchar(200) not null,
    venmo_username varchar(50) unique not null,
	primary key(id)
);

create table UserVehicles (
	id bigint,
    user_id bigint,
    make varchar(50),
    model varchar(50),
    plate_number varchar(50),
    color varchar(50),
    primary key(id),
    foreign key(user_id) references User(id) on delete cascade
);

create table ParkingArea (
	id bigint,
    user_id bigint,
    address varchar(200),
    num_spots int,
    price_per_spot float,
    notes text,
    primary key(id),
    foreign key(user_id) references User(id) on delete cascade
);

create table ListedParking (
	id bigint,
    area_id bigint unique,
    user_id bigint,
    start_time datetime,
    end_time datetime,
    primary key(id),
    foreign key(user_id) references User(id) on delete cascade,
    foreign key(area_id) references ParkingArea(id) on delete cascade
);
    
-- ID generators
create table user_seq(
	next_val bigint
);
insert into user_seq values (1);

create table user_vehicle_seq(
	next_val bigint
);
insert into user_vehicle_seq values (1);

create table area_seq(
	next_val bigint
);
insert into area_seq values (1);

create table listed_seq(
	next_val bigint
);
insert into listed_seq values (1);