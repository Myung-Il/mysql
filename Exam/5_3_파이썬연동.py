import pymysql

host = "127.0.0.1"
port = 3306
database = "madangdb"
username = "madang"
password = "madang"

conflag = True

try:
    print("데이터베이스 연결 준비")
    
    conn = pymysql.connect(host=host, port=port, database=database, user=username, passwd=password, charset='utf8')
    print("데이터베이스 연결 성공")
except:
    print("데이터베이스 연결 실패")
    conflag = False

if not conflag:exit()

curser = conn.cursor()
sqlstring = "select * from book;"
res = curser.execute(sqlstring)
data = curser.fetchall()

print('{0}\t{1:<} \t{2:<} \t{3:<}'.format("Book NO", "Book Name", "Publisher", "Price"))
for rowdata in data:
    print('{0}\t{1:<} \t{2:<} \t{3:<}'.format(rowdata[0], rowdata[1], rowdata[2], rowdata[3]))
curser.close()
conn.close()