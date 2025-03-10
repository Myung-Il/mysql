-- 최고 권한을 가진 계정을 이용해서 현재의 study 계정을 만듬 ( 이후 git에 올릴 떄 확인이 가능하지는 아직 모르겠음 )
-- study 계정은 현재 어떠한 권한도 없음, 일단 이상태로 공부를 시작함

create database gradeDB
CHARACTER SET utf8mb4       -- 이모티콘 지원
COLLATE utf8mb4_general_ci; -- 대소문자 구분 x

/*
13:30:39
create database gradeDB
CHARACTER SET utf8mb4       -- 이모티콘 지원
COLLATE utf8mb4_general_ci; -- 대소문자 구분 x
Error Code: 1044. Access denied for user 'study'@'%' to database 'gradedb'	0.000 sec
*/

-- 위 문제는 create database 권한이 없어서 생긴 문제라서 권한을 주면 된다
/*
root 계정의 Navigater(탐색기) 아래 Administration(관리자)로 들어간다
User and Privileges(사용자 및 권한)에서 study를 찾고 데이터베이스를 만들 수 있는 권한을 가진 기능을 찾아야한다
DBManager는 모든 DB에 대한 채우기 권한이다, 해당 역할을 주면 자동으로
- DBDesigner, DB를 생성하고 리버스 엔지니어링할 수 있는 권한
- BackupAdmin, 모든 DB를 백업하는 데 필요한 최소한의 권한
두 역할 또한 부여된다
*/
-- 다른 역할 들에 대한 정리는 따로 해볼 필요는 있어보인다

/*
20:31:19
create database gradeDB
CHARACTER SET utf8mb4       -- 이모티콘 지원
COLLATE utf8mb4_general_ci; -- 대소문자 구분 x
1 row(s) affected	0.015 sec
*/
-- 잘 생성되는 걸 볼 수 있다