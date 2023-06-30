CREATE OR REPLACE FUNCTION vor() RETURNS TRIGGER AS $$ -- Aufgabe 2
BEGIN
  NEW.pnr := TG_ARGV[0] || NEW.pnr;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;
CREATE TRIGGER vorp
	BEFORE INSERT ON personal
	FOR EACH ROW
	EXECUTE PROCEDURE vor ('P');
CREATE TRIGGER vorm
	BEFORE INSERT ON manager
	FOR EACH ROW
	EXECUTE PROCEDURE vor ('M');

CREATE OR REPLACE FUNCTION cd() RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM mitarbeit m WHERE m.pnr = OLD.pnr;
  RETURN NULL;
END
$$ LANGUAGE plpgsql;
CREATE TRIGGER cd
AFTER DELETE ON personal
FOR EACH ROW
EXECUTE PROCEDURE cd();
CREATE TRIGGER cd
AFTER DELETE ON manager
FOR EACH ROW
EXECUTE PROCEDURE cd();

CREATE OR REPLACE FUNCTION checkVoraussetzung () -- Aufgabe 3
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

ALTER TABLE pruefen -- Aufgabe 4
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
