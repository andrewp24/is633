-- Andrew Peterson --
-- IS633 --
-- PL_SQLpart1.ppt --

set serveroutput on;

---------- Question 1, slide 19 ----------
declare
   firstProgram varchar(50) := 'This is my first PL/SQL program';
begin
    DBMS_OUTPUT.PUT_LINE(firstProgram);
END;

---------- Question 2, slide 26 ----------
declare
   secondProgram varchar(50) := 'This is my second PL/SQL program';
begin
    DBMS_OUTPUT.PUT_LINE(secondProgram);
END;

---------- Question 3, slide 32 ----------
declare
    current_time timestamp;
begin
    current_time := systimestamp;
    dbms_output.put_line(current_time);
    dbms_output.put_line(current_time + interval '7' day);
end;    