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




