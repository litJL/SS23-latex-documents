WITH semesterAvg (
	semester,
	averageNote
) AS (
	SELECT DISTINCT
		s1.semester,
		avg(p.note)
	FROM
		studenten s1
		JOIN pruefen p ON s1.matrnr = p.matrnr
	GROUP BY
		s1.semester
) SELECT DISTINCT
	s.name,
	s.semester,
	sa.averageNote
FROM
	studenten s,
	semesterAvg sa
WHERE
	s.semester = sa.semester;

WITH profUnbestanden (
	name,
	anzahl
) AS (
	SELECT DISTINCT
		p1.name,
		count(*) AS anzahl
	FROM
		professoren p1
		JOIN pruefen pr ON p1.persnr = pr.persnr
	WHERE
		pr.note = 5.0
	GROUP BY
		p1.name
)
SELECT
	p.name,
	(
		SELECT
			sum(pu1.anzahl)
		FROM
			profUnbestanden pu1
		WHERE
			pu.anzahl <= pu1.anzahl
	) AS unbestanden
FROM
	professoren p,
	profUnbestanden pu
WHERE
	p.name = pu.name
ORDER BY
	unbestanden;