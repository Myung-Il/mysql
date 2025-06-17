-- 저장 프로그램
-- 삽입 작업을 하는 프로시저
delimiter //
create procedure InsertBook(
	in mybookid    integer,
    in mybookname  varchar(40),
    in mypublisher varchar(40),
    in myprice     integer
)
begin
	insert into book(bookid, bookname, publisher, price)
	values(mybookid, mybookname, mypublisher, myprice);
end;
// delimiter ;
/* 프로시저 InsertBook을 테스트하는 부분 */
call InsertBook(13, "스포츠과학", "마당과학서점", 25000);
select * from book;


-- 제어문을 사용하는 프로시저
delimiter //
create procedure BookInsertOrUpdate(
	in mybookid    integer,
    in mybookname  varchar(40),
    in mypublisher varchar(40),
    in myprice     int
)
begin
	declare mycount integer;
	select count(*) into mycount from book where bookname like mybookname;
	if mycount !=0 then set sql_safe_updates=0; -- delete, update 연산에 필요한 설정문
		update book set price = myprice where bookname like mybookname;
	else 
		insert into book(bookid, bookname, publisher, price)
		values(mybookid, mybookname, mypublisher, myprice);
	end if;
end;
// delimiter ;
/* BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분 */
call BookInsertOrUpdate(15, "스포츠 즐거움", "마당과학서점", 25000);
select * from book;
/* BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분 */
call BookInsertOrUpdate(15, "스포츠 즐거움", "마당과학서점", 20000);
select * from book;


-- 결과를 반환하는 프로시저
delimiter //
create procedure Averageprice(
	out AverageVal integer
)
begin
	select avg(price) into AverageVal from book where price is not null;
end;
// delimiter ;
/* 프로시저 Averageprice를 테스트하는 부분 */
call Averageprice(@myValue);
select @myValue;


-- 커서를 사용하는 프로시저
delimiter //
create procedure Interest()
begin
	declare myInterest integer default 0.0;
    declare price integer;
    declare endOfRow boolean default false;
    declare InterestCursor cursor for select saleprice from orders;
    declare continue handler for not found set endOfRow=true;
    
    open InterestCursor;
    cursor_loop: loop
		fetch InterestCursor into price;
        if endOfRow then leave cursor_loop;
        end if;
        if price >= 30000 then set myInterest = myInterest + price * 0.1;
        else set myInterest = myInterest + price * 0.05;
        end if;
	end loop cursor_loop;
    close InterestCursor;
    select concat("전체 이익 금액 =", myInterest) result;
end;
// delimiter ;
/* Interest 프로시저를 실행하여 판매된 도서에 대한 이익금을 계산 */
call Interest();


-- 트리거
set global log_bin_trust_function_creators=on;
create table Book_log(
	bookid_l    integer,
    bookname_l  varchar(40),
    publisher_l varchar(40),
    price_l     integer
);
delimiter //
create trigger AfterInsertBook after insert on book for each row
begin
	declare average integer;
    insert into Book_log values(new.bookid, new.bookname, new.publisher, new.price);
end;
// delimiter ;
/* 삽입한 내용을 기록하는 트리거 확인 */
insert into book values(14, "스포츠 과학 1", "이상미디어", 25000);
select * from book where bookid=14;
select * from book_log where bookid_l=14;


-- 사용자 정의 함수
delimiter //
create function fnc_Interest(
	price integer
) returns int
begin
	declare myInterest integer;
    -- 가격이 30,000원 이상이면 10%, 30,000원 미만이면 5%
    if price >= 30000 then set myInterest = price * 0.1;
    else set myInterest = price * 0.05;
    end if;
    return myInterest;
end;
// delimiter ;
/* orders 테이블에서 각 주문에 대한 이익을 출력 */
select custid, orderid, saleprice, fnc_interest(saleprice) from orders;