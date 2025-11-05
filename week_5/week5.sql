create database office;
use office;

create table dept(
    deptno int,
    dname varchar(20),
    dloc varchar(20),
    primary key(deptno));
    
create table employee(
     empno int,
     ename varchar(20),
     mgr_no int,
     hiredate date,
     sal real,
     deptno int,
     primary key(empno),
     foreign key(deptno) references dept(deptno));
     
create table incentives(
    empno int,
    incentive_date date,
    incentive_amount real,
    primary key(incentive_date),
    foreign key(empno) references employee(empno));
    
create table project(
    pno int,
    ploc varchar(20),
    pname varchar(20),
    primary key(pno));
    
create table assigned_to(
    empno int,
    pno int,
    job_role varchar(10),
    foreign key(empno) references employee(empno),
    foreign key(pno) references project(pno));
    
insert into dept(deptno,dname,dloc)values
(1001, 'tester','hyderabad'),
(1002,'backend developer','bangaluru'),
(1003,'editor','hyderabad'),
(1004,'sales','mysuru'),
(1005,'marketing','vizag'),
(1006,'finance','bangaluru');

insert into employee(empno,ename,mgr_no,hiredate,sal,deptno)values
(101,'ram',null,'2012-03-21',50000,1002),
(102,'sham',103,'2014-04-08',25000,1001),
(103,'reva',101,'2010-11-03',50000,1004),
(104,'sai',101,'2016-01-03',30000,1006),
(105,'nikil',103,'2014-04-09',30000,1005),
(106,'ramya',101,'2018-06-27',40000,1003);

insert into incentives(empno,incentive_date,incentive_amount)values
(102,'2014-06-08',5000),
(106,'2018-10-27',6000),
(101,'2012-06-08',4000),
(105,'2014-09-09',5000),
(103,'2011-02-03',4000),
(104,'2016-04-03',6000);

insert into project(pno,ploc,pname)values
(10,'bangaluru','dayton'),
(11,'hyderabad','camel'),
(12,'mysuru','database'),
(13,'vizag','habit tracker'),
(14,'hyderabad','travel'),
(15,'bangauru','promotions');

insert into assigned_to(empno,pno,job_role)values
(101,15,'data alt'),
(102,11,'tester alt'),
(103,12,'sales alt'),
(104,10,'financealt'),
(105,13,'market alt'),
(106,14,'count alt');

select distinct e.empno,e.ename from employee e
join assigned_to a on e.empno=a.empno
join project p on p.pno=a.pno
where p.ploc in ('bangaluru','hyderabad','mysuru');

select empno from employee where empno not in(select empno from incentives);

select e.empno,e.ename,d.dname,d.dloc,a.job_role,p.ploc
from employee e
join dept d on e.deptno=d.deptno
join assigned_to a on e.empno=a.empno
join project p on a.pno=p.pno
where d.dloc=p.ploc;