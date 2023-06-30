CREATE OR REPLACE FUNCTION checkVoraussetzung ()
	RETURNS TRIGGER
	AS $$
BEGIN
	IF EXISTS (
		SELECT
			*
		FROM
			hoeren h
		WHERE
			h.matrnr = new.matrnr
			AND h.vorlnr = new.vorlnr) THEN
		RETURN NEW;
	END IF;
	ABORT;
END
$$
LANGUAGE plpgsql;
CREATE TRIGGER cv
	BEFORE INSERT OR UPDATE ON pruefen
	FOR EACH ROW
	EXECUTE PROCEDURE checkVoraussetzung();

CREATE OR REPLACE FUNCTION delstud ()
	RETURNS void
	AS $$
DECLARE
	mnr INT;
BEGIN
	FOR mnr IN( SELECT DISTINCT
			failed.matrnr FROM (
				SELECT
					s.matrnr, 
          p.vorlnr, 
          count(*) AS anz 
        FROM 
          studenten s, pruefen p
				WHERE
					s.matrnr = p.matrnr
					AND p.note > 4
				GROUP BY
					s.matrnr, p.vorlnr) failed
			WHERE
				failed.anz > 2)
	LOOP
		DELETE FROM hoeren h where h.matrnr = mnr;
		DELETE FROM pruefen p where p.matrnr = mnr;
		DELETE FROM studenten s where s.matrnr = mnr;
	END LOOP;
END
$$
LANGUAGE plpgsql;


