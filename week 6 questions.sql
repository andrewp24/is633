-- Andrew Peterson --
-- IS633 --
-- PL_SQLpart2.ppt --

set serveroutput on;

---------- Question 1, slide 5-6 ----------
declare
    d_name dept.dname%type;
begin
    d_name := 'service';
    dbms_output.put_line(d_name);
end;    

---------- Question 2, slide 10 ----------
declare
    new_emp emp%rowtype;
begin
    new_emp.ename := 'john';
    dbms_output.put_line(new_emp.ename);
end;

---------- Question 3, slide 14 ----------
declare
    bignum int;
begin
    bignum := 2**10;
    dbms_output.put_line(bignum);
end;

---------- Question 4, slide 22 ----------
declare
    today date :=sysdate;
begin
    if today between date '2006-09-01' and date '2006-09-30' then
        dbms_output.put_line('Today is in September 2006');
    elsif today < date '2006-09-01' then
        dbms_output.put_line('Today is before September 2006');
    else
        dbms_output.put_line('Today is after September 2006');
    end if;
end;

---------- Question 5, slide 34 ----------
declare
   product int;
   i int;
begin
    product := 1;
    i := 1;
    loop
        product := product * i;
        i := i + 1;
        exit when i > 4;
    end loop;
    dbms_output.put_line('the product of 1,2,3,4 is: ' || product);
end;

---------- Question 6, slide 40 ----------
declare
    product int := 1;
    top_val int := 4;
begin
    for i in 1..top_val loop
        product := product * i;
    end loop;
    dbms_output.put_line('the product of 1,2,3,4 using a for loop: ' || product);
end;

---------- Question 7, slide 41 ----------
declare
    total int := 0;
begin
    for i in 1..100 loop
        total := total + i**2;
    end loop;
    dbms_output.put_line('the total: ' || total);
end;    