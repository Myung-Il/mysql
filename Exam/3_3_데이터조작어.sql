-- select / from
-- 모든 도서의 이름과 가격을 검색하시오.
select bookname, price from book;

-- 모든 도서의 도서번호, 도서이름, 출판사, 가격을 검색하시오.
select bookid, bookname, publisher, price from book;
select * from book; -- 전체 출력

-- 도서 테이블에 있는 모든 출판사를 검색하시오
select publisher from book;
select distinct publisher from book; -- 중복 제거

-- where
-- 가격이 20,000원 미만인 도서를 검색하시오.
select * from book where price < 20000;

-- 가격이 10,000원 이상이고 20,000원 이하인 도서를 검색하시오.
select * from book where price between 10000 and 20000; -- 범위 지정
select * from book where 10000<=price and price<=20000; -- 논리 연산자

-- 출판사가 '굿스포츠' 혹은 '대한미디어'인 도서를 검색하시오.
select * from book where publisher in ('굿스포츠', '대한미디어');

-- '축구의 역사'를 출간한 출판사를 검색하시오.
select bookname, publisher from book where bookname like '축구의 역사';

-- 도서이름에 '축구'가 포함된 출판사를 검색하시오.
select bookname, publisher from book where bookname like '%축구%'; -- 포함된 문자열

-- 도서이름의 왼쪽 두 번째 위치에 '구'라는 문자열을 갖는 도서를 검색하시오.
select bookname from book where bookname like '_구%';

-- 축구에 관한 도서 중 가격이 20,000원 이상인 도서를 검색하시오.
select * from book where bookname like '%축구%' and price>=20000;

-- 출판사가 '굿스포츠' 혹은 '대한미디어'인 도서를 검색하시오.
select * from book where publisher='굿스포츠' or publisher='대한미디어';

-- order by
-- 도서를 이름순으로 검색하시오.
select * from book order by bookname;

-- 도서를 가격순으로 검색하고 가격이 같으면 이름순으로 검색하시오.
select * from book order by price, bookname;

-- 도서를 가격의 내림차순으로 검색하시오, 가격이 같다면 춢판사를 오름차순으로 출력하시오.
select * from book order by price desc, publisher;

-- 집계 함수
-- group by
-- 고객이 주문한 도서의 총판매액을 구하시오.
select sum(saleprice) from orders;
select sum(saleprice) as 총매출 from orders;

-- 2번 김연아 고객이 주문한 도서의 총판매액을 구하시오.
select sum(saleprice) as 총매출 from orders where custid=2;

-- 고객이 주문한 도서의 총판매액, 평균값, 최저값, 최고가를 구하시오.
select sum(saleprice) as 총매출, avg(saleprice) as 평균값, min(saleprice) as 최저값, max(saleprice) as 최고가 from orders;

-- 마당서점의 도서 판매 건수를 구하시오.
select count(*) from orders;

-- 고객별로 주문한 도서의 총수량과 총판매액을 구하시오.
select custid, count(*) as 도서수량, sum(saleprice) as 총액 from orders group by custid;

-- 가격이 8,000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총수량을 구하시오. 단, 2권 이상 구매한 고객에 대해서만 구핫시오.
select custid, count(*) as 총수량 from orders where saleprice>=8000 group by custid having 총수량>=2;

-- 조인
select * from customer, orders;

-- 고객과 고객의 조문에 관한 데이터를 모두 나타내시오.
select * from customer, orders where customer.custid=orders.custid;

-- 고객과 고객의 주문에 관한 데이터를 고객별로 정렬하여 나타내시오.
select * from customer, orders where customer.custid=orders.custid order by customer.custid;

-- 고객의 이름과 고객이 주문한 도서의 판매가격을 검색하시오.
select name, saleprice from customer, orders where customer.custid=orders.custid;

-- 고객별로 주문한 모든 도서의 총판매액을 구하고, 고객별로 정렬하시오.
select name, sum(saleprice) as 총액 from customer, orders where customer.custid=orders.custid group by name order by name;

-- 고객의 이름과 고객이 주문한 도서의 이름을 구하시오.
select name, bookname from customer, orders, book where customer.custid=orders.custid and orders.bookid=book.bookid;

-- 가격이 20,000원인 도서를 주문한 고객의 이름과 도서의 이름을 구하시오.
select name, bookname from customer, orders, book where customer.custid=orders.custid and orders.bookid=book.bookid and price=20000;

-- 도서를 구매하지 않은 고객을 포함해 고객의 이름과 고객이 주문한 도서의 판매가격을 구하시오.
select name, saleprice from customer left outer join orders on customer.custid=orders.custid;

-- 부속 질의
-- 가장 비싼 도서의 이름을 나타내시오.
select bookname from book where price=(select max(price) from book);

-- 도서를 구매한 적이 있는 고객의 이름을 검색하시오.
select name from customer where custid in (select custid from orders);

-- 대한미디어에서 출판한 도서를 구매한 고객의 이름을 나타내시오.
select name from customer where custid in (
select custid from orders where bookid in (
select bookid from book where publisher like "%대한미디어%"));

-- 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.
select bookname from book b1 where price > (select avg(price) from book b2 where b1.publisher=b2.publisher);

-- 집합 연산
-- 대한민국에 거주하는 고객의 이름과 도서를 주문한 고객의 이름을 나타내시오.
select name from customer where address like "%대한민국%"
union -- 마지막에 all을 추가하면 중복 제거 되지 않는다.
select name from customer where custid in (select custid from orders);

-- exists
-- 주문이 있는 고객의 이름과 주소를 나타내시오.
select name, address from customer where exists (select * from orders where customer.custid=orders.custid); -- 조건에 맞는게 한번이라도 나오면 True
select name, address from customer where custid in (select custid from orders);                             -- 전부를 보고 계산함