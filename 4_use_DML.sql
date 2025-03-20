-- 데이터 조작어 select, DML(Data Manipulation Language)

select * from students;

-- 지금까지는 그냥 썼지만 기능이 다양해 다워볼까 한다
select name from students;

-- 위 처럼하면 students 테이블의 name을 조회한다
-- 한마디로 조회 예약어다

-- 이렇게 여러개도 된다
select name, koreanLanguage from students;

select class from students;          -- class에 대한 모든 정보
select distinct class from students; -- class에 대한 중복된 정보를 제회한 정보

-- where문을 이용해서 조건에 맞는 요소만 따로 찾는다
select * from students where grade = 2;

select * from students where grade = 2 and class = 1; -- 2학년이면서 1반인 사람만 조회
select * from students where grade between 2 and 3;   -- 학년이 2학년이거나 3학년만 조회
select * from students where grade in (1, 2);         -- 괄호 안에 있는 학년만 조회
select * from students where grade not in (1, 2);     -- 괄호 안에 없는 학년만 조회
select * from students where name like '%label%';     -- 문자열 조회, %%로 감싸면 철자 조회
select * from students where name like '__ab_l%';     -- 문자열 조회, _를 이용해 대략적인 단어 조회
select * from students where name like '__ab_l';      -- 문자열 조회, 해당 패턴으로 끝나는 단어 조회
-- '[0-5]%'0~5사이 숫자로 시작하는 문자열 조회
-- '[^0-5]%'0~5사이 외의 문자열 조회
