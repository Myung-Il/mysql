-- 데이터를 만들었니, 일단 잘 만들었는지 불러보도록 하겠다
-- SQL문에는 select라고 데이터를 검색 명령어가 있다

select * from gradedb;

/*
21:36:50
select * from gradedb
LIMIT 0, 1000	Error Code: 1146. Table 'gradedb.gradedb' doesn't exist	0.000 sec
*/

-- 테이블이 없어서 생긴 문제이기 때문에 테이블을 만들어주면 된다
create table students(
    grade          integer not null,
	number	       integer primary key,
    name           varchar(20) not null,
    koreanLanguage integer default null check(101>koreanLanguage>=0),
	mathematics    integer default null check(101>mathematics>=0),
	english        integer default null check(101>english>=0),
	koreanHistory  integer default null check(101>koreanHistory>=0)
);
-- 학생의 학년, 반, 번호, 이름
-- 국어, 수학, 영어, 한국사
-- 를 추가하려 했으니 반을 추가하지 않아서 따로 추가해보록 하겠다

ALTER TABLE students               -- 테이블 students를 수정하겠는 말이다
ADD COLUMN class INTEGER NOT NULL; -- 스키마에 class를 추가하는데 null값은 안된다는 말이다

-- 이제 결과를 봐보자
select * from students; -- students의 *(모든 것)을 선택(보겠다는 말)한다

-- 실행 시켜서 보면 알겠지만 class가 맨 마지막에 생긴다
-- 불편하니 테이블을 처음부터 만들도록 하겠다

-- 일단 삭제
DROP TABLE IF EXISTS students; -- students가 있으면 삭제하고 없으면 놔둔다(안전하게 지우는 코드)

create table students(
    grade          integer not null check(0<grade<=4),
    class          integer not null check(0<class<=2),
	number	       integer not null,
    name           varchar(20) not null,
    koreanLanguage integer default null check(0<=koreanLanguage<101),
	mathematics    integer default null check(0<=mathematics<101),
	english        integer default null check(0<=english<101),
    PRIMARY KEY (grade, class, number)
);
select * from students;
/*
integer : 학년, 반, 번호, 국어, 수학, 영어 / 한국사는 굳이 필요 없을거 같아서 지움
varchar : 이름

not null : 값으로 null을 쓸 수 없음
check() : 괄호 안의 조건을 상시 충족해야 됨
PRIMARY KEY : 복합 기본 키, 학생의 고유 식별 키
*/



