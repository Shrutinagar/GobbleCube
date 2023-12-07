create database employee_info;
use employee_info;

create table employees(employee_id int, employee_name varchar(255), department_id int, manager_id int, hire_date date);
insert into employees values(1, "Arya", 1, 1, "2015-12-01");
insert into employees values(2, "Bharat", 2, 5, "2019-05-01");
insert into employees values(3, "Chirag", 1, 6, "2020-03-01");
insert into employees values(4, "Disha", 3, 5, "2023-05-01");
insert into employees values(5, "Esha", 1, 2, "2020-01-01");
insert into employees values(6, "Farah", 2, 2, "2019-09-01");
insert into employees values(7, "Grace", 2, 3, "2019-10-01");

create table salaries(employee_id int, salary int, effective_date date);
insert into salaries values(1, 9000, "2016-03-15");
insert into salaries values(1, 15000, "2022-04-01");
insert into salaries values(2, 10000, "2019-05-18");
insert into salaries values(2, 22000, "2022-10-30");
insert into salaries values(2, 10000, "2023-04-15");
insert into salaries values(3, 18000, "2021-03-01");
insert into salaries values(3, 25000, "2022-12-01");
insert into salaries values(4, 9000, "2023-05-01");
insert into salaries values(5, 16000, "2020-01-01");
insert into salaries values(5, 21000, "2021-10-15");
insert into salaries values(5, 25000, "2023-06-30");
insert into salaries values(6, 30000, "2019-03-01");
insert into salaries values(6, 35000, "2022-12-11");
insert into salaries values(7, 19000, "2019-03-01");
insert into salaries values(7, 21000, "2023-07-01");

create table departments(department_id int, department_name varchar(255));
insert into departments values(1, "HR");
insert into departments values(2, "Finance");
insert into departments values(3, "Marketing");

create table projects(project_id int, project_name varchar(255));
insert into projects values(1, "P-1");
insert into projects values(2, "P-2");
insert into projects values(3, "P-3");

create table employee_projects(employee_id int, project_id int);
insert into employee_projects values(1, 1);
insert into employee_projects values(2, 2);
insert into employee_projects values(3, 3);
insert into employee_projects values(4, 2);
insert into employee_projects values(5, 3);
insert into employee_projects values(6, 1);
insert into employee_projects values(7, 2);

# run Tables
select * from employees;
select * from salaries;
select * from departments;
select * from projects;
select * from employee_projects;

/* PART I
Write a SQL query to find the department with the highest average employee salary, 
 considering only the latest salary for each employee based on the effective_date */
 
# CTE
with highestsalary as (
	select s.*, row_number() over(partition by s.employee_id order by s.effective_date) as rn
    from salaries s
    )
select d.department_id, d.department_name, round(avg(hs.salary),2) as avg_salary
from highestsalary hs
join employees e
on hs.employee_id = e.employee_id
join departments d
on d.department_id = e.department_id
where hs.rn = 1
group by d.department_id, d.department_name
order by avg_salary desc;

/* PART II
Extend the query include the names of employees in the 
department with the highest average salary for each employee
*/

with highestsalary as (
	select s.*, row_number() over(partition by s.employee_id order by s.effective_date) as rn
    from salaries s
    )
select e.employee_name, d.department_id, d.department_name, round(avg(hs.salary),2) as avg_salary
from highestsalary hs
join employees e
on hs.employee_id = e.employee_id
join departments d
on d.department_id = e.department_id
where hs.rn = 1
group by e.employee_name, d.department_id, d.department_name
order by avg_salary desc
limit 1;

/* PART III
	Write an additional query to find the project with the most employees assigned to it
    */
    
select p.project_id, p.project_name, count(ep.employee_id) as total_employees
from employee_projects as ep
left join projects as p
using (project_id)
group by p.project_id, p.project_name
order by total_employees desc
limit 1;