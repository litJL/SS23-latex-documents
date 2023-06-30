CREATE MATERIALIZED VIEW notenpartner (
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