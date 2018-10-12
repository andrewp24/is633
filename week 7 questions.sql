-- Andrew Peterson --
-- IS633 --
-- PL_SQLpart3.ppt --

set serveroutput on;

---------- Question 1, slide 8 ----------
declare
    new_dept dept%rowtype;
begin
    new_dept.did := 4;
    new_dept.dname := 'accounting';
    insert into dept values new_dept;
end;

select dept.* from dept;

---------- Question 2, slide 15 ----------
declare
    e_id number;
    e_salary number;
begin
    select eid, salary into e_id, e_salary
    from emp
    where eid = 1;
    
    dbms_output.put_line('salary of eid 1: $' || e_salary);
end;

---------- Question 3, slide 23 ----------
declare
    e_id number;
    e_salary number;
begin
    select eid, salary into e_id, e_salary
    from emp
    where eid = 5;
    
    dbms_output.put_line('salary of eid 5: $' || e_salary);
    
    exception
        when no_data_found then
            dbms_output.put_line('could not find any rows');
        when too_many_rows then
            dbms_output.put_line('too many rows for implicit cursor');
end;

---------- Question 4, slide 32 ----------
declare
    cursor c1 is
        select ename
        from emp, dept
        where emp.did = dept.did
        and dept.dname = 'IT';
    e_name emp.ename%type;
begin
    open c1;
    loop
        fetch c1 into e_name;
        exit when c1%NOTFOUND;
        dbms_output.put_line('employee name: ' || e_name || ' works in the IT department.' );
    end loop;
    close c1;
end;

---------- Question 5, slide 49 ----------
declare
    cursor c1 is
        select p.pname
        from emp e, emp_proj ep, proj p 
        where e.eid = ep.eid
        and ep.pid = p.pid
        and e.ename = 'jeff';
    p_name proj.pname%type;
begin
    open c1;
    loop
        fetch c1 into p_name;
        exit when c1%NOTFOUND;
        dbms_output.put_line('jeff is working on: ' || p_name);
    end loop;
    if c1%rowcount = 0 then
        dbms_output.put_line('employee not found.');
    end if;    
    close c1;
end;