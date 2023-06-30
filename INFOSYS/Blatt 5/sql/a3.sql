create table bool_table(
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