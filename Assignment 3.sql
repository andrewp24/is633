-- IS 633 Assignment 2 --
---- Andrew Peterson ----

set serveroutput on;

--Problem 1: Please create a PL/SQL procedure that given the name of a parking lot, 
    --print out types of permit than can park at that lot. [50 points]
create or replace procedure get_permit_type(l_name in lot.lname%type) as
    cursor c1 is 
        select lpt.ptype
        from lot_permit_type lpt, lot l
        where l_name = lname
        and lpt.lid = l.lid;
        
        
    permit_types_allowed lot_permit_type.ptype%type;
    begin
        open c1;
        loop
            fetch c1 into permit_types_allowed;
            exit when c1%notfound;
            
            dbms_output.put_line('permit type for allowed for the given lot name: ' || permit_types_allowed);
        end loop;
        
        if c1%rowcount = 0 then
            dbms_output.put_line('No such parking lot.');
        end if;
        
        close c1;
    end;
    
exec get_permit_type('loop outer circle');

--Problem 2: Please create a PL/SQL function that given a license plate number and state,
    --return the name of the owner. In case the owner cannot be found (exception), return a null string.  Please also write an anonymous PL/SQL program to call this function.
    --[50 points]
create or replace function get_owner(o_plate in car.plate%type, o_state in car.state%type)
    return owner.oname%type
    is
    returned_oname owner.oname%type;
    begin
        select o.oname into returned_oname
        from owner o, car c
        where o_plate = c.plate
        and o_state = c.state
        and c.oid = o.oid;
        
        return returned_oname;
    exception
        when no_data_found then
            return 'NULL';
    end;
    
declare
    owner_name owner.oname%type;
begin
    owner_name := get_owner('XXXYYYZ', 'MD'); -- Returns dr. chen
    --owner_name := get_owner('XXXYYYZ', 'PA'); --  would return NULL
    
    dbms_output.put_line(owner_name);
end; 




------ Using given code to create new tables. ------
--- sample code to create the tables
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
