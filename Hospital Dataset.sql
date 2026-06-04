-- Connect to database (MySQL only)
USE hospital_db;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW

-- a. How many total encounters occurred each year?
select year(start) as year, count(Id) as number_of_encounters from encounters 
group by year(start)
order by year(start)

-- WE OBSERVE SUDDEN RISE IN NUMBER OF ENCOUNTERS IN 2014 AND 2021 AND A SUDDEN DROP IN 2022

-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?
with abc as (SELECT year(start) as year , ENCOUNTERCLASS as encounterclass , COUNT(ID) as ID  FROM encounters
GROUP BY year(start), ENCOUNTERCLASS
ORDER BY year(start), ENCOUNTERCLASS), 
total_encounter as 
(select year, sum(ID) as sum from abc
group by year)
select abc.year, abc.encounterclass as Encounterclass, (abc.ID *100/total_encounter.sum) as Percentage 
from abc join total_encounter
on abc.year = total_encounter.year
order by abc.year, Percentage desc

-- So we see majority of the Encounters are from ambulatory class every year while emergency cases seemed to increased 
-- or stayed around same over the years, 2014 being an exception.

-- c. What percentage of encounters were over 24 hours versus under 24 hours?
with abc as (
    select count(ID) as count1 from encounters 
    where timestampdiff(hour, start, stop) > 24),
def as (
    select count(ID) as count2 from encounters 
    where timestampdiff(hour,start, stop) <= 24)
select 'over_24_hours' as duration_category ,(abc.count1*100/(abc.count1+def.count2)) as percentage from abc join def 
union all
select 'under_24_hours', 100-(abc.count1*100/(abc.count1+def.count2)) from abc join def 

-- We can clearly see that more than maximum of patients are under 24 hours meaning hospital is most ikely carrying the 
-- rountine work and surgeries

-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?

select 'Number' as metric, count(ID) as Value from encounters where payer_coverage = 0
union all
select 'Percentage' as metric, count(ID)*100/(select count(ID) from encounters) as Value from encounters 
where payer_coverage = 0

-- We can see nearly half (48.7%) of the encountered cases have payer coverage zero which increases the risk of default so 
-- hospital should look to add financial counsellours in emergency areas who can fillin paperwork for 
--government susidy if any of the patient is elegible for the same

-- b. What are the top 10 most frequent procedures performed and the average base cost for each?

select count(code) as code, description, avg(base_cost) as average_cost from procedures
group by description
order by count(code) desc
limit 10

-- We see the procudure regarding therapy, depression and other stress management have been prominent so hospital should 
-- evaluate their available resources and check patient waiting times and demand pattern to see if they need to employ 
-- more professionals or not

-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?

select avg(base_cost) as Average_Cost, description as Description, count(CODE) as no_of_times from procedures
group by description
order by Average_cost desc, no_of_times
limit 10

--This shows that cost od ICU admission is quite high as the cost is high despite being used only 5 times
--Surgeries like electrical cardioversion, colonscopy, and chemotherapy have been performed many times.

-- d. What is the average total claim cost for encounters, broken down by payer?

select payer, avg(total_claim_cost) as Average_Cost from encounters 
group by payer

--self explanatory

-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?

--select REGEXP_REPLACE(first, '[0-9]+$', '') AS clean_first_name, REGEXP_REPLACE(last, '[0-9]+$', '') AS clean_last_name from patients
select year(start) as year, quarter(start) as quarter, count(distinct patient) as number from encounters
group by year(start), quarter(start)

-- b. How many patients were readmitted within 30 days of a previous encounter?
with repeat_visits as (
    select
        patient,
        lag(date(stop)) over (
            partition by patient
            order by start
        ) as previous_stop,
        datediff(
            date(start),
            lag(date(stop)) over (
                partition by patient
                order by start
            )
        ) as days_difference
    from encounters
)

select count(distinct patient) as patient
from repeat_visits
where days_difference <= 30
  and days_difference is not null;

-- c. Which patients had the most repeat encounters within 30 days?

with repeat_visits as (
    select
        patient,
        lag(date(stop)) over (
            partition by patient
            order by start
        ) as previous_stop,
        datediff(
            date(start),
            lag(date(stop)) over (
                partition by patient
                order by start
            )
        ) as days_difference
    from encounters
)
select patient as Patient_ID, count(*) as readmin_count
from repeat_visits
where days_difference <= 30
  and days_difference is not null
group by patient
order by readmin_count desc

-- some patients exhibit unusally high frequncy of encounters
