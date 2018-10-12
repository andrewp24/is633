-- IS 633 Assignment 2 --
---- Andrew Peterson ----

------ Using given code to create new tables. ------
drop table ticket cascade constraints;
drop table lot_permit_type cascade constraints;
drop table lot cascade constraints;
drop table car cascade constraints;
drop table permit cascade constraints;
drop table ticket_type cascade constraints;
drop table permit_type cascade constraints;
drop table owner cascade constraints;

create table owner
(oid int, --- owner id 
oname varchar(50), --- owner name
otype int, --- owner type, 1=student, 2=faculty/staff
email varchar(50), --- email 
primary key (oid));

insert into owner values(1, 'Dr. Chen', 2, 'chen@umbc.edu');
insert into owner values(2, 'Dr. Miller', 2, 'miller@umbc.edu');

insert into owner values(3, 'Ethan', 1, 'ethan@umbc.edu');
insert into owner values(4, 'Carla', 1, 'carlar@umbc.edu');
insert into owner values(5, 'Ella', 1, 'Ella@umbc.edu');

create table permit_type
(ptype int, --- permit type
description varchar(20), --- description 
price number, --- price of this type of permit
otype int, -- owner type, 1=student, 2=faculty
primary key (ptype));

insert into permit_type values(1, 'commuter student', 100,1);
insert into permit_type values(2, 'resident student', 150, 1);
insert into permit_type values(3, 'faculty/staff', 200, 2);
insert into permit_type values(4, 'gated faculty/staff', 300, 2);

create table permit
(pid int, --- permit id
oid int, --- owner id
ptype int, --- permit type, 
expiredate date, --- expire date
primary key (pid),
foreign key(oid) references owner);

insert into permit values(1,1,4,date '2019-9-1');
insert into permit values(2,2,3,date '2019-9-1');
insert into permit values(3,3,1,date '2019-9-1');
insert into permit values(4,4,2,date '2019-9-1');
-- expired
insert into permit values(5,5,1, date '2018-9-1');
create table car
(cid int, --- car id
oid int, -- owner id 
make varchar(20), -- make of car
model varchar(20), --- model
color varchar(20), --- color of car
plate varchar(20), --- plate #
state varchar(20), --- state
primary key(cid),
foreign key(oid) references owner);

insert into car values(1, 1, 'Honda','CRV','Silver','XXXYYYZ','MD');
insert into car values(2, 1, 'Toyota','Camry','Silver','123XYYYZ','MD');
insert into car values(3, 2, 'Honda','Civic','Black','99XYYYZ','MD');
insert into car values(4, 3, 'Ford','Mustang','Blue','87XYYYZ','VA');
insert into car values(5, 4, 'Toyota','Corolla','Red','37XYYYZ','VA');

create table lot
(lid int, --- parking lot id
lname varchar(50), --- parking lot name 
capacity int, --- number of spaces
primary key (lid)
);

insert into lot values (1, 'lot near commons', 150);
insert into lot values (8, 'gated lot near police station', 200);
insert into lot values (21, 'walker lot', 200);
insert into lot values (30, 'loop inner circle', 300);
insert into lot values (31, 'loop outer circle', 300);

create table lot_permit_type
(lid int, -- parking lot id
ptype int, --- permit type allowed in this lot
primary key(lid, ptype),
foreign key (lid) references lot, 
foreign key (ptype) references permit_type);

-- lot 1 for commuter and faculty
insert into lot_permit_type values (1, 1);
insert into lot_permit_type values (1, 3);
-- lot 8 gated 
insert into lot_permit_type values (8, 4);
--- lot 21 for resident 
insert into lot_permit_type values (21, 2);
-- 30 for faculty
insert into lot_permit_type values (30, 3);
-- 31 for student
insert into lot_permit_type values (31, 1);
insert into lot_permit_type values (31, 2);

create table ticket_type
(ttype int, --- ticket type id
tdescription varchar(50), --- decription of ticket type
amount number, --- amount of fine 
primary key(ttype));

insert into ticket_type values(1, 'permit not on display', 20);
insert into ticket_type values(2, 'parking at wrong lot', 10);
insert into ticket_type values(3, 'double parking', 20);

create table ticket
(tid int, --- parking ticket id
cid int, --- the car violated parking rule
lid int, --- lot where violation occurs
ttype int, -- ticket type
status int, --- 1 issued, 2 paid, 
tdate date, --- ticket issue date
paydate date, --- date it is paid
note varchar(50), --- notes about the violation
primary key(tid), 
foreign key(cid) references car,
foreign key (ttype) references ticket_type,
foreign key (lid) references lot
);

-- owner 1 missing permit
insert into ticket values(1, 1, 8, 1, 1, date '2018-8-1', null,'permit missing');
insert into ticket values(4, 1, 21, 2, 2, date '2018-9-1', date '2018-9-2','wrong place');

-- owner 3 other 2 types of violation 
insert into ticket values(2, 3, 21, 2, 1, date '2018-8-21', null,'wrong lot');
insert into ticket values(3, 3, 1, 3, 1, date '2018-8-1', null,'double parking');

-- owner 2 has one ticket

insert into ticket values(5, 3, 1, 1, 1, date '2018-8-22', null, 'permit missing');
commit;

----------------------- Start of my PLSQL code  -----------------------

set serveroutput on;

------------ Problem 1 ------------
declare
    total int := 0;
begin
    for i in 1..10 loop
        if i mod 2 > 0 then
            total := total + i;
        end if;
    end loop;
    dbms_output.put_line('the sum of 1,3,5,7,9 is: ' || total); --should equal 25.
end;

------------ Problem 2 ------------
declare
    ic_oname varchar2(50);
begin
    select o.oname into ic_oname
    from owner o, car c
    where o.oid = c.oid
    and c.state = 'MD'
    and c.plate = 'XXXYYYZ';
    
    dbms_output.put_line('the owner is ' || ic_oname); --should output Dr. Chen
    
    exception
        when no_data_found then
            dbms_output.put_line('could not find any rows');
        when too_many_rows then
            dbms_output.put_line('too many rows for implicit cursor');
end;

------------ Problem 3 ------------

--look at oid 4 (carla) want to know each parking lot name that she can park. 
--she has permit type 2. look at lot_permit_type, ptype of 2.
--she can park in parking lot id 31 and lot id 21. look in table lot for name based on lot id.

declare
    cursor c1 is
        select l.lname
        from lot l, lot_permit_type lpt, permit p, owner o
        where l.lid = lpt.lid
        and lpt.ptype = p.ptype
        and p.oid = o.oid
        and o.oname = 'Carla';
    ec_oname owner.oname%type;
begin
    open c1;
    loop
        fetch c1 into ec_oname;
        exit when c1%NOTFOUND;
        dbms_output.put_line('Carla can park in this parking lot: ' || ec_oname);
    end loop;
    close c1;
end;