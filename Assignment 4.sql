-- IS 633 Assignment 2 --
---- Andrew Peterson ----

set serveroutput on;

--Problem 1: Please create a trigger on ticket table such that the trigger will be executed when the ticket's status has been 
    --changed from unpaid (1) to paid (2). Please print out a message saying ticket Y is paid on Z, where Y is ticket ID, and 
    --Z is the payment date. Please test your trigger. [100 points]
create or replace trigger status_change_check
    after update on ticket
        for each row when (new.status != old.status and new.status = 2) -- checks if there was a change, and status changed to 2
begin
    dbms_output.put_line('Ticket ' || :old.tid || ' was paid on ' || :new.paydate || '.');
end;

-- will change a ticket that was unpaid to paid. 
update ticket
set status = 2, paydate = sysdate
where tid = 3;

-- will effective reset the test above.
update ticket
set status = 1, paydate = NULL
where tid = 3