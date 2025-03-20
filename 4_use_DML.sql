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

