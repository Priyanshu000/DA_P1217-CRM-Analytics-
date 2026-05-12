create database crm_db;
use crm_db;

# KPIs for Oppurtunity Dashboard

# 1) Expected Revenue
select concat(round((sum(Amount))/1000000,2)," M") as Expected_Revenue
from oppurtunity;

# 2) Active Oppurtunities
select count(*) from oppurtunity
where closed=False;

# 3) Conversion Rate (%)
select concat(round((sum(case when won=True then 1 else 0 end) * 100)/ count(*),2),"%")
as Conversion_Percentage
from oppurtunity;

# 4) Win Rate (%)
select  concat(round((sum(case when closed=True and won=True then 1 else 0 end) * 100 ) / sum(case when won in(True, False) then 1 else 0 end),2),"%")
as Win_Percentage
from oppurtunity;

# 5) Loss Rate (%)
select concat(round((sum(case when closed=true and won=false then 1 else 0 end) * 100) / sum(case when closed in (True, False) then 1 else 0 end),2), "%")
as Loss_Percentage
from oppurtunity; 

# 6) Running Expected Vs Running Forecast over time
select date(close_date) as close_date,
sum(amount) over(order by close_date) as Running_Expected,
sum(case when won=True then amount else amount*probability_percent/100 end) over(order by close_date) as Running_Forecast
from oppurtunity
order by close_date;

# 7) Running Active Vs Running Total Opportunities over time
select date(close_date) as close_date,
sum(case when won=False then 1 else 0 end) over (order by close_date)  as Running_Active,
count(*) over (order by close_date) as Running_Total_Oppurtunities
from oppurtunity
order by close_date;

# 8) Running Closed Won Vs Runnig Total Opportunities Over Time
select date(close_date) as close_date,
sum(case when closed=True and won=true then 1 else 0 end) over (order by close_date) as running_closed_won,
count(*) over (order by close_date) as Running_total_oppurtunities
from oppurtunity
order by close_date;

# 9) Running Closed Won Vs Runnig Total Closed over time
select date(close_date) as close_date,
sum(case when closed=True and won=True then 1 else 0 end) over(order by close_date) as Running_closed_won,
sum(case when closed=True then 1 else 0 end) over(order by close_date) as Running_total_closed
from oppurtunity
order by close_date;

# 10) Expected Amount by Opportunity Type
select opportunity_type,
round(sum(amount*probability_percent/100),2) as Expected_Amount
from oppurtunity
group by opportunity_type 
order by Expected_Amount;

# 11) Opportunities by Industry
select Industry,
count(*) as Oppurtunities_Count
from oppurtunity
group by Industry
order by Oppurtunities_Count;


# KPIs for Lead Dashboard

# 1) Total Lead
select count(Lead_ID) as Total_Leads
from leads;

# 2) Expected Amount from Converted Leads
select 
concat(round((sum(o.Amount * o.Probability_Percent/100))/1000000,2), " M") as Expected_Amount_from_Converted_Leads
from leads l join oppurtunity o
on l.converted_opportunity_id = o.opportunity_id
where l.converted=True;

# 3) Conversion Rate (%)
select concat(round((sum(case when converted=True then 1 else 0 end) * 100)/ count(lead_id),2),"%")
as Conversion_Rate_Percent
from leads;

# 4) Converted Accounts
select 
count(Converted_Account_ID) - sum(case when Converted_Account_ID = "Not Converted" then 1 else 0 end) as Converted_Accounts
from leads;


# 5) Converted Opportunities
select 
count(Converted_Opportunity_ID) - sum(case when Converted_Opportunity_ID = "Not Converted" then 1 else 0 end) as Converted_Oppurtunities
from leads;

# 6) Lead By Source
select Lead_Source, count(Lead_Source) as Lead_Count
from leads
group by Lead_Source	
order by Lead_Count desc;

# 7)  Lead By industry
select Industry, count(Industry) as Lead_Count
from leads
group by Industry
order by Lead_Count desc;

# 8) Lead by Stage(Status)
select Status as Stage, count(Status) as Lead_Count
from leads
group by Status
order by Lead_Count desc;










