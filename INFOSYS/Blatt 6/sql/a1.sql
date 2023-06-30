SELECT DISTINCT
	s.name,
	s.semester,
	avg(p.note) OVER (PARTITION BY s.semester) AS avgnote
FROM
	studenten s
	JOIN pruefen p ON s.matrnr = p.matrnr
WHERE
	s.semester > 1;

WITH profUnbestanden (
	name,
	anzahl
) AS (
	SELECT DISTINCT
		p1.name,
		count(*) OVER (PARTITION BY p1.name) AS anzahl
	FROM
		professoren p1
		JOIN pruefen pr ON p1.persnr = pr.persnr
	WHERE
		pr.note = 5.0
) SELECT DISTINCT
	p.name, 
	sum(pu.anzahl) OVER (ORDER BY pu.anzahl DESC) AS unbestanden
FROM
	professoren p
	JOIN profUnbestanden pu ON p.name = pu.name
ORDER BY
	unbestanden;