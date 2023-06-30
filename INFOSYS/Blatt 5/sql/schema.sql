create table x(
	a integer,
	b integer
);
create table y(
	b integer,
	c integer
);
create table x_default(
	a_default integer,
	b_default integer
);
create table y_default(
	b_default integer,
	c_default integer
);
insert into x (a,b) values (1,2),(9,8);
insert into y (b,c) values (2,3),(7,6);
insert into x_default (a_default,b_default) values (0,0);
insert into y_default (b_default,c_default) values (0,0);