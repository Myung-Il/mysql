-- 부속 질의

select * from students;
select * from teacher;

-- 두 질의를 하나로 만드는 것
select max(mathematics) from students;           -- 최고 점수
select name from students where mathematics=100; -- 최고 점수를 가진 학생

select name from students where mathematics = ( -- 해당 수학 점수를 가지고 있는 학생 조회
select max(mathematics) from students           -- 수학 점수가 최대인,
);

select name from teacher where (grade, class) in ((1, 10), (2, 1), (2, 6), (3, 6), (4, 6));
select name from teacher where (grade, class) in (
select grade, class from teacher
);

-- 위에 만든 것들처럼 2중도 되지만 3중도 된다는 것을 알아야한다

-- 각 학년 학생의 수학 점수와 학년의 수학 평균 점수를 비교하기 위해서 만든 쿼리
select st1.grade, st1.name, mathematics, st2.math from students st1 left outer join ( -- 학년, 이름, 수학 점수, 평균을 외부 조인
select grade, avg(mathematics) as math from students group by grade                   -- 학년, 평균 조회 쿼리 생성
) st2 on st1.grade=st2.grade;                                                         -- 학년이 같은 투플끼리 연결

select st1.name from students st1 where st1.mathematics >= (            -- 수학 점수가 학년 평균보다 높다면 이름을 조회한다
select avg(st2.mathematics) from students st2 where st1.grade=st2.grade -- st1에서 조회한 학년과 st2에서 찾을 학년이 같으면 평균을 낸다
);