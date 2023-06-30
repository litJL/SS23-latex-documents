ALTER TABLE pruefen
	ADD startzeitpunkt timestamp,
	ADD endzeitpunkt timestamp;

CREATE OR REPLACE FUNCTION terminVergabe ()
	RETURNS TRIGGER
	AS $$
DECLARE
	spaetesterTermin TIMESTAMP := CURRENT_TIMESTAMP;
	szp TIMESTAMP;
	ezp TIMESTAMP;
	examDuration INT;
BEGIN
	IF NOT new.startzeitpunkt = NULL AND NOT new.endzeitpunkt = NULL THEN
		RETURN new;
	END IF;
	FOR szp, ezp 
  IN(
		SELECT
			p.startzeitpunkt, p.endzeitpunkt 
    FROM 
      pruefen p
		WHERE
			p.matrnr = new.matrnr
			OR p.persnr = new.persnr
			AND p.startzeitpunkt IS NOT NULL
			AND p.endzeitpunkt IS NOT NULL)
	LOOP
		IF szp > spaetesterTermin THEN
			spaetesterTermin := szp;
		END IF;
		IF ezp > spaetesterTermin THEN
			spaetesterTermin := ezp;
		END IF;
	END LOOP;
	examDuration := 6 * new.ects;
  IF examDuration < 15 THEN
		examDuration := 15;
	ELSIF examDuration > 45 THEN
		examDuration := 45;
	END IF;
  new.startzeitpunkt := spaetesterTermin + interval '1 hour';
	new.endzeitpunkt := new.startzeitpunkt + examDuration * INTERVAL '1 minute';
	RETURN new;
END
$$
LANGUAGE plpgsql;
CREATE TRIGGER tv
	BEFORE INSERT ON pruefen
	FOR EACH ROW
	EXECUTE PROCEDURE terminVergabe();