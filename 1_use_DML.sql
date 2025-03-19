-- 데이터 조작어 – 삽입, 수정, 삭제

-- 삽입
insert into students(grade, class, number, name)
values(3, 6, 6, "Bool");

insert into students(grade, class, number, name)
values(1, 10, 17, "For");

insert into students(grade, class, number, name)
values(2, 1, 25, "Xlabel");

-- 내용을 자동으로 정렬한다, 왜지?
-- 지우고 다시 해보자
select * from students;

-- 기본적으로 학년, 반, 번호가 있어야 하는데 없어서 생긴 문제이다
insert into students(name)
values("While");


-- 삭제
delete from students where grade=1;
delete from students where grade=2;
delete from students where grade=3;

-- 계속 정렬이 된다..., 비슷한 값을 너어보자
select * from students;

insert into students(grade, class, number, name)
values(2, 1, 26, "Ylabel");
insert into students(grade, class, number, name)
values(2, 1, 5, "Area");

-- 계속 정렬이 된다, 왜?
-- 찾아봤는데, 내부에서 자동으로 되는거 같다더라
select * from students;

insert into students
values(4, 6, 8, "Binary", 0, 100, 90);

-- 이런 것도 있다더라
select * from students;


-- 수정
-- 해당 기능은 안전하게 내용을 수정하는 기능인데
-- 최신 버전에서는 수동으로 해줘야한다고 한다
set sql_safe_updates = 0;
update students
set koreanLanguage = '73'
where (grade, class, number) = (2, 1, 5);

-- 기본키만 되는 줄 알았는데 아니였다
-- 한꺼번에 변경되서 놀랐다
update students
set koreanLanguage = '0'
where grade = 2;

-- update 쿼리 내에서 같은 테이블이 서브 테이블이 될 수 없다고 한다
-- 만약 괄호 안에 students가 students_copy였다면 가능하다는 이야기다
update students
set koreanLanguage = (
select koreanLanguage
from students
)
where grade = 2;

select * from students;
