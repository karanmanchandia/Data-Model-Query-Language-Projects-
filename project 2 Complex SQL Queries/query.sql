# Question1
#Relational Schema (consisting of three relations Employee, project and Assign)

# Creating Employee Table
create table Employee
(
Ename varchar(100),
Salary decimal(10,2),
constraint EmployeePK primary key (Ename)
);

# Creating Project Table
create table Project
(
Pname varchar(256),
Agency varchar(100),
Budget decimal(18,2),
constraint ProjectPK primary key (Pname)
); 

# Creating Assign Table
create table Assign
(
Pname varchar(256),
Ename varchar(100),
constraint AssignPK primary key (Pname, Ename),
constraint AssignFK1 foreign key (Pname) references Project (Pname),
constraint AssignFK2 foreign key (Ename) references Employee (Ename)
);

# Queries to insert tuples in the Employee Table
insert into Employee values ('Neena',12000);
insert into Employee values ('Lex',8500);
insert into Employee values ('Alexander',8500);
insert into Employee values ('Bruce',4500);
insert into Employee values ('David',3000);
insert into Employee values ('Valli',2400);
insert into Employee values ('Diana',2400);
insert into Employee values ('Nancy',2100);
insert into Employee values ('Daniel',6000);
insert into Employee values ('John',4500);
insert into Employee values ('Ismael',4100);
insert into Employee values ('Jose Manuel',3850);
insert into Employee values ('Luis',3900);
insert into Employee values ('Dan',3450);
insert into Employee values ('Alexa',5500);
insert into Employee values ('Shelli',1550);
insert into Employee values ('Sigal',1450);
insert into Employee values ('Guy',1400);
insert into Employee values ('Karen',1300);
insert into Employee values ('Matthew',1250);
insert into Employee values ('Adam',4000);
insert into Employee values ('Payam',4100);
insert into Employee values ('Mark',3950);
insert into Employee values ('Kevin',3250);
insert into Employee values ('Julia',2900);
insert into Employee values ('Irene',1600);
insert into Employee values ('James',1350);
insert into Employee values ('Steven',1200);

# Queries to insert tuples in the Project Table
insert into Project values ('Orion','AAA',500000);
insert into Project values ('Antlia','Aladin',400000);
insert into Project values ('Carina','Clarks',300000);
insert into Project values ('Aries','DSW', 200000);
insert into Project values ('Apus','Clarks', 90000);
insert into Project values ('Columba','AAA',250000);
insert into Project values ('Crater','Horizon', 385000);
insert into Project values ('Lynx','Clarks', 72000);
insert into Project values ('Perseus','Clarks', 200000);

# Queries to insert tuples in the Assign Table
insert into Assign values ('Columba','Neena');
insert into Assign values ('Carina','Neena');
insert into Assign values ('Carina','Lex');
insert into Assign values ('Lynx','Alexander');
insert into Assign values ('Crater','Alexander');
insert into Assign values ('Apus','Alexander');
insert into Assign values ('Carina','Alexander');
insert into Assign values ('Orion','Alexander');
insert into Assign values ('Carina','Bruce');
insert into Assign values ('Lynx','David');
insert into Assign values ('Carina','David');
insert into Assign values ('Apus','Valli');
insert into Assign values ('Columba','Valli');
insert into Assign values ('Apus','Diana');
insert into Assign values ('Columba','Nancy');
insert into Assign values ('Crater','Daniel');
insert into Assign values ('Orion','John');
insert into Assign values ('Crater','Ismael');
insert into Assign values ('Orion','Jose Manuel');
insert into Assign values ('Lynx','Luis');
insert into Assign values ('Aries','Luis');
insert into Assign values ('Antlia','Shelli');
insert into Assign values ('Antlia','Sigal');
insert into Assign values ('Apus','Sigal');
insert into Assign values ('Columba','Guy');
insert into Assign values ('Carina','Karen');
insert into Assign values ('Apus','Matthew');
insert into Assign values ('Orion','Adam');
insert into Assign values ('Antlia','Payam');
insert into Assign values ('Antlia','Mark');
insert into Assign values ('Antlia','Kevin');
insert into Assign values ('Antlia','Julia');
insert into Assign values ('Antlia','Irene');
insert into Assign values ('Apus','James');
insert into Assign values ('Lynx','Steven');

# Question 1 S1: Find the employees assigned to exactly one project.
select Ename
from assign
group by Ename
having COUNT(Pname) = 1;

# Question 1 S2: Find the employees whose salary is greater than Mark’s salary (Mark is an employee).

SELECT * 
from Employee 
where Salary > (select Salary from Employee where Ename = 'Mark');

# Question 1 S3: For every project, compute the number of projects whose budget is higher.

	Select A.Pname, 
	SUM(CASE WHEN A.budget < B.budget then 1 else 0 end) As 'Count Projects With Higher budget'
	from project A 
	CROSS JOIN  (SELECT Budget from project) B
	group by A.Pname
	order by 2; 
  
# Question 1 S4: Find the projects with the budget lower than the average project budget at the same agency

select proj.Pname, proj.Agency, proj.Budget, aa.average_budget from Project proj 
inner join (
select Agency, AVG(Budget) as Average_budget
from Project
group by Agency) aa
on proj.Agency = aa.Agency 
where proj.Budget < aa.Average_budget;

# Question1 completes here. All other portions of que 1 could be found in report.

# Question 2
# Define an appropriate SQL schema.
# Create table statement for graph table having 2 columns StartNode and EndNode
create table graph
(
StartNode char(1),
EndNode char(1),
constraint graphPK primary key (StartNode, EndNode)
);

# Statements for inserting values in the graph table
insert into graph values ('A','B');
insert into graph values ('A','C');
insert into graph values ('A','D');
insert into graph values ('C','E');
insert into graph values ('D','E');
insert into graph values ('E','D');
insert into graph values ('E','F');
insert into graph values ('F','C');
insert into graph values ('Y','X');
insert into graph values ('X','F');

# Write the following queries in SQL2 or SQL3

# For every node, compute the number of the nodes directly reachable from the node.

select StartNode, COUNT(DISTINCT EndNode) AS Node_Cnt from Graph
GROUP BY StartNode
union
select EndNode, 0 from Graph where 
EndNode not in ( select StartNode from Graph)
order by StartNode;

# For every node, compute the number of the nodes reachable, directly or indirectly, from that node.

with recursive Anc (start , end) As(
(select * from graph)
union
((select g.startNode, A.end
from graph g, Anc A
where g.endNode = A.start And A.start <> A.end)))
select Anc.start as Nodename, Count(anc.end)as NodesReachable from Anc group by anc.start
union
select EndNode, 0 from Graph where 
EndNode not in ( select StartNode from Graph);

# Compute the set of all the nodes not directly reachable from the node A

select a.allnode from
(select distinct endnode as allnode from graph where startnode <> 'A'
union 
select distinct startnode from graph where startnode <> 'A'
order by allnode) a
where allnode not in
(select distinct endnode as allnode from graph 
where startnode ='A');

# Compute the set of all the nodes not reachable, directly or indirectly, from the node A.

with recursive Anc (start , end) As(
(select * from graph)
union
((select g.startNode, A.end
from graph g, Anc A
where g.endNode = A.start And A.start <> A.end)))
select a.NotReachable from
(select distinct endnode as NotReachable from graph where startnode <> 'A'
union 
select distinct startnode from graph where startnode <> 'A'
order by NotReachable) a
where NotReachable not in
(select Anc.end as NotReachable from Anc where Anc.start = 'A');

# Question 2 completes here

# Question 3 

/* In this question we need to consider the case of a relation with N columns. A relation with 
N columns could be written for expalnation purpose but here we are taking N=3 for running a 
actual SQL query. Any other value such as 4 or 5 could be take in place of N=3.*/

# Create table statement for relation R having N number of columns
/*create table R
(value1 char(1),
value2 char(1),
value3 char(1),
......valuen char(1)
);*/

# Create table statement for relation R having N=3 number of columns
create table R
(value1 char(1),
value2 char(1),
value3 char(1)
);

# Statements for inserting values in R
insert into R values ('a','b','c');
insert into R values ('d','d','e');
insert into R values ('f','g','g');
insert into R values ('h','i','j');
insert into R values ('k','l','m');
insert into R values ('n','o','n');
insert into R values ('p','o','n');
insert into R values ('n','o','n');
insert into R values ('o','n','n');

/* For a schema with N columns a SQL query that would return all the tuples having minimum number of different values is shown below:
Note that this query is a conceptual query and can not actually tested 

SELECT value1, value2, value3,....,valuen from R
WHERE ( case when value1 = value2 then 0 else 1 end
+ 
case when value2 = value3 then 0 else 1 end
+	
case when value1 = value3 then 0 else 1 end 
+
........
+
case when value1 = valuen then 0 else 1 end
+
case when value2 = valuen then 0 else 1 end
+
case when value3 = valuen then 0 else 1 end) =  
(
SELECT MIN( case when value1 = value2 then 0 else 1 end
+ 
case when value2 = value3 then 0 else 1 end
+	
case when value1 = value3 then 0 else 1 end
+
.........
+
case when value1 = valuen then 0 else 1 end
+
case when value2 = valuen then 0 else 1 end
+
case when value3 = valuen then 0 else 1 end )
from R);
*/

# A SQL query that returns tuples having minimum number of different values is shown below:
# This query satisfies the conditions given in the questions i.e. it uses aggregation and does not use tuple identifier and has a prolynomaial size in N.

SELECT value1, value2, value3 from R
WHERE ( case when value1 = value2 then 0 else 1 end
+ 
case when value2 = value3 then 0 else 1 end
+	
case when value1 = value3 then 0 else 1 end ) =  
(
SELECT MIN( case when value1 = value2 then 0 else 1 end
+ 
case when value2 = value3 then 0 else 1 end
+	
case when value1 = value3 then 0 else 1 end )
from R);

# The purpose of table R2 is to check a different scenario for the same above written solution:
# Create table statement for relation R2 having N=3 number of columns
create table R2
(value1 char(1),
value2 char(1),
value3 char(1)
);
 
# Statements for inserting values in R2
insert into R2 values ('a','b','c');
insert into R2 values ('b','b','b');
insert into R2 values ('d','d','e');
insert into R2 values ('g','g','h');
insert into R2 values ('i','i','i');
insert into R2 values ('j','k','l');
insert into R2 values ('n','o','n');
insert into R2 values ('p','p','p');
insert into R2 values ('q','r','r');
insert into R2 values ('b','b','b');

# A SQL query that returns tuples having minimum number of different values is shown below:
# This query satisfies the conditions given in the questions i.e. it uses aggregation and does not use tuple identifier and has a prolynomaial size in N.
SELECT value1, value2, value3 from R2
WHERE ( case when value1 = value2 then 0 else 1 end
+ 
case when value2 = value3 then 0 else 1 end
+	
case when value1 = value3 then 0 else 1 end ) =  
(
SELECT MIN( case when value1 = value2 then 0 else 1 end
+ 
case when value2 = value3 then 0 else 1 end
+	
case when value1 = value3 then 0 else 1 end )
from R2)

# Question 3 completes here.