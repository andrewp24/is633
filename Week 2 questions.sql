
-- Andrew Peterson --
-- IS633 --
-- sqlpart1.ppt --

---------- Question 1, slide 18 ----------
create table dept (
	did int,
	dname varchar(30),
	primary key (did)
	);
    
create table emp (
	eid int,
	ename varchar(30),
	did int, -- department id
	hiredate date,
	salary number,
	primary key (eid),
	foreign key (did) references dept(did));
    
Drop table emp; --- needed if you have dept and emp tables created
Drop table dept;

---------- Question 2, slides 25-26 ----------
create table proj (
    pid int,
    pname varchar(30),
    startdate date,
    enddate date,
    primary key (pid)
    );
    
create table emp_proj (
    eid,
    pid,
    foreign key (eid) references emp(eid),
    foreign key (pid) references proj(pid)
    );
    
drop table proj;
drop table emp_proj;

---------- Question 3, slide 33 ----------
insert into dept values (1, 'IT');
insert into dept values (2, 'HR');
insert into emp values (1,'jeff',1,date '2005-1-1',70000);
insert into emp values (2,'suzan',2,date '2005-6-1',50000);
insert into emp values (3,'bob',1,date '2000-1-1',90000);
insert into emp values (4,'steve',1,date '2006-1-1',60000);

---------- Question 4, slide 38 ----------
select * from emp where ename = 'jeff';
update emp set salary = salary - 1000 where ename = 'jeff' and eid=1;
select * from emp where ename = 'jeff';

---------- Question 5, slide 41 ----------
select * from emp;
delete from emp where hiredate > date '2006-6-1';
select * from emp;

---------- Question 6, slide 54 ----------
select * from emp;
select * from emp where salary >= 60000;
select * from emp where ename = 'jeff';
select * from emp where salary >= 60000 and hiredate > date '2005-1-1';

---------- Question 7, slide 56 ----------
insert into proj values (1, 'umbc student db', date '2017-1-1', null);
insert into proj values (2, 'umbc library', date '2017-2-1', date '2017-7-1');
insert into emp_proj values (1,2);
insert into emp_proj values (3,2);
insert into emp_proj values (1,1);
insert into emp_proj values (4,1);
insert into emp_proj values (2,1);

---------- Question 8, slide 57 ----------
select * from proj;
select * from emp_proj;
select * from proj where startdate between date '2017-1-1' and date '2017-1-31';
select * from proj where startdate between date '2017-2-1' and date '2017-2-28' and enddate between date '2017-7-1' and date '2017-7-31'