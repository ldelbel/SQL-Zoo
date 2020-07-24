-- 1. How many stops are in the database

SELECT COUNT(*)
FROM stops

-- 2. Find the id value for the stop 'Craiglockhart'

SELECT id FROM stops
WHERE name = 'Craiglockhart'

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.

SELECT stops.id, stops.name
FROM route JOIN stops ON stops.id = stop
WHERE num = '4' AND company = 'LRT'

-- 4. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2

-- 5. Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = (SELECT id FROM stops
                              WHERE name = 'London Road')

-- 6. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'  AND stopb.name = 'London Road'

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT a.company, a.num
FROM route a JOIN route b ON (a.company=b.company AND 
a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name = 'Haymarket' AND stopb.name = 'Leith'
GROUP BY a.company, a.num

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT a.company, a.num
FROM route a JOIN route b ON (a.company=b.company AND 
a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross'
GROUP BY a.company, a.num

-- 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company.

SELECT stopb.name, a.company, a.num
FROM route a JOIN route b ON (a.company=b.company AND 
a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE a.company = 'LRT' AND stopa.name = 'Craiglockhart'

-- 10. Find the routes involving two buses that can go from Craiglockhart to Lochend. Show the bus no. and company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus.

SELECT DISTINCT a.num, a.company, transfer1.name, d.num, d.company

FROM route a 
JOIN route b ON (a.company=b.company AND a.num=b.num)
JOIN route c ON (b.stop=c.stop)
JOIN route d ON (c.company=d.company AND c.num=d.num)
JOIN stops stopsa ON (stopsa.id = a.stop)
JOIN stops transfer1 ON (transfer1.id = b.stop)
JOIN stops transfer2 ON (transfer2.id=c.stop)
JOIN stops stopsb ON (stopsb.id=d.stop)

WHERE stopsa.name = 'Craiglockhart'
AND stopsb.name = 'Lochend'
AND transfer1.name = transfer2.name
ORDER BY a.num, transfer1.name