-- project 2 adb

--Q1: using the intersect to find teams from both boston and denver:
select distinct p.firstname,p.lastname from player_rs p,teams t where t.tid=p.tid and t.location='Boston' intersect select distinct p.firstname,p.lastname from player_rs p,teams t where t.tid=p.tid and t.location= 'Denver' ;


--Q2: using between function  and order by we can write this query:

SELECT DISTINCT  prs.lastname, prs.firstname
FROM player_rs prs
WHERE year BETWEEN 1990 AND 1992 ORDER BY prs.lastname, prs.firstname;

--Q3: using in statement we can write this query with the given conditions and a not equal operator is also used, displaying the coaches and players in the same season.

SELECT DISTINCT c.firstname,c.lastname,c.year FROM coaches_season c WHERE c.cid in ( SELECT p.ilkid FROM player_rs p WHERE c.year=p.year AND c.tid!=p.tid);

--Q4: The maximum number of drafts from a college for an year is generated and I am not able to print the names of the colleges so a partial output is produced.

SELECT b.year, MAX(draftscount) FROM ( SELECT d.draft_year as year, d.draft_from as college, COUNT(d.draft_from) as draftscount FROM  draft d
GROUP BY draft_year, draft_from ORDER BY draft_year, draft_from) b GROUP BY b.year;

--Q5:using the in,inequality operators and count the following query can be written.

 SELECT DISTINCT c3.firstname,c3.lastname FROM coaches_season c3 WHERE c3.cid IN (SELECT c1.cid FROM coaches_season c1 WHERE c1.year>1980 AND c1.year<2005 GROUP BY c1.cid HAVING COUNT(c1.tid) >= ALL (SELECT COUNT(c2.tid) FROM coaches_season c2 WHERE c2.year > 1980 and c2.year < 2005 GROUP BY c2.cid));

--Q6: to find the second largest number, i am using ilkid to identify the players and counting it and grouping it by the college name and ordering by the count generated and using the limit operator and offseting to show the second largest value.

SELECT d.draft_from as college,count(d.ilkid) AS totaldraftssent FROM draft d GROUP BY  d.draft_from ORDER BY totaldraftssent desc limit 1 offset 1;


--Q7:using the NOT EXIST and EXCEPT concept thought in the class the following query can be solved.

SELECT DISTINCT c.firstname,c.lastname FROM coaches_season c WHERE NOT EXISTS (( SELECT t.league FROM teams t) EXCEPT (SELECT t1.league FROM teams t1 WHERE t1.tid=c.tid));

--Q8: Query 7 can be solved without using except in another appraoch like this in the 8th one.

SELECT DISTINCT c.firstname,c.lastname FROM coaches_season c WHERE NOT EXISTS ( SELECT t.league FROM teams t WHERE NOT EXISTS (SELECT t1.league FROM teams t1 WHERE t1.tid=c.tid AND t1.league= t.league));

--Q9: The maximum height in centimeter of the person in each team is printed but I am not able to print the names of the players and hence a partial output is generated.

SELECT t.name, b.cm_height FROM teams t INNER JOIN (SELECT prs.tid, MAX(height) as cm_height
FROM player_rs prs INNER JOIN ( SELECT p.ilkid, (p.h_feet*12 + p.h_inches)*2.54 as height FROM 
Players p INNER JOIN Player_RS rs ON p.ilkid = rs.ilkid WHERE rs.year = 2003
)a ON prs.ilkid = a.ilkid GROUP BY prs.tid) b ON t.tid = b.tid;

--Q10: from the hint given in the question ORDER BY and LIMIT are used to write the following query with an additional descending order condition.

SELECT p.lastname,p.firstname,p.pts FROM player_rs_career p ORDER BY p.pts desc limit 5;

--Q11: LIMIT is used here as well as learned from the previous question and the effeciency is calclated

SELECT prsc.firstname,prsc.lastname,(prsc.pts/prsc.minutes) AS effeciency FROM player_rs_career prsc WHERE prsc.minutes > 50 ORDER BY (effeciency) desc limit 1;

--Q12: This query can be solved by simple union operation and then projecting the maximum value by using the order by and limit functions.

SELECT c3.firstname,c3.lastname,c3.season_win FROM coaches_season c3 WHERE c3.year=1994 and c3.cid IN ( SELECT c1.cid FROM coaches_season c1 WHERE c1.firstname = 'PHIL' AND c1.lastname='Jackson' AND C1.year=1994 UNION SELECT c2.cid FROM coaches_season c2 WHERE c2.firstname = 'Allan' AND c2.lastname = 'Bristow' AND c2.year = 1994) ORDER BY c3.season_win desc limit 1;


