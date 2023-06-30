select v.titel, count(s.matrnr) as anz_hoerer
from studenten s join hoeren h 
on s.matrnr = h.matrnr join vorlesungen v 
on h.vorlnr = v.vorlnr 
group by v.titel 
order by anz_hoerer desc limit 5;

select s.matrnr
from studenten s join pruefen p on s.matrnr = p.matrnr 
where p.note < 5 group by s.matrnr order by avg(p.note);

select p.name
from professoren p join vorlesungen v 
on p.persnr = v.gelesen_von 
where v.titel 
like '%systeme';

drop table assistenten;

alter table professoren
add gebaeude integer check (gebaeude > 0),
add raumnr integer check (raumnr > 0);

alter table pruefen
add ects integer;

update pruefen set ects = 2 * vorlesungen.sws 
from vorlesungen
where pruefen.vorlnr = vorlesungen.vorlnr;
