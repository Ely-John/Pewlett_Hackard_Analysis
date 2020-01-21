-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
---------------------------------------------

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
----------------------------------------------
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
----------------------------------------
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);
-------------------------------------
create table Titles (
  emp_no int not null,
  title varchar not null,
  from_date date not null,
  to_date date not null,
  foreign key (emp_no) references employees (emp_no),
  primary key (emp_no,title,from_date)
);
----------------------------------------
create table Dept_Emp (
 emp_no int not null,
 dept_no varchar not null,
 from_date date not null,
 to_date date not null,
foreign key (dept_no) references departments(dept_no),
foreign key (emp_no) references employees(emp_no),
primary key (emp_no,dept_no)
);

------------------------------------------------------------
--- Checking the output

select * from departments;
select * from salaries; 
select * from Dept_Emp;
select * from employees;
select * from Titles;
select * from dept_manager;
------------------------------------------------
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
--------------------------------------------------------------------
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';
-------------------------------------------------------------------
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
--------------------------------------------------------------
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
------------------------------------------------------------
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';
---------------------------------------------------------------
-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
----------------------------------------------------------------
-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-----------------------------------------------------------
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-------------------------------------------------------------
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
------------------------------------------------------------
SELECT * FROM retirement_info;
------------------------------------------------------
drop table retirement_info;
---------------------------------------------------
-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;
---------------------------------------------------------
-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;
----------------------------------------------------------
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;
----------------------------------------------------------
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;
-----------------------------------------------------
SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;
---------------------------------------------------
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;
----------------------------------------------------
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

select *from current_emp;
--------------------------------------------------------
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;
------------------------------------------------------
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
----------------------------------------------------
--------------------------------------------------
SELECT * FROM salaries
ORDER BY to_date DESC;
----------------------------------------------------
SELECT emp_no,
	first_name,
last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
------------------------------------------------------------------
SELECT e.emp_no,
	e.first_name,
e.last_name,
	e.gender,
	s.salary,
	de.to_date
-- INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
  AND (de.to_date = '9999-01-01');
-----------------------------------------------------------------------------------
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
--------------------------------------------------------------------------------------
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);
----------------------------------------------------------------------------------------
SELECT employees.emp_no, 
            employees.first_name, employees.last_name,
			employees.birth_date, employees.hire_date,
			departments.dept_name, departments.dept_no
-- dept_emp.dept_no
INTO sales
FROM employees 
--          (WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
--        AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31'))
        
inner join dept_emp 
on employees.emp_no = dept_emp.emp_no
inner join departments
on departments.dept_no = dept_emp.dept_no;

-- select dept_name from sales where dept_name= 'Sales';

select *from sales;

--------------------------------------------------
select emp_no, first_name, last_name,
      birth_date, hire_date, dept_name
	  

INTO sales_retirement_info
from sales 
where dept_name = 'Sales';
-------------------------------------------------------------
select *
into sales_retirement_table
from sales_retirement_info
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


select *from sales_retirement_table;

-------------------------------------------------------------------
-- Sales and development 

select emp_no, first_name, last_name,
      birth_date, hire_date, dept_name
	  

INTO sales_dev_retirement_info
from sales 
where dept_name in ('Sales','Development');


select *
into sales_dev_retirement_table
from sales_dev_retirement_info
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

select * from sales_dev_retirement_table;

----------------------------------------------------------------------------
-------Module 7 challenge--------
select ri.emp_no, ri.first_name, ri.last_name,
       titles.title, titles.from_date,
	   salaries.salary
into Titles_ret
from retirement_info as ri
inner join titles
on ri.emp_no = titles.emp_no
inner join salaries
on ri.emp_no = salaries.emp_no;

select * from titles_ret;
------------------------------------------------------------------------------
SELECT
  first_name,
  last_name,
--   from_date,
--   title,
  count(*)
FROM titles_ret
GROUP BY
  first_name,
  last_name
HAVING count(*) > 1;
--------------------------------------------------------------
SELECT * FROM
  (SELECT *, count(*)
  OVER
    (PARTITION BY
      first_name,
      last_name,
	 from_date
-- 	 title
    ) AS count
  FROM titles_ret) tableWithCount
  WHERE tableWithCount.count > 1;
  
 

SELECT DISTINCT ON (first_name, last_name,from_date) * FROM titles_ret;

select 
     count(title), from_date
into emp_titles_count
from titles_ret
group by title,from_date
order by title,from_date desc;
----------------------------------------------------------
----Who's Ready for Mentor------
select employees.first_name, employees.last_name, employees.birth_date,
       dept_emp.from_date, dept_emp.to_date
into Mentor
from employees
left join dept_emp
on employees.emp_no = dept_emp.emp_no;


select *
into mentor_emp
from mentor
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31';

select *from mentor_emp;
----------------------------------------------------------
-------The End--------------