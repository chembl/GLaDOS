from django.http import HttpResponse
import cx_Oracle
import time

def test(request):
    
    dsnStr = cx_Oracle.makedsn("oradb", 1521, "xe")
    connection = cx_Oracle.connect(user="hr", password="hr", dsn=dsnStr)
    cursor = connection.cursor()
    cursor.execute("select sysdate from dual")
    today, = cursor.fetchone()
    
    
    return HttpResponse('hello {}'.format(today))