select gebaeude
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