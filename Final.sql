-- IS 633 Final Exam --
---- Andrew Peterson ----
-- The initial database creation code will be at the bottom. The problems will start at the top --

set serveroutput on;

-------------------------------------- Problem 1 ------------------------------------------|
--Please write a PL/SQL procedure to print out the location names and event                |
--names of events that a participant has registered. The name of the participant           |
--is the input parameter. Please do not include events that are canceled (event status=2)  |
--or registration that is canceled (registration status=2).  [15 points]                   |
-------------------------------------------------------------------------------------------|
create or replace procedure get_location_event_names(participant_name in participant.pname%type) as
    cursor c1 is 
        select e.ename, l.lname
        from event e, registration r, location l, participant p
        where participant_name = p.pname
        and r.status != 2
        and e.status != 2
        and p.pid = r.pid
        and r.eid = e.eid
        and e.lid = l.lid;
        
        
    event_name event.ename%type;
    loc_name location.lname%type;
    begin
        dbms_output.put_line('------------------------ Searching for ' || participant_name || ' ------------------------');
        open c1;
        loop
            fetch c1 into event_name, loc_name;
            exit when c1%notfound;
            
            dbms_output.put_line('Event Name: ' || event_name || ' |||  Location name: ' || loc_name);
        end loop;
        
        if c1%rowcount = 0 then
            dbms_output.put_line(participant_name || ' is not a participant or has no currently scheduled events.');
        end if;
        
        close c1;
    end;
    
exec get_location_event_names('Andrew');  -- will not be in db. rowcount == 0  
exec get_location_event_names('Jeff');  -- shows department seminar, ite 459  
exec get_location_event_names('Grace');  -- shows graduate commencement, event center 
exec get_location_event_names('Ethan');  -- shows ellen dissertation defenes, ite 459  
exec get_location_event_names('Susan');  -- shows department seminar, ite 459. graduate comm, event center. dissertation, ite 459




-------------------------------------- Problem 2 ------------------------------------------|
--Please write a PL/SQL function to return the number of participants registered for an    |
--event. The name of the event is the input parameter. Please first check whether there is |
--an event matching the given event name. If not, please print 'The event does not exist'  | 
--and return -1. Otherwise, return the number of participants. Please do not include those |
--who canceled registration (status = 2).                                                  |
--                                                                                         |
--Please also write an anonymous program to call the function with some sample event name  |
--and print out the returned count if the function returns normally. [15 points]           |
-------------------------------------------------------------------------------------------|
create or replace function get_num(event_name in event.ename%type)
    return number
    is
    counter integer := 0;
    
    cursor c1 is
        select p.pname
        from event e, registration r, participant p
        where event_name = e.ename
        and r.status != 2
        and p.pid = r.pid
        and r.eid = e.eid;
    
    throwaway c1%rowtype;
    is_an_event integer; -- if is a case where there are no participants, yet the event exists, this will stop it
                         -- from saying it does not exist 
    
    begin
        
        -- first check whether there is an event matching the given event name.. 
        --will auto pass the rowcount checker if there is a real event 
        select count(ename) into is_an_event
        from event
        where event.ename = event_name;
        --dbms_output.put_line(is_an_event); -- if 0, not an event. if else, an event
        
        if is_an_event = 0 then -- there is no real event, so returns -1 and says it doesn't exist. skips the cursor
            dbms_output.put_line('The event does not exist.');
            return -1;
        end if;
    
        open c1;
        loop
            fetch c1 into throwaway;
            exit when c1%notfound;
            counter := counter + 1;
        end loop;
        
        if c1%rowcount = 0 then -- means there are no participants or other missing value, yet there is an event.
            return 0; 
        end if;
        
        return counter; -- returns the amount of participants for the event. has to be after each check.
        close c1;
    end;
    
declare
    reg_p_num number;
begin
    --reg_p_num := get_num('Department seminar'); -- Returns 2
    --reg_p_num := get_num('2018 Graduate Commencement'); -- Returns 2
    --reg_p_num := get_num('Ellen dissertation defenes'); -- Returns 2
    reg_p_num := get_num('Movie night'); -- Returns 0 because while there is an event, there is no-one registered to it.
    --reg_p_num := get_num('Fake'); -- Returns -1 because there is no event
    
    if reg_p_num != -1 then
        dbms_output.put_line('There are ' || reg_p_num || ' registered.');
    end if;
end; 




-------------------------------------- Problem 3 ------------------------------------------|
--Create a trigger on the event table (on page 2) satisfying the following requirements:   |
--                                                                                         |
--1) The trigger is executed when an event's location has changed.                         |
--2) The trigger prints out a message 'Location of event X is changed to Y' where X is the |
--name of the event and Y is the new location name. [15 points]                            |
-------------------------------------------------------------------------------------------|
create or replace trigger event_location_change_check
    after update on event
        for each row when (new.lid != old.lid) -- checks if there was a change in locations
    declare
        loc_name location.lname%type;
    begin
        select lname into loc_name
        from location
        where :new.lid = location.lid;
    
        dbms_output.put_line('Location of ' || :old.ename || ' is changed to ' || loc_name || '.');
end;

update event
set lid = 3
--set lid = 1 --uncomment this to set back to original.
where eid = 1;


---------------------------------- Database Creation --------------------------------------

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

insert into event values(4, 2,'Movie night', null, 
timestamp '2018-12-16 20:00:00.00', interval '2:30' hour to minute, 2);


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

insert into registration values(1, 1, 1);
insert into registration values(4, 1, 1);

insert into registration values(2, 2, 1);
insert into registration values(3, 2, 2);
insert into registration values(4, 2, 1);

insert into registration values(3, 3, 1);
insert into registration values(4, 3, 1); 


commit;
