-- Andrew Peterson --
-- IS633 --
-- trigger.ppt --

set serveroutput on;

---------- Question 1, slide 15 ----------
create or replace trigger audit_emp
    after insert or update or delete on emp
begin
    dbms_output.put_line('time of change: ' || systimestamp || '. user that made change: ' || user);
end;

insert into emp values(6,'andrew1',1,sysdate, 54321);

---------- Question 2, slide 35 ----------
create or replace trigger dept_change_check
    after update on emp
        for each row when (new.did != old.did)
begin
    dbms_output.put_line(:new.ename || ' changed from did ' || :old.did || ' to did: ' || :new.did);
end;

update emp
set did = 2
where eid = 6;

---------- Question 3, slide 38 ----------
create or replace trigger changed_dept
    after update on emp 
        for each row when (new.did != old.did)
declare
    y dept.dname%type; -- old dept name
    z dept.dname%type; --new dept name
begin
    select dname into y from dept where did = :old.did;
    select dname into z from dept where did = :new.did;
    
    dbms_output.put_line(:new.ename || ' changed from the ' || y || ' dept to the ' || z || ' dept.');
end;

update emp
set did = 1
where eid = 6;