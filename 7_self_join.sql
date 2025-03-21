select * from students;

select info.grade, info.class, human.name
from students info, students human
where info.grade=human.grade
and info.class=human.class;

-- 셀프 조인의 좋은 예시는 아니지만 사용 방법이다
-- 실존하지 않는 가상의 테이블 info와 human을 만들어서 조인하는 방법이다

-- 원래는 필요한 정보 2개가 한 테이블에 있을 떄
-- 셀프 조인 시켜서 보는 방법이다