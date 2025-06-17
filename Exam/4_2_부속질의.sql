-- 중첩질의 - where 부속질의
-- 평균 주문금액 이하의 주문에 대해서 주문번호와 금액을 나타내시오.
select orderid, saleprice from orders where saleprice<=(select avg(saleprice) from orders);

-- 각 고객의 평균 주문금액보다 큰 금액의 주문 내역에 대해서 주문번호, 고객번호, 금액을 나타내시오.
select orderid, custid, saleprice from orders o1 where saleprice>(select avg(saleprice)from orders o2 where o1.custid=o2.custid);

-- 대한민국에 거주하는 고객에게 판매한 도서의 총판매액을 구하시오.
select sum(saleprice) total from orders where custid in (select custid from customer where address like "%대한민국%");

-- 3번 고객이 주문한 도서의 최고 금액보다 더 비싼 도서를 구입한 주문의 주문번호와 판매금액을 보이시오.
select orderid, saleprice from orders where saleprice> all (select saleprice from orders where custid=3);

-- exists 연산자를 사용하여 대한민국에 거주하는 고객에게 판매한 도서의 총판매액을 구하시오.
select sum(saleprice) from orders o where exists (select * from customer c where address like "%대한민국%" and o.custid=c.custid);

-- 스칼라 부속질의 - select 부속질의
-- 마당서점의 고객별 판매액을 나타내시오(고객이름과 고객별 판매액 출력).
select (select name from customer where customer.custid=orders.custid)name, sum(saleprice) from orders group by custid;

-- 인라인 뷰 - from 부속질의
-- 고객번호가 2 이하인 고객의 판매액을 나타내시오(고객이름과 고객별 판매액 출력).
select name, sum(saleprice) from (select * from customer where custid<=2) c, orders o where c.custid=o.custid group by name;