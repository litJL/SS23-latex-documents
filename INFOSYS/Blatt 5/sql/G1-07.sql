select v.titel, count(s.matrnr) as anz_hoerer -- Aufgabe 1 a)
from studenten s join hoeren h 
on s.matrnr = h.matrnr join vorlesungen v 
on h.vorlnr = v.vorlnr 
group by v.titel 
order by anz_hoerer desc limit 5;

select s.matrnr
from studenten s join pruefen p on s.matrnr = p.matrnr 
where p.note < 5 group by s.matrnr order by avg(p.note)
limit 3;

select p.name
from professoren p join vorlesungen v 
on p.persnr = v.gelesen_von 
where v.titel 
like '%systeme';

drop table assistenten; -- b)

alter table professoren
add gebaeude integer check (gebaeude > 0),
add raumnr integer check (raumnr > 0);

alter table pruefen
add ects integer;

update pruefen set ects = 2 * vorlesungen.sws 
from vorlesungen
where pruefen.vorlnr = vorlesungen.vorlnr;

select gebaeude -- Aufgabe 2 
from professoren p join pruefen pr on p.persnr = pr.persnr
group by gebaeude
order by count(*) asc
limit 1;

select distinct s.name
from studenten s join pruefen p on s.matrnr = p.matrnr
join voraussetzen v on p.vorlnr = v.nachfolger
left outer join pruefen p2 
on v.vorgaenger = p2.vorlnr and s.matrnr = p2.matrnr
where p2.note is null;

select distinct s.name
from studenten s join pruefen p1 on s.matrnr = p1.matrnr
join pruefen p2 on s.matrnr = p2.matrnr and p1.vorlnr = p2.vorlnr
where p1.note > 4 and p2.note < 5 and p2.note >= (
	select min(note)
	from pruefen p
	where p.matrnr = s.matrnr and note < 5
);

(select name, 'Doz.' as vermerk 
	from professoren)
	union
(select name, case 
	when (select count(*)
		from studenten s2 join pruefen p 
		on s2.matrnr = p.matrnr
		where s1.matrnr = s2.matrnr and p.note < 5) 
    >= (select count(*)
		from vorlesungen)
	then 'Abs.' 
	else null
	end as vermerk 
	from studenten s1 );

create table bool_table( -- Aufgabe 3
	a boolean,
	b boolean
);
insert into bool_table (a, b) values  (true, true),
                                      (true, false),
                                      (true, null),
                                      (false, true),
                                      (false, false),
                                      (false, null),
                                      (null, true),
                                      (null, false),
                                      (null, null);
select a,b,a and b from bool_table;

select
	coalesce(x.a, xd.a_default),
	coalesce(x.b, y.b, xd.b_default),
	coalesce(y.c, yd.c_default)
from x_default xd, y_default yd, x full outer join y
on x.b = y.b;

insert into myview1(id, title, submission_date) -- Aufgabe 4
values(2,'test','2022-02-02');

insert into 
  myview3 (id, title, submission_date, posting_id, no, content)
values (4,'test2','2023-04-04',4,1,'this is content');

