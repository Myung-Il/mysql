-- 조인
select * from students, teacher;
select * from teacher, students;

select * from students, teacher
where students.grade=teacher.grade;

-- 새로운 학생과 선생
insert into students(grade, class, number, name, koreanLanguage, mathematics, english)
values (1, 3, 15, 'MySQL', 76, 22, 100);

insert into teacher(grade, class, name)
values (2, 1, 'Season');

select * from students, teacher
where students.grade=teacher.grade
and students.class=teacher.class;

-- 복합 조인
select teacher.name, count(students.name) -- 선생님 이름을 기준으로 학생 수 세기
from students, teacher                    -- 학생 테이블과 선생 테이블 조회
where students.grade=teacher.grade        -- 학년 매칭
and students.class=teacher.class          -- 반 매칭
group by teacher.name                     -- 해당 선생들을 기준으로 삼음
order by count(*) desc;                   -- 학생 수를 기준으로 정렬, 오름차순