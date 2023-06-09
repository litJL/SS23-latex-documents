CREATE OR REPLACE FUNCTION vor() RETURNS TRIGGER AS $$
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