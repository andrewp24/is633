-- Andrew Peterson --
-- IS633 --
-- sqlpart3.ppt --

-- creating the necessary info for the questions.
drop table order_line;
drop table orders;
drop table product;
drop table customer;

create table customer(
cid integer,
cname varchar(50),
primary key (cid));

create table product(
pid integer,
pname varchar(50),
primary key (pid));

create table orders(
oid integer,
cid integer,
primary key (oid),
foreign key (cid) references customer(cid));

create table order_line(
oid integer,
pid integer,
quantity integer,
primary key (oid, pid),
foreign key (oid) references orders(oid),
foreign key (pid) references product(pid));

insert into customer values(1,'John');
insert into customer values(2,'Alice');

insert into product values (1,'TV');
insert into product values (2,'VCR');
insert into product values (3,'DVD Player');

insert into orders values (1,1);
insert into orders values (2,1);

insert into order_line values(1,1,1);
insert into order_line values(1,2,1);
insert into order_line values(2,1,1);

commit;

---------- Question 1, slide 14 ----------
select pname
from product, order_line
where product.pid = order_line.pid
and order_line.oid = 2;

---------- Question 2, slide 20 ----------
select pname
from product P, order_line OL
where P.pid = OL.pid
and OL.oid = 2;

---------- Question 3, slide 25 ----------
select pname, oid
from product p, order_line ol
where p.pid = ol.pid (+);

---------- Question 4, slide 33 ----------
select pname
from product p, orders o, order_line ol, customer c
where ol.oid = o.oid
and p.pid = ol.pid
and c.cid = o.cid
and c.cname = 'John';

---------- Question 5, slide 36 ----------
select count(*)
from order_line ol, product p
where ol.pid = p.pid
and p.pname = 'TV';

---------- Question 6, slide 39 ----------
select p.pname, count(*)
from product p, order_line ol
where ol.pid = p.pid
group by p.pname;

---------- Question 7, slide 46 ----------
create table emp2(
eid integer,
hiredate date,
lastlogin timestamp);

insert into emp2 values(1, date '2002-1-1', timestamp '2006-1-1 09:00:30.00');

select lastlogin, lastlogin + interval '6' month
from emp2;
select lastlogin, lastlogin + interval '7' day
from emp2;
select lastlogin, lastlogin + interval '2:30' hour to minute
from emp2;

---------- Question 8, slide 47 ----------
select ename
from emp e, emp_proj ep, proj p
where e.eid = ep.eid
and ep.pid = p.pid
and p.pname = 'umbc library';

---------- Question 9, slide 48 ----------
select p.pname
from emp e, emp_proj ep, proj p
where e.eid = ep.eid
and ep.pid = p.pid
group by p.pname
having count(ep.pid) >= 3;

---------- Question 10, slide 49 ----------
update emp
set salary = salary + (salary * .10)
where salary in (
    select e.salary
    from emp e, emp_proj ep, proj p
    where e.eid = ep.eid
    and ep.pid = p.pid
    and p.pname = 'umbc library'
);

commit;