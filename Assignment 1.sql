-- IS 633 Assignment 1 --
---- Andrew Peterson ----

--commit changes--
commit;

----- drop tables ------
drop table permit;
drop table lot_permit_type;
drop table ticket;
drop table permit_type;
drop table lot;
drop table ticket_type;
drop table car;
drop table owner;

----- create/drop sequences ------
drop sequence owner_seq;
drop sequence permit_seq;
drop sequence car_seq;
drop sequence lot_seq;
drop sequence ticket_type_seq;
drop sequence ticket_seq;

create sequence owner_seq start with 1 increment by 1;
create sequence permit_seq start with 1 increment by 1 maxvalue 115; -- total spots in the lots
create sequence car_seq start with 1 increment by 1;
create sequence lot_seq start with 1 increment by 1;
create sequence ticket_type_seq start with 1 increment by 1;
create sequence ticket_seq start with 1 increment by 1;

--Problem 1--
create table owner(
oid integer,
oname varchar(30),
otype integer,
email varchar(32),
primary key (oid)
);

create table permit_type(
ptype integer,
description varchar(50),
price number,
otype integer,
primary key (ptype) 
);

create table permit(
pid integer,
ptype, --references permit_type table
oid, --references owner table
expiredate date,
foreign key (ptype) references permit_type(ptype),
foreign key (oid) references owner(oid),
primary key (pid)
);

create table car(
cid integer,
oid, --references owner table
make varchar(30),
model varchar(30),
color varchar(30),
plate varchar(8),
state varchar(14),
primary key (cid),
foreign key (oid) references owner(oid)
);

create table lot(
lid integer,
lname varchar(30),
capacity integer,
primary key (lid)
);

create table lot_permit_type(
lid, --references lot table
ptype, --references permit_type table
foreign key (lid) references lot(lid),
foreign key (ptype) references permit_type(ptype)
);

create table ticket_type(
ttype integer,
tdescription varchar(50),
amount number,
primary key (ttype)
);

create table ticket (
tid integer,
cid, --references car table
lid, --references lot table
ttype, --references ticket_type table
status integer,
tdate date,
paydate date,
note varchar(50),
foreign key (cid) references car(cid),
foreign key (lid) references lot(lid),
foreign key (ttype) references ticket_type(ttype)
);

--Problem 2--
insert into owner values (owner_seq.nextval,'John Smith',1,'jsmith@umbc.edu'); --on campus oid 1
insert into owner values (owner_seq.nextval,'Leo Doe',1,'ldoe2@umbc.edu'); --off campus oid 2
insert into owner values (owner_seq.nextval,'Frank West',2,'west@umbc.edu'); --oid 3

insert into permit_type values (3,'Faculty/Staff are allowed to park with this.',50.00,2);
insert into permit_type values (1,'Commuting Students can purchase this permit',75.00,1);
insert into permit_type values (2,'Students who live on campus can buy this permit',60.00,1);

insert into permit values (permit_seq.nextval,2,1,date '2018-12-30'); -- pid 1
insert into permit values (permit_seq.nextval,1,2,date '2018-12-29'); -- pid 2
insert into permit values (permit_seq.nextval,3,3,date '2018-12-20'); -- pid 3

insert into car values (car_seq.nextval,2,'Honda','Civic','Black','ND453214','Maryland'); -- cid 1
insert into car values (car_seq.nextval,1,'Toyota','Prius','Blue','AB986532','Maryland'); -- cid 2
insert into car values (car_seq.nextval,3,'Tesla','Model S','White','HF256134','Maryland'); -- cid 3

insert into lot values (lot_seq.nextval,'Parking lot 1',25); -- lid 1
insert into lot values (lot_seq.nextval,'Parking lot 2',30); -- lid 2
insert into lot values (lot_seq.nextval,'Parking lot 3',45); -- lid 3

insert into lot_permit_type values (1,1); --off campus
insert into lot_permit_type values (2,2); --on campus
insert into lot_permit_type values (3,3); --faculty

insert into ticket_type values (ticket_type_seq.nextval,'Double Parking',10); -- ttype 1
insert into ticket_type values (ticket_type_seq.nextval,'Permit not displayed in the car',15); --ttype 2
insert into ticket_type values (ticket_type_seq.nextval,'Parked in the wrong lot',25); -- ttype 3

insert into ticket values (ticket_seq.nextval,1,3,3,2,date '2018-9-19', date '2018-9-22','student parked in the faculty lot.'); --on campus student parked in faculty parking tid 1
insert into ticket values (ticket_seq.nextval,2,2,2,2,date '2018-9-20', date '2018-9-21','no permit was visible.'); --off campus student parked in off campus parking, but no permit visible tid 2
insert into ticket values (ticket_seq.nextval,3,3,1,1,date '2018-9-21', NULL,'faculty parked took two spaces.'); --faculty parked in correct parking, but double parked. tid 3

--Problem 3--

--inserts to make these tasks work
insert into owner values (owner_seq.nextval,'Dr. Chen',2,'chen@umbc.edu'); --oid 4
insert into permit values (permit_seq.nextval,3,4,date '2018-12-20'); -- pid 4
insert into car values (car_seq.nextval,4,'Toyota','Prius','Gray','XXXYYYZ','Maryland'); -- cid 4
insert into ticket values (ticket_seq.nextval,4,3,1,1,date '2018-9-15', NULL,'faculty parked took two spaces.'); --faculty parked in correct parking, but double parked. tid 4
insert into ticket values (ticket_seq.nextval,4,2,3,1,date '2018-9-14', NULL,'faculty parked in the wrong lot.'); --faculty parked in correct parking, but double parked. tid 5
insert into ticket values (ticket_seq.nextval,2,1,3,2,date '2018-8-13', date '2018-8-16','student parked in the wrong lot.'); --student parked in wrong lot. tid 6
insert into ticket values (ticket_seq.nextval,2,1,3,2,date '2018-8-14', date '2018-8-16','student parked in the wrong lot.'); --student parked in wrong lot. tid 7
insert into lot values (lot_seq.nextval,'Parking lot 4',10); -- lid 4
insert into lot values (lot_seq.nextval,'Parking lot 5',5); -- lid 5
insert into lot_permit_type values (4,2);
insert into lot_permit_type values (5,1);

-- task 1
select cid from car where plate='XXXYYYZ'; -- should be cid 4

--task 2
select l.lname
from lot l, lot_permit_type lpt 
where lpt.lid = l.lid
and lpt.ptype=1; -- should output parkling lot 1 and parking lot 5

--task 3 return permit type and number of permits for each type, ptype 1 is off campus, ptype 2 is for oncampus students, and ptype3 is for faculty/staff
select ptype ,count(*) as "# of each permit type"
from permit
group by ptype;

--task 4, returns the ptype 3 which is for faculty/staff
select ptype
from permit
group by ptype
having count(*) >= 2;

--task 5, returns the total amount of unpaid parking ticket for dr chen. there are two unpaid tickets.
select count(*)
from ticket t, car c, owner o
where c.cid = t.cid -- both are 4
and c.oid = o.oid --both would be 4
and o.oname = 'Dr. Chen' -- should make oid 4
and t.status = 1;

--task 6 returns the owner John Smith. He has two tickets in August 2018
select o.oname
from owner o, ticket t, car c
where o.oid = c.oid
and c.cid = t.cid
and t.tdate between date '2018-08-01' and date '2018-08-31'
group by o.oname
having count(*) > 1;