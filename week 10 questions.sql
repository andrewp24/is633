-- Andrew Peterson --
-- IS633 --
-- PL_SQLpart5.ppt --

set serveroutput on;

---------- Question 1, slide 12 ----------
create or replace function get_salary_byname(e_name in emp.ename%type)
    return emp.salary%type
    is
        e_sal emp.salary%type;
    begin
        select salary into e_sal
        from emp
        where e_name = ename;
        
        return e_sal;
    exception
        when no_data_found then
            dbms_output.put_line('no employee with that name.');
            return -1;
end;

declare
    e_sal emp.salary%type;
    begin
        e_sal := get_salary_byname('jeff');
    
        if e_sal > 0 then
            dbms_output.put_line('The salary: ' || e_sal);
        else 
            dbms_output.put_line('no data found');
        end if;
    end;
    
---------- Question 2, slide 18 ----------
drop sequence did_seq; -- if already created.
create sequence did_seq start with 5;

insert into dept values (did_seq.nextval, 'testing');

select did, dname
from dept;

