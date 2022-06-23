-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
    dept_no VARCHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE (dept_name)
);

CREATE TABLE employees (
    emp_no INT NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    hire_date DATE NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
        PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE Dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE title(
    emp_no INT NOT NULL,
    title VARCHAR NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- Retirement eligibility
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
And (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- number of retiring employees with title 
select e.emp_no, 
        e.first_name, 
        e.last_name,
            f.title,
            f.from_date,
            f.to_date
            INTO retiring_by_title
            FROM employees AS e
            LEFT JOIN title as f
            ON (e.emp_no = f.emp_no)
            WHERE (e.birth_date BETWEEN '1952-01-01'AND '1955-12-31')
            ORDER BY e.emp_no

-- Create a Unique titles table using INTO clause
-- Use Distinct with Orderby to remove duplicates
SELECT DISTINCT ON (emp_no) emp_no,
    first_name,
    last_name,
    title
INTO unique_titles
FROM retiring_by_title
WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC, to_date DESC;

-- retrieve number of employees by most recent title and retiring
SELECT COUNT (title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

--Query mentorship eligibility
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, d.from_date, d.to_date, f.title
INTO mentorship_eligibility
FROM employees AS e
LEFT JOIN dept_emp AS d
ON e.emp_no = d.emp_no
LEFT JOIN title as f
ON e.emp_no = f.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (d.to_date = '9999-01-01')
ORDER BY e.emp_no;

--joining by employee number, name, title, dept and birthdate eligible to retire

SELECT DISTINCT ON (re.emp_no)
    re.emp_no,
    re.first_name,
    re.last_name,
    re.title,
    de.dept_name
INTO unique_dept_title
FROM retiring_by_title as re
INNER JOIN dept_emp as d
ON (re.emp_no = d.emp_no)
INNER JOIN departments as de
ON (de.dept_no = d.dept_no)
ORDER BY re.emp_no, re.to_date DESC;

SELECT u.emp_no,
    u.first_name,
    u.last_name,
    u.title,
    u.dept_name,
    em.birth_date
INTO employee_dept_birth
FROM unique_dept_title AS u
INNER JOIN employees as em
ON (u.emp_no = em.emp_no)
WHERE (em.birth_date BETWEEN '1952-01-01'AND '1955-12-31')
ORDER BY u.emp_no ASC;

--to date 9999-01-01

SELECT edb.emp_no,
    edb.first_name,
    edb.last_name,
    edb.title,
    edb.dept_name,
    edb.birth_date
INTO employee_dept_to_date
FROM employee_dept_birth AS edb
INNER JOIN dept_emp as dem
ON (edb.emp_no = dem.emp_no)
WHERE (edb.birth_date BETWEEN '1952-01-01'AND '1955-12-31')
AND (dem.to_date = '9999-01-01')
ORDER BY edb.emp_no ASC;

-- Roles to fill per title and department
SELECT ud.dept_name, ud.title, COUNT(ud.title) 
INTO rolls_to_fill
FROM (SELECT title, dept_name FROM employee_dept_to_date) as ud
GROUP BY ud.dept_name, ud.title
ORDER BY ud.dept_name DESC;

-- Senior staff that may need to step up to fill new vacant roles
SELECT ud.dept_name, ud.title, COUNT(ud.title) 
INTO senior_staff
FROM (SELECT title, dept_name from employee_dept_to_date) as ud
WHERE ud.title IN ('Manager', 'Senior Engineer', 'Technique Leader', 'Senior Staff')
GROUP BY ud.dept_name, ud.title
ORDER BY ud.dept_name DESC;