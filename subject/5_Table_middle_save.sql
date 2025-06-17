DROP DATABASE MovieDB;
CREATE DATABASE MovieDB;
USE MovieDB;

-- 1. Customer(o)
-- -------------------------------------------------------------------------------------
-- customer_name에 NULL이 들어갈 경우, customer_id로 자동 채우는 트리거 예정
-- -------------------------------------------------------------------------------------
CREATE TABLE Customer (
    customer_id VARCHAR(20) NOT NULL,
    PRIMARY KEY (customer_id),
    customer_password VARCHAR(20),
    customer_tier ENUM('Unrank', 'Bronze', 'Silver', 'Gold') DEFAULT 'Unrank' NOT NULL,
    customer_phone VARCHAR(20) NOT NULL UNIQUE CHECK (customer_phone REGEXP '^[0-9-]+$'),
    customer_name VARCHAR(45),
    customer_gender ENUM('Male', 'Female'),
    customer_birth DATE
);

-- 2. Credit(o)
-- -------------------------------------------------------------------------------------
-- customer_id NOT NULL로 설정
-- 고객 삭제 시 카드 정보도 같이 삭제되도록 ON DELETE CASCADE 설정
-- -------------------------------------------------------------------------------------
CREATE TABLE Credit (
    credit_cardnum VARCHAR(20),
    PRIMARY KEY (credit_cardnum),
    credit_cvc CHAR(3) NOT NULL,
    credit_valid CHAR(5) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
        ON DELETE CASCADE  -- 고객 삭제 시 카드 정보도 삭제되도록 설정
);
-- 

-- 3. Theater(o)
-- -------------------------------------------------------------------------------------
-- 고유한 theater_name, theater_phone 설정
-- 전화번호 형식은 숫자 또는 '-'만 허용
-- -------------------------------------------------------------------------------------
CREATE TABLE Theater (
    theater_name VARCHAR(20) NOT NULL,
    PRIMARY KEY (theater_name),
    theater_managername VARCHAR(20) NOT NULL,
    theater_phone VARCHAR(20) NOT NULL UNIQUE CHECK (theater_phone REGEXP '^[0-9-]+$')
);

-- 4. Screen(o)
-- -------------------------------------------------------------------------------------
-- 지점별 상영관 번호 복합 PK
-- 음수가 아닌 좌석 수를 screen_seat로 정의
-- -------------------------------------------------------------------------------------
CREATE TABLE Screen (
    theater_name VARCHAR(20),
    FOREIGN KEY (theater_name) REFERENCES Theater(theater_name)
        ON DELETE CASCADE,
    screen_num INT,
    PRIMARY KEY (theater_name, screen_num),
    screen_seat INT NOT NULL,
    CHECK (screen_seat >= 0)
);

-- 5. Event(o)
-- -------------------------------------------------------------------------------------
-- 지점별 이벤트명을 복합 PK로 설정
-- 시작일은 자동으로 현재 시간(CURRENT_TIMESTAMP) 사용
-- 종료일이 시작일보다 같거나 늦어야 함

-- 스케줄러로 종료된 이벤트 자동 삭제 기능(1일마다)
-- << 스케줄러 작성 >>
-- 먼저 스케줄러 활성화 (한 번만)
-- SET GLOBAL event_scheduler = ON;
-- 자동 삭제 이벤트 생성
-- CREATE EVENT delete_expired_events
-- ON SCHEDULE EVERY 1 DAY
-- DO
--   DELETE FROM Event WHERE end_date < CURDATE();
-- -------------------------------------------------------------------------------------
CREATE TABLE Event (
    theater_name VARCHAR(20) NOT NULL,
    FOREIGN KEY (theater_name) REFERENCES Theater(theater_name)
        ON DELETE CASCADE,
    event_name VARCHAR(40),
    PRIMARY KEY (theater_name, event_name),
    event_startday DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 현재 시간을 디폴트로 지정
    event_endday DATETIME NOT NULL,
    CHECK (event_endday >= event_startday)
);

-- 6. Movie(o)
-- -------------------------------------------------------------------------------------
-- 장르는 ENUM으로 제한
-- 상영등급(movie_age)은 0, 12, 15, 19 중 선택
-- 상영 시간(movie_runtime)은 양수만 허용
-- -------------------------------------------------------------------------------------
CREATE TABLE Movie (
    movie_num INT AUTO_INCREMENT,
    movie_name VARCHAR(20) NOT NULL,
    movie_genre ENUM('Action', 'Comedy', 'Drama', 'Horror', 'Romance', 'Sci-Fi', 'Animation') NOT NULL,
    movie_age INT DEFAULT 0 NOT NULL CHECK (movie_age IN (0, 12, 15, 19)),
    movie_runtime INT CHECK (movie_runtime > 0),
    PRIMARY KEY (movie_num)
);

-- 7. Director(o)
CREATE TABLE Director (
    director_id INT AUTO_INCREMENT,
    director_name VARCHAR(20) NOT NULL,
    director_age INT CHECK (director_age >= 0),
    director_gender ENUM('Male', 'Female'),
    PRIMARY KEY (director_id)
);

-- 8. Director_has_Movie(o)
CREATE TABLE Director_has_Movie (
    director_id INT,
    movie_num INT,
    PRIMARY KEY (director_id, movie_num),
    FOREIGN KEY (director_id) REFERENCES Director(director_id)
        ON DELETE CASCADE,
    FOREIGN KEY (movie_num) REFERENCES Movie(movie_num)
        ON DELETE CASCADE
);

-- 9. Actor(o)
CREATE TABLE Actor (
    actor_id INT AUTO_INCREMENT,
    actor_name VARCHAR(20) NOT NULL,
    actor_age INT CHECK (actor_age >= 0),
    actor_gender ENUM('Male', 'Female'),
    PRIMARY KEY (actor_id)
);

-- 10. Actor_has_Movie(o)
CREATE TABLE Actor_has_Movie (
    actor_id INT,
    movie_num INT,
    PRIMARY KEY (actor_id, movie_num),
    FOREIGN KEY (actor_id) REFERENCES Actor(actor_id)
        ON DELETE CASCADE,
    FOREIGN KEY (movie_num) REFERENCES Movie(movie_num)
        ON DELETE CASCADE
);

-- 11. ScreeningInfo(o)
-- ---------------------------------------------------------------------------------------
-- 복합 PK: 지점명 + 상영정보 ID
-- UNIQUE 제약: 한 상영관(screen_num)에서 같은 시간에는 중복 상영 불가
-- 상영 가격은 0 이상
-- 트리거로 지점별 상영정보 ID 자동 증가 예정
-- ---------------------------------------------------------------------------------------
CREATE TABLE ScreeningInfo (
    theater_name VARCHAR(20) NOT NULL,
    screeninginfo_id INT,
    PRIMARY KEY (theater_name, screeninginfo_id),
    screen_num INT NOT NULL,
    FOREIGN KEY (theater_name, screen_num) REFERENCES Screen(theater_name, screen_num)
        ON DELETE CASCADE,
    screeninginfo_starttime DATETIME NOT NULL,
    UNIQUE KEY uk_screeninginfo (theater_name, screen_num, screeninginfo_starttime),
    screeninginfo_price INT NOT NULL CHECK (screeninginfo_price >= 0),
    movie_num INT NOT NULL,
    FOREIGN KEY (movie_num) REFERENCES Movie(movie_num)
        ON DELETE CASCADE
);

-- 12. Seat(o)
-- -------------------------------------------------------------------------------------
-- 복합 PK: 지점 + 상영정보 ID + 좌석 번호
-- 좌석 존재 여부(seat_isempty)는 0/1로 제약
-- -------------------------------------------------------------------------------------
CREATE TABLE Seat (
    theater_name VARCHAR(20) NOT NULL,
    screeninginfo_id INT,
    FOREIGN KEY (theater_name, screeninginfo_id) REFERENCES ScreeningInfo(theater_name, screeninginfo_id)
        ON DELETE CASCADE,
    seat_num VARCHAR(5),
    PRIMARY KEY (theater_name, screeninginfo_id, seat_num),
    seat_isempty TINYINT(1) NOT NULL CHECK (seat_isempty IN (0, 1))
);

-- 13. MovieOrder(o)
-- ---------------------------------------------------------------------------------------

-- 복합 PK: 지점 + 주문 번호
-- 구매 시각 기본값은 현재 시간
-- 상영정보 및 좌석과 FK 연결, 카드번호와도 FK 연결
-- 주문 상세 설명을 위한 detail 필드 포함
-- 트리거로 지점별 주문 번호 자동 증가 예정
-- ---------------------------------------------------------------------------------------
CREATE TABLE MovieOrder (
    theater_name VARCHAR(20) NOT NULL,
    movieorder_num INT,
    PRIMARY KEY (theater_name, movieorder_num),
    movieorder_purchasetime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 현재 시간을 디폴트로 지정
    movieorder_salesprice INT CHECK (movieorder_salesprice >= 0),
    movieorder_detail VARCHAR(100),
    screeninginfo_id INT NOT NULL,
    seat_num VARCHAR(5) NOT NULL,
    credit_cardnum VARCHAR(20) NOT NULL,
    FOREIGN KEY (theater_name, screeninginfo_id, seat_num) REFERENCES Seat(theater_name, screeninginfo_id, seat_num)
        ON DELETE CASCADE,
    FOREIGN KEY (credit_cardnum) REFERENCES Credit(credit_cardnum)
        ON DELETE CASCADE
);

-- 14. OrderLog
-- ---------------------------------------------------------------------------------------

-- 복합 PK: 지점 + 로그 번호
-- 주문/환불 타입 ENUM으로 제한, 기본값은 'order'
-- 시간은 기본 현재 시간
-- 트리거로 자동 기록 및 번호 증가 예정
-- ---------------------------------------------------------------------------------------
CREATE TABLE OrderLog (
    theater_name VARCHAR(20) NOT NULL,
    FOREIGN KEY (theater_name) REFERENCES Theater(theater_name)
        ON DELETE CASCADE,
    orderlog_num INT,
    PRIMARY KEY (theater_name, orderlog_num),
    orderlog_type ENUM('order', 'refund') DEFAULT 'order' NOT NULL,
    orderlog_time DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    orderlog_detail VARCHAR(500)
);

-- 15. Review(o)
-- -----------------------------------------------------------------------------------------------------------
-- 복합 PK: 영화 번호 + 리뷰 번호
-- 평점은 1~5점만 허용
-- MovieOrder와 연결 (특정 주문을 기반으로 리뷰 작성 가능)
-- 트리거로:
-- 1) MovieOrder에서 movie_num 자동 가져오기
-- 2) 영화별 review_num 자동 증가 예정
-- -----------------------------------------------------------------------------------------------------------
CREATE TABLE Review (
	movie_num VARCHAR(45),
    review_num INT,
    PRIMARY KEY (movie_num, review_num),
    review_rating INT NOT NULL CHECK (review_rating BETWEEN 1 AND 5),
    review_comment VARCHAR(500),
    theater_name VARCHAR(20) NOT NULL,
    movieorder_num INT NOT NULL,
    FOREIGN KEY (theater_name, movieorder_num) REFERENCES MovieOrder(theater_name, movieorder_num)
        ON DELETE CASCADE
);

-- 프로시저 부분
-- 주문이 들어오면 빈 좌석이 감소하는 것과 좌석이 찼다는 표시를 프로시저로 하면 트랜잭션 흐름이 명확하고 관리가 쉬워짐
-- 추가로 환불을 했을 때 MovieOrder 삭제, Seat 비우기, OrderLog에 기록 추가도 프로시저로 만들면 관리가 쉬워짐
DELIMITER //
-- 좌석 생성 프로시저
CREATE PROCEDURE generate_seats(
    IN p_theater_name VARCHAR(20),
    IN p_screeninginfo_id INT
)
BEGIN

    DECLARE row_letter CHAR(1);
    DECLARE seat_number INT;

    START TRANSACTION;

    SET row_letter = 'A';
    row_loop: WHILE row_letter <= 'G' DO
        SET seat_number = 1;
        seat_loop: WHILE seat_number <= 10 DO
            IF NOT EXISTS (
                SELECT 1 FROM Seat
                WHERE theater_name = p_theater_name
                  AND seat_num = CONCAT(row_letter, seat_number)
                  AND screeninginfo_id = p_screeninginfo_id
            ) THEN
                INSERT INTO Seat (theater_name, seat_num, screeninginfo_id, seat_isempty)
                VALUES (
                    p_theater_name,
                    CONCAT(row_letter, seat_number),
                    p_screeninginfo_id,
                    1
                );
            END IF;
            SET seat_number = seat_number + 1;
        END WHILE;
        SET row_letter = CHAR(ASCII(row_letter) + 1);
    END WHILE;

    COMMIT;
END //

DELIMITER ;

DELIMITER //
-- 좌석 예매 프로시저
DELIMITER $$

CREATE PROCEDURE make_order(
    IN p_theater_name VARCHAR(50),
    IN p_screeninginfo_id INT,
    IN p_seat_num VARCHAR(5),
    IN p_credit_cardnum VARCHAR(25),
    IN p_salesprice INT,
    IN p_movieorder_detail TEXT
)
BEGIN
    -- 변수 선언은 BEGIN 블록 시작 후 가장 먼저 와야 함
    DECLARE seat_status INT;
    DECLARE seat_exists INT;
    DECLARE max_order_num INT;
    DECLARE max_log_num INT;

    -- 트랜잭션 시작
    START TRANSACTION;

    -- 1. 좌석 존재 여부 확인 (해당 좌석을 잠금 처리하여 동시성 제어)
    SELECT COUNT(*) INTO seat_exists
    FROM Seat
    WHERE theater_name = p_theater_name
      AND screeninginfo_id = p_screeninginfo_id
      AND seat_num = p_seat_num
    FOR UPDATE;

    IF seat_exists = 0 THEN
        -- 좌석이 존재하지 않으면 예외 발생 및 트랜잭션 롤백
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '해당 좌석은 존재하지 않습니다.';
    ELSE
        -- 2. 좌석이 비어 있는지 확인 (동시성 제어를 위해 FOR UPDATE 사용)
        SELECT seat_isempty INTO seat_status
        FROM Seat
        WHERE theater_name = p_theater_name
          AND screeninginfo_id = p_screeninginfo_id
          AND seat_num = p_seat_num
        FOR UPDATE;

        IF seat_status = 0 THEN
            -- 이미 예약된 좌석이면 예외 발생
            ROLLBACK;
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '해당 좌석은 이미 예매되었습니다.';
        ELSE
            -- 3. movieorder_num 생성
            SELECT IFNULL(MAX(movieorder_num), 0) + 1 INTO max_order_num
            FROM MovieOrder
            WHERE theater_name = p_theater_name;

            -- 4. MovieOrder 테이블에 주문 등록
            INSERT INTO MovieOrder (
                theater_name, movieorder_num, movieorder_salesprice,
                movieorder_detail, screeninginfo_id, seat_num, credit_cardnum
            ) VALUES (
                p_theater_name, max_order_num, p_salesprice,
                p_movieorder_detail, p_screeninginfo_id, p_seat_num, p_credit_cardnum
            );

            -- 5. 좌석 상태 갱신 (빈 자리 → 예약됨)
            UPDATE Seat
            SET seat_isempty = 0
            WHERE theater_name = p_theater_name
              AND screeninginfo_id = p_screeninginfo_id
              AND seat_num = p_seat_num;

            -- 6. orderlog_num 생성
            SELECT IFNULL(MAX(orderlog_num), 0) + 1 INTO max_log_num
            FROM OrderLog
            WHERE theater_name = p_theater_name;

            -- 7. OrderLog 테이블에 로그 기록
            INSERT INTO OrderLog (
                theater_name, orderlog_num, orderlog_type, orderlog_detail
            ) VALUES (
                p_theater_name, max_log_num, 'order',
                CONCAT('예매: 좌석 ', p_seat_num, ', 상영정보 ID ', p_screeninginfo_id)
            );
        END IF;
    END IF;

    -- 트랜잭션 커밋
    COMMIT;
END //
DELIMITER ;


-- 함수 부분
-- 고객 티어를 계산해주는 함수를 작성
-- 누적 구매 금액을 기반으로 고객의 customer_tier를 자동으로 정해줄 수 있음
-- 트리거에서 호출하거나, 고객 정보 조회 시 사용 가능
DELIMITER //
-- 남은 좌석 호출 함수
CREATE FUNCTION get_remaining_seats(p_screeninginfo_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE remaining INT;

    SELECT COUNT(*) INTO remaining
    FROM Seat
    WHERE screeninginfo_id = p_screeninginfo_id AND seat_isempty = 1;

    RETURN remaining;
END //

DELIMITER ;

-- 추가 트리거 부분
-- 트리거는 대부분 위에 다 적어놨음
-- 위에 함수를 바탕으로 티어 갱신 트리거 작성
DELIMITER //
CREATE TRIGGER after_movieorder_insert
AFTER INSERT ON MovieOrder
FOR EACH ROW
BEGIN
    INSERT INTO OrderLog (
        user_action
    )
    VALUES (
        CONCAT('예약됨: ', NEW.credit_cardnum, '님이 ', NEW.screeninginfo_id,
               '번 상영에서 좌석 ', NEW.seat_num, '을 예약했습니다.')
    );
END //
DELIMITER ;
