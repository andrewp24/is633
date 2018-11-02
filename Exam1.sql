---- Andrew Peterson ----
-- IS 633 -- 
-- Exam 1 --

set serveroutput on;

--- an event management database
drop table registration cascade constraint;
drop table participant cascade constraint;
drop table event cascade constraints;
drop table organizer cascade constraints;
drop table location cascade constraints;

create table location 
(lid int, ---- location id
lname varchar(50), --- location name
capacity int, --- capacity of the location 
primary key (lid));

insert into location values (1, 'ITE 459', 40);
insert into location values (2, 'UC ballroom', 300);
insert into location values (3, 'Event Center',3000);

create table organizer
(oid int, --- organizer id
oname varchar(50), --- organizer name 
oemail varchar(50), --- organizer's email
otype int, --- 1 university, 2 department, 3 student 
primary key(oid));

insert into organizer 
values (1, 'Dr. Chen', 'ccc@umbc.edu', 2);

insert into organizer 
values (2, 'Ms. Morgan', 'mmm@umbc.edu', 1);

insert into organizer
values (3, 'Ellen', 'eee@umbc.edu',3);

create table event
(eid int, --- event id 
oid int, --- organizer id 
ename varchar(50), --- event name 
lid int, --- location id 
start_time timestamp, -- start time of event
duration interval day to second, --- duration of event, 
status int, --- 1 scheduled, 2 canceled, 3 finished 
primary key(eid), 
foreign key (lid) references location,
foreign key (oid) references organizer);

insert into event values (1, 1,'Department seminar', 1, timestamp '2018-9-6 10:00:00.00',interval '2' hour, 3);

insert into event values(2,2, '2018 Graduate Commencement', 3, 
timestamp '2018-12-19 10:00:00.00', interval '2' hour, 1);

insert into event values(3, 3,'Ellen dissertation defenes', 1, 
timestamp '2018-11-16 14:00:00.00', interval '2:30' hour to minute, 1);

insert into event values(4, 2,'Teaching Seminar', 2, 
timestamp '2018-11-10 12:00:00.00', interval '1:30' hour to minute, 2);

create table participant
(pid int, --- participant id
pname varchar(50), --- participant name 
pemail varchar(50), --- participant email
primary key(pid));

insert into participant values(1, 'Jeff', 'jeff@gmail.com');
insert into participant values(2, 'Grace', 'grace@umbc.edu');
insert into participant values(3, 'Ethan', 'ethan@umbc.edu');
insert into participant values(4, 'Susan','susan@umbc.edu');

create table registration
(pid int, --- participant id
eid int, --- event id
status int,  --- 1 registered, 2 canceled
primary key(pid, eid),
foreign key(pid) references participant,
foreign key(eid) references event);

insert into registration values(1, 1, 1); -- jeff department seminar registered
--insert into registration values(4, 1, 1);

insert into registration values(2, 2, 1); -- grace graduate comm - registered
insert into registration values(3, 2, 2); -- ethan gradate comm - canceled
insert into registration values(4, 2, 1); -- susan gradate comm - registered

insert into registration values(3, 3, 1); -- ethan ellen dissertation defense registered
insert into registration values(4, 3, 2); -- susan ellen dissertation defense canceled

insert into registration values(1,4,2); -- jeff teaching seminar - canceled
insert into registration values(3,4,2); -- ethan teaching seminar - canceled

commit;



----- Problem 1 -----

-- Task 1: return start time and end time of 2018 Graduate Commencement. Hint: end time = start_time + duration
select start_time as "Start Time", (start_time + duration) as "End Time" 
from event
where ename='2018 Graduate Commencement';

-- Task 2: for each event, return the number of participants registered for that event and the event id. Please do not include canceled registration (registration.status=2).
select eid, count(pid)
from registration
where status != 2
group by eid; -- should be eid 1 = 1 , eid 2 = 2, eid 3 = 1, eid 4 = 0

-- Task 3: return ids of events with at least two participants. Please do not include canceled registration (registration.status=2).
select eid
from registration
where status !=2
group by eid 
having count(pid) >= 2; -- should be eid 2

-- Task 4: return name and email of the organizer of the event 2018 Graduate Commencement.
select o.oname, o.oemail
from organizer o, event e
where e.ename = '2018 Graduate Commencement' 
and o.oid = e.oid; -- should be Ms. Morgan, mmm@umbc.edu

-- Task 5: Return location names and event names of events that Ethan (a participant) has registered. Please do not include events that are canceled (event.status=2) or registration that is canceled (registration.status=2).
select l.lname as "Location Name", e.ename as "Event Names"
from location l, event e, registration r, participant p
where p.pname = 'Ethan'
and e.status != 2 and r.status !=2 and l.lid = e.lid and e.eid = r.eid and r.pid = p.pid; -- he canceled teaching and grad commencement. only ellen diss left

-- Task 6: Return names of locations that have at least two events scheduled in 2018. Please do not count canceled events (event.status=2).
select l.lname as "Location Name"
from location l, event e
where e.status!=2
and e.start_time between date '2018-01-01' and date '2018-12-31' and l.lid = e.lid
group by l.lname
having count(l.lname)>=2; -- should be location 1 --> ITE 459

-- Task 7: Cancel all events held at ITE 459 in November 2018.  Hint: update status of event table. You also need to use a subquery in the where clause to return the lid of location with lname = 'ITE 459'.
update event
set status = 2
where lid in (
    select lid
    from location
    where lname='ITE 459'
)
and start_time between date '2018-11-01' and date '2018-11-30'; -- will change ellen dissertation defense to status = 2

--Problem 2--
--[15 points] Please write an anonymous PL/SQL program to print out the first 10 numbers of Lazy Caterer's sequence.  
--Lazy caterer's sequence has the formula F(1)=2, F(n)=F(n-1)+n. 
--E.g., F(2) = F(1) + 2 = 2+2=4; F(3) = F(2)+3 = 4+3=7
--Please use a loop. The numbers you print out should look like
--2
--4
--7
--...
--56
--
--Hint: you can define a variable f2 for F(n), another variable f1 for F(n-1), and a variable i for n. Think of how to compute f2 using f1 and i and how to update f1 and i in the loop.
declare
    i int; --n
    f1 int; --F(n-1)
    f2 int; --F(n) -> F(n) = f1+i
begin
    i := 0;
    f2:=1;
    for n in 1..10 loop
        -- simpler: (n*(n+1))/2+1;
        f1 := f2;
        i := n;
        f2 := f1+i;
        dbms_output.put_line('f(' || n || ') = ' || f2);
    end loop;
end;    
    
--Problem 3--
--[15 points] Please write an anonymous PL/SQL program to print out the email of organizer of the event 'Department seminar' as well as start_time and end time of the event. 
--Please use implicit cursor and handle exception. You will lose 10 points if you use an explicit cursor. 
--Hint: The end time of an event equals start_time + duration.   --will be dr chen
declare
    new_oemail organizer.oemail%type;
    new_start_time event.start_time%type;
    new_end_time event.start_time%type;
    new_duration event.duration%type;
    
begin
    select o.oemail, e.start_time, e.duration into new_oemail, new_start_time, new_duration
    from organizer o, event e
    where o.oid = e.oid
    and e.ename = 'Department seminar';
    
    new_end_time := new_start_time + new_duration; -- adding the duration to the start time.
    
    dbms_output.put_line('Email address of the organizer for the department seminar: ' || new_oemail || '. The start time was: ' || new_start_time || '. The end time was: ' || new_end_time || '.'); 
end;

--Problem 4: [20 points] Please write an anonymous PL/SQL program to print out the names and emails of participants who registered for the event '2018 Graduate Commencement'. 
--Please do not include those who canceled their registration (i.e., those with registration.status =2).
-- will need info from participant, event, and registration, there will be two users. one canceled.
declare
    cursor c1 is
        select p.*
        from participant p, event e, registration r
        where p.pid = r.pid
        and r.eid = e.eid
        and e.ename = '2018 Graduate Commencement'
        and r.status != 2;
    new_partic participant%rowtype;
begin
    open c1;
    loop
        fetch c1 into new_partic;
        exit when c1%NOTFOUND;
        dbms_output.put_line('Participant that registered for the 2018 Grade Commencement and did not cancel: ' || new_partic.pname ||  '. Their email: ' || new_partic.pemail);
    end loop;
    if c1%rowcount = 0 then
        dbms_output.put_line('no participants found.');
    end if;
    close c1;
end;
