-- 외부 조인

select * from students;
select * from teacher;

-- 담담 학생이 없는 선생을 포함해서 선생과 학생의 이름을 매칭시키기
select teacher.name, students.name
from teacher left outer join students
on teacher.grade=students.grade and teacher.class=students.class;

select teacher.name, students.name
from teacher right outer join students
on teacher.grade=students.grade and teacher.class=students.class;

-- full도 있으나 MySQL에는 적용되지 않는다