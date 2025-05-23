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
select * from students where grade = 2 or grade = 3;  -- 위와 같은 결과
select * from students where grade in (1, 2);         -- 괄호 안에 있는 학년만 조회
select * from students where grade not in (1, 2);     -- 괄호 안에 없는 학년만 조회
select * from students where name like '%label%';     -- 문자열 조회, %%로 감싸면 철자 조회
select * from students where name like '__ab_l%';     -- 문자열 조회, _를 이용해 대략적인 단어 조회
select * from students where name like '__ab_l';      -- 문자열 조회, 해당 패턴으로 끝나는 단어 조회
-- '[0-5]%'0~5사이 숫자로 시작하는 문자열 조회
-- '[^0-5]%'0~5사이 외의 문자열 조회
select * from students order by class, grade; -- 반, 학년 순으로 기준으로 정렬
select * from students order by number desc;  -- 번호를 기준으로 내림차순 정렬 (asc는 오름차순)

-- 집계 함수를 사용해보기 전에 자률를 추가해준다
update students
set koreanLanguage = 100, mathematics = 89, english = 98
where name = 'For';

update students
set koreanLanguage = 53, mathematics = 34, english = 67
where name = 'Area';

update students
set koreanLanguage = 24, mathematics = 98, english = 31
where name = 'Xlabel';

update students
set koreanLanguage = 43, mathematics = 87, english = 55
where name = 'Ylabel';

update students
set koreanLanguage = 100, mathematics = 100, english = 98
where name = 'Bool';

update students
set koreanLanguage = 84, mathematics = 3, english = 11
where name = 'Binary';

select * from students;

-- 집계 함수
select sum(koreanLanguage) from students;                                 -- 전체 학생의 국어 점수
select sum(koreanLanguage) as '국어 점수 총합' from students;                 -- 전체 학생의 국어 점수, 타이틀 작성
select sum(koreanLanguage) as '국어 점수 총합' from students where grade = 2; -- 2학년 학생의 국어 점수, 타이틀 작성

select
sum(koreanLanguage) as '국어 점수 총합',
avg(mathematics) as '수학 평균',
min(english) as '영어 최저 점수',
max(english) as '영어 최고 점수'
from students;

select count(grade) from students where grade = 2; -- 2학년 학생 수

select                        -- 조회를 하겠다
grade,                        -- grade와
count(grade) as '학생 수',      -- 각 한년 수와
sum(english) as '영어 시험 총합' -- 각 영어 총합으로
from students                 -- 테이블을
group by grade;               -- 단, grade를 기준으로 정리하고나서

select                        -- 조회를 하겠다
grade,                        -- grade와
count(grade) as '학생 수',      -- 각 한년 수와
sum(english) as '영어 시험 총합' -- 각 영어 총합으로
from students                 -- 테이블을
group by grade                -- 단, grade를 기준으로 정리하고나서 - 그룹의 기준
having grade > 2;             -- 단, 2학년 위로                - 그룹의 조건