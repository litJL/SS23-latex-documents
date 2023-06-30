SELECT DISTINCT　-- Aufgabe 1
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

  WITH semesterAvg ( -- Aufgabe 2
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

CREATE MATERIALIZED VIEW notenpartner ( -- Aufgabe 3
	p1,
	p2)
AS (
	SELECT DISTINCT
		s1.matrnr AS student1,
		s2.matrnr AS student2
	FROM
		studenten s1
		JOIN pruefen p1 ON s1.matrnr = p1.matrnr,
		studenten s2
		JOIN pruefen p2 ON s2.matrnr = p2.matrnr
	WHERE
		NOT p1.matrnr = p2.matrnr
		AND s1.semester = s2.semester
		AND p1.persnr = p2.persnr
		AND p1.vorlnr = p2.vorlnr
		AND p1.note - p2.note <= 0.3
		AND p1.note - p2.note >= - 0.3
)
WITH RECURSIVE transitivPartner (
	matrnr,
	iter
) AS (
	SELECT DISTINCT
		p2,
		1
	FROM
		notenpartner
	WHERE
		p1 = 94823
	UNION ALL SELECT DISTINCT
		np.p2,
		tp.iter + 1
	FROM
		notenpartner np,
		transitivPartner tp
	WHERE
		np.p1 = tp.matrnr
		AND NOT np.p2 = tp.matrnr
		AND tp.iter < 10
) SELECT DISTINCT
	s.name
FROM
	transitivPartner tp
	JOIN studenten s ON tp.matrnr = s.matrnr;

WITH RECURSIVE transitivPartner (
	matrnr,
	iter
) AS (
	SELECT DISTINCT
		p2,
		1
	FROM
		notenpartner
	WHERE
		p1 = 94823
	UNION ALL SELECT DISTINCT
		np.p2,
		tp.iter + 1
	FROM
		notenpartner np,
		transitivPartner tp
	WHERE
		np.p1 = tp.matrnr
		AND NOT np.p2 = tp.matrnr
		AND tp.iter < 10
) SELECT DISTINCT
	count(DISTINCT s.name)
FROM
	transitivPartner tp
	JOIN studenten s ON tp.matrnr = s.matrnr;