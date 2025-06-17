-- SQL 내장 함수
-- 숫자 함수
-- -78과 +78의 절대값을 구하시오.
select abs(-78), abs(+78);

-- 4.875를 소수 첫째 자리까지 반올림한 값을 구하시오.
select round(4.875, 1);

-- 문자 함수
-- 고객별 평균 주문 금액을 100원 단위로 반올림한 값을 구하시오.
select custid 고객번호, round(sum(saleprice)/count(*), -2) 평균금액 from orders group by custid;

-- 도서 제목에 야구가 포함된 도서를 농구로 변경한 후 도서 목록을 나타내시오.
select bookid, replace(bookname, "야구", "농구") bookname, publisher, price from book;

-- 굿스포츠에서 출판한 도서의 제목과 제목의 문자 수, 바이트 수를 나타내시오.
select bookname, char_length(bookname) 문자수, length(bookname) 바이트수 from book where publisher="굿스포츠";

-- 마당서점의 고객 중에서 성이 같은 사람이 몇 명이나 되는지 알고 싶다. 성별 인원수를 구하시오.
select substr(name, 1, 1) 성, count(*) 인원 from customer group by 성;

-- 날짜ㆍ시간 함수
-- 마당서점은 주문일로부터 10일 후에 매출을 확정한다. 각 주문의 확정일자를 구하시오.
select orderid, orderdate, adddate(orderdate, interval 10 day)확정 from orders;

-- DBMS 서버에 설정된 현재 날짜와 시간, 요일을 확인하시오.
select sysdate(), date_format(sysdate(), '[ %y-%m-%d ] [ %a ] [ %h:%i ]') sysdate;

-- Null 값 처리
-- 이름, 전화번호가 포함된 고객 목록을 나타내시오. 단, 전화번호가 없는 고객은 "연락처없음"으로 표시하시오.
select name, ifnull(phone, "연락처없음") 연락처 from customer;

-- 행번호 출력
-- 고객 목록에서 고객번호, 이름, 전화번호를 앞의 2명만 나타내시오.
set @seq:=0;
select (@seq:=@seq+1) 순번, custid, name, phone from customer where @seq < 2;