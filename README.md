# Pewlett-Hackard-Analysis

## Project Overview
### Purpose
Purpose of this analysis is to get Pewlett-Hackard ready for the avalanche of upcoming retirements. This company
has requested for us to assist with the analysis so they may be better prepared with the upcoming vacant positions,
retirement packages, and onboarding new employees. We will target the below:
1. Identify retiring employees by title
2. determine total sum of retiring employees
3. Identify employees eligible for participation in the mentorship program
4. Find qty of roles to be filled by title and department
5. Find qty of qualified senior employees ready to train and onboard new employees

Need to create a quickDBD schema to help visualize how tables function together:

![alt text](https://github.com/brivasbravo/Pewlett-Hackard-Analysis/blob/main/Resources/QuickDBDsnap.png)

### Background
There is six CSV files being used. We will also be using QuickDBD to design database visualization and pgAdmin to query and
manipulate data

### Results

1. First table created is the list of retiring employees which contains the following:
- employee number
- first name
- last name
- title
- from date
- to date

This table returns 133,776 rows of who exactly is going to retire soon. Note some employees appear more than once due to title change
so we must remove duplicates to get the true number.

![alt text](https://github.com/brivasbravo/Pewlett-Hackard-Analysis/blob/main/Resources/SQLsnap1.png)

2. Next we need to understand the true employees that will retire so we must remove the duplicates below:
- this table includes employee number, first name, last name, and title
- table only displays list of soon to retire employees with total query count at 72,458

![alt text](https://github.com/brivasbravo/Pewlett-Hackard-Analysis/blob/main/Resources/SQLsnap2.png)

3. Next table below shows exact qty per position that will be retiring below:
- Table will help with deep dive by position instead of just having the full count

![alt text](https://github.com/brivasbravo/Pewlett-Hackard-Analysis/blob/main/Resources/SQLsnap3.png)

4. Next table shows employees eligible for mentorship program
- the total qty eligible is 1549 employees
- list includes: employee number, first name, last name, birth date, from date, to date, and title

![alt text](https://github.com/brivasbravo/Pewlett-Hackard-Analysis/blob/main/Resources/SQLsnap4.png)

### Summary
Analysis above really helps company understand avalanche of upcoming retirements regarding total qty (72,458 employees), exact titles
that will be retiring, and 1549 eligible employees for the mentorship program but we can dive deeper into the data seen below. Note at 
this current number 1549 eligible employees for mentorship program is extremely too small compared to the upcoming vacancy number of 72K.
We will need to expand in order to smooth the transition with upcoming retiring employees.

To be able to create this next two extra analysis we needed to create table below from 3 separate JOIN table formulas that combined
employee number, name, title, dept and birthdate eligible to retire and currently employed resulting in the following snapshot:

![alt text](https://github.com/brivasbravo/Pewlett-Hackard-Analysis/blob/main/Resources/SQLsnap5.png)

Table created below pulls from above table to walk through the exact qty by dept and title that will retire. Snapshot below:

![alt text](https://github.com/brivasbravo/Pewlett-Hackard-Analysis/blob/main/Resources/SQLsnap6.png)

Note we have done a spot check and total qty equals 72,458 and remainder of table can be found in data folder under rolls_to_fill.csv
for further inspection.

Next we ran another query to show only senior employees that may be eligible for the Mentorship program if we use parameter of 
having senior, leader, or manager in their title instead of using tight date parameter in #4 specifically line: 
'WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')'. This is too small of a parameter. Table below gives us 54,447 employees
that we can draw upon for the improved mentorship program that will help bridge the large gap this company has with the upcoming
retirement vacancies.

![alt text](https://github.com/brivasbravo/Pewlett-Hackard-Analysis/blob/main/Resources/SQLsnap7.png)








