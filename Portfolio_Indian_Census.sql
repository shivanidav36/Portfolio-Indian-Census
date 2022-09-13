select* from Project1.dbo.Data1  ;

select* from Project1.dbo.Data2;

-- total number of rows in dataset

select  count(*) total_rows from Project1.dbo.Data1;
select count(*) total_rows from Project1.dbo.Data2;

-- Data specefic state : Jharkhand and Bihar

select * from  Project1.dbo.Data1 where state='Jharkhand'or state='Bihar';
select * from  Project1.dbo.Data2 where state in ('Jharkhand','Bihar');

--Total Population of India

select sum(Population) as total_Population from  Project1.dbo.Data2;

--AVG Growth of India 

select state,AVG(Growth)*100 from  Project1.dbo.Data1 group by state;

--Statewise AVG sex_ratio 
select state,round(avg(Sex_Ratio),0) as avg_sex_ratio  from Project1.dbo.Data1 group by State order by avg_sex_ratio desc;

--AVG literacy_ratio of state having literacy rate greater than 90 

select state,round(avg(literacy),0) avg_literacyRate from Project1.dbo.Data1 group by state having round(AVG(literacy),0)>90 order by avg_literacyRate desc; 

 
--Top 3 state (Alphabetically top 3) having highest growth rate 
select top 3 state,avg(Growth)*100 as avg_growth_ratio from Project1.dbo.Data1 group by State ;

--Top 3 state having highest growth rate 
select top 3 state,avg(Growth)*100 as avg_growth_ratio from Project1.dbo.Data1 group by State order by avg_growth_ratio desc ;

-- bottom 3 state showing lowest sex ratio
select top 3 State,round(avg(Sex_Ratio),0) as avg_sex_ratio from  Project1.dbo.Data1  group by state order by avg_sex_ratio asc;

-- bottom and top 3 states in literacy rate in one table

 -- one table contains top 3 state 

  drop table if exists #topstates;
create table #topstates
( state nvarchar(255),
  topstate float

  )

insert into #topstates
select state,round(avg(literacy),0) avg_literacy_ratio from Project1.dbo.Data1
group by state order by avg_literacy_ratio desc;

select top 3 * from #topstates order by #topstates.topstate desc;


-- another table contains bottom 3 state 

drop table if exists #bottomstates;
create table #bottomstates
( state nvarchar(255),
  bottomstate float

  )

insert into #bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio from Project1.dbo.Data1 
group by state order by avg_literacy_ratio desc;

select top 3 * from #bottomstates order by #bottomstates.bottomstate asc;

--union opertor(combine both the tables)

select state,topstate as literacy_rate from (
select * from (
select top 3 * from #topstates order by #topstates.topstate desc) a

union

select * from (
select top 3 * from #bottomstates order by #bottomstates.bottomstate asc) b)c order by topstate desc;


--joinnig both the tables 

select a.district,a.state,a.sex_ratio,b.Population from Project1.dbo.Data1 a join Project1.dbo.Data2 b on a.district=b.District;

 -- total males and females in population 

 select d.state, sum(d.male) as total_men, sum(d.female) total_females from 
 (select c.district, c.state, round(Population/(sex_ratio+1),0) male, round(Population*(sex_ratio/(sex_ratio+1)),0) female from 
 (select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.Population from Project1.dbo.Data1  a join Project1.dbo.Data2 b on a.District=b.District) c)
 d group by d.state ; 

 -- total literacy rate  literacy rate 
  select d.state, sum(d.literacy_rate) as total_literatePeople,sum(d.iliterare_pople) as total_iliteratePeople from
 (select c.state, c.district, round(c.literacy*c.population,0) as literacy_rate ,round((1-c.literacy)*c.population,0) as iliterare_pople from
 (select a. district,a.state,a.literacy/100 as literacy,b.Population from Project1.dbo.Data1 a join Project1.dbo.Data2 b 
 on a.District=b.District)c) d group by state;

 -- Population in previous census
 
 select sum(e.previous) as Previous_Total , sum(currentValue) as Current_Total from
 (select d.state,sum(d. previous_population) as previous ,sum(d. current_population) as currentValue from
 (select c.District,state,c.growth,c.population as current_population ,round(Population/(1+growth),0)as previous_population from 
 (select a.District,a.state,a.growth,b.population from Project1.dbo.Data1 a join Project1.dbo.Data2 b on a.District=b.District) c)
 d group by d.state)e;


--Population VS Area

 select q.*,r.* from 
  
  (select'1'as keyy,n.*from
 ( select sum(e.previous) as Previous_Population , sum(currentValue) as CurrentValue_Population from
 (select d.state,sum(d. previous_population) as previous ,sum(d. current_population) as currentValue from
 (select c.District,state,c.growth,c.population as current_population ,round(Population/(1+growth),0)as previous_population from 
 (select a.District,a.state,a.growth,b.population from Project1.dbo.Data1 a join Project1.dbo.Data2 b on a.District=b.District) c)
 d group by d.state)e)n)q inner join (
 
 select '1' as keyy,z.* from
 (select sum(Area_km2) as Total_Area from Project1.dbo.Data2) z) r on q.keyy=r.keyy;



 



 








