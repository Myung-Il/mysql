create table teacher(
	grade   integer not null,
    class   integer not null,
    name    varchar(10) not null,
    subject varchar(20),
    primary key (grade, class)
);

select * from students;
/*
1학년 10반
2학년 1반
3학년 6반
4학년 6반
*/

insert into teacher(grade, class, name, subject)
values (1, 10, 'Spring', 'english');

insert into teacher(grade, class, name, subject)
values (2, 6, 'Summer', 'mathematics');

insert into teacher(grade, class, name, subject)
values (3, 6, 'Fall', 'koreanLanguage');

insert into teacher(grade, class, name, subject)
values (4, 6, 'Winter', 'english');

select * from teacher;