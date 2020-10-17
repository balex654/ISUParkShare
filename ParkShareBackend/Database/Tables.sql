drop database if exists ParkShare;
create database ParkShare;
use ParkShare;

-- User table
create table User (
	id bigint,
    username varchar(50) unique,
	primary key(id));
    
-- ID generators
create table user_seq(
	next_val bigint
);
insert into user_seq values (1);