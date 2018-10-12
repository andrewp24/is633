-- Andrew Peterson --
-- IS633 --
-- sqlpart2.ppt --

---------- Question 1, slide 8 ----------
select ename from emp
where ename like '%e%';

---------- Question 2, slide 10 ----------
select distinct did from emp;

---------- Question 3, slide 15 ----------
select count(dname) from dept;

select min(salary) from emp;

---------- Question 4, slide 17 ----------
select min(salary) from emp
where hiredate > date'2005-1-1';

---------- Question 5, slide 28 ----------
select max(salary), did from emp group by did;

---------- Question 6, slide 35 ----------
select avg(salary), did from emp group by did having avg(salary) < 60000;

---------- Question 7, slide 42 ----------
select ename, eid, salary, did from emp order by salary desc; 