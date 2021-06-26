#importing the required libraries
import sqlite3 as db
import pandas as pd
import sys
import time
#making a connection to the sqlite database
connection=db.connect('LibraryMs.db')
#creating a cursor to excecute queries
cursor=connection.cursor()

def print_menu():
    print("""---Welcome to our college Library Management System!---
    Choose an option:
    1.Admin
    2.Student
    3.Print all the books

    9. To terminate
    """)
    response=int(input())
    if response==1:
        print("Admin:")
        print_Admin_login()
    elif response==2:
        print("Student:")
        print_student_login()
    elif response==3:
        print("Printing all the books:")
        print_books()
    else:
        print("Thank you for using our service!")
        connection.close()
        sys.exit()
    return
#Ordering a book
def order_book(student_id):
    try:
        Dept=input("Enter your Department (ECE,CSE,MECH,AUTO,AERO): ") #order only your dept books.
        Dept=Dept.upper()
        if Dept in ('ECE','CSE','MECH','AUTO','AERO'):
            command1="""select B.book_id,B.title,A.author_name
                        from author A,Books B where A.author_id=B.author_id and B.Department='{0}'""".format(Dept)
            print(pd.read_sql_query(command1,connection))
        else:
            raise ValueError("Enter a valid department!")
        idi=int(input("Enter the Book Id to Order: "))
        command2="""select availability from books where book_id={0}""".format(idi)
        t=cursor.execute(command2)
        lst=t.fetchall()
        Avail=lst[0][0]
        if(Avail):
            command3="""insert into orders (student_id,book_id) values ({0},{1})""".format(student_id,idi)
            cursor.execute(command3)
            connection.commit()
            time.sleep(1)
            command4="""Update books set availability=availability-1 where book_id={0}""".format(idi)
            cursor.execute(command4)
            connection.commit()
            time.sleep(2)
            print("The Book has been added to Your list. There are {} copies of this book remaining!!!".format(Avail))
        else:
            print("Oops!!! Currently there is no copy of this Book.")
    except Exception as e:
        print("Error occured: "+e)
        Student_logged_in(student_id)
    
#Returning a book
def returning_book(student_id):
    try:
        print("List of books that are not returned in your list:")
        query="""
        SELECT S.Student_name,B.Book_id,B.Title,O.Issue_date,
        date(O.Issue_date,'+14 day') as Due_Date,O.Return_date FROM ((Orders O INNER JOIN Student S ON O.Student_id=S.Student_id)
        INNER JOIN Books B ON O.Book_id=B.Book_id) WHERE S.Student_id={} AND O.Return_date='Not Returned'
        """.format(student_id)
        df=pd.read_sql_query(query,connection)
        print(df)
        li=[]
        for i in df['Book_id']:
            li.append(i)
        book_id=int(input("Enter the book_id to return that book: "))
        if book_id in li:
            command1="""Update books set availability=availability+1 where Book_id={}""".format(book_id)
            command2="""UPDATE Orders SET Return_date=date('now') WHERE Student_id={1} 
            AND Book_id={0}""".format(book_id,student_id)
            cursor.execute(command1)
            cursor.execute(command2)
            connection.commit()
            time.sleep(2)
            query1="""
            UPDATE Student SET Fine_amount=Fine_amount+
            (CAST((julianday('now')-julianday(
            (SELECT Issue_date FROM Orders WHERE Student_id={0} AND Book_id={1})))as INTEGER)*1.5)
            WHERE Student_id={0}
            """.format(student_id,book_id)
            cursor.execute(query1)
            connection.commit()
            time.sleep(1)
            print("The Book has been returned!! Check your fine amount!")
        else:
            raise ValueError("Enter Valid book id")
    except Exception as e:
        print("Error occured: "+e)
        Student_logged_in(student_id)

#Add book
def add_book(staff_id):
    try:
        book_title=input("Enter the Title of the Book: ")
        Dept=input("Enter your Department (ECE,CSE,MECH,AUTO,AERO): ")
        Aname=input("Enter the Name of the Author: ")
        Pub=input("Enter the Publisher of the Book: ")
        Pub_Year=int(input("Enter the Published Year: "))
        Avail=int(input("Enter the Number of copies to add: "))

        command1="""insert into Author(Author_name) Values ("{0}")""".format(Aname)
        cursor.execute(command1)
        connection.commit()
        time.sleep(1) #coz of async operation of exec,commit.(delete,update) doesn't provide error if wrong info is given.
        command2="""select author_id from author where Author_name='{0}'""".format(Aname)
        t=cursor.execute(command2)
        lst=t.fetchall()
        A_id=lst[0][0]  #fetches id
        connection.commit()
        time.sleep(1)
        command3="""insert into Books(Title, Department,
                    Author_id, Publisher, Year, Availability)
                    values('{0}','{1}',{2},'{3}',{4},{5})""".format(book_title
                    ,Dept,A_id,Pub,Pub_Year,Avail)
        cursor.execute(command3)
        connection.commit()
        time.sleep(2)
        print("The book has been added successfully!")
    except:
        print("Enter Valid Details!!!!")
        Admin_logged_in(staff_id)

#Deleting a book
def delete_book(staff_id):
    try:
        print_books()
        query="""select Book_id from Books"""
        df=pd.read_sql_query(query,connection)
        li=[]
        for i in df['Book_id']: # gets book id column only
            li.append(i)
        book_id=int(input("Enter the Book id: "))
        if book_id in li:
            command1="""delete from books where Book_id='{}'""".format(book_id)
            cursor.execute(command1)
            connection.commit()
            time.sleep(1)
            print("The book has been deleted!")
        else:
            raise ValueError("Enter a valid book_id")
    except Exception as e:
        print("Error has occured: "+e)
        Admin_logged_in(staff_id)

#Printing available books by Department
def print_books():
    print("""Choose the department:
    1) ECE
    2) CSE
    3) MECH
    4) AUTO
    5) AERO
    6) Print All the books
    """)
    try:
        response=int(input())
        if response==1:
            print("Electronics Department Books:")
            print(pd.read_sql_query("""
            SELECT B.Book_id,B.Title,A.Author_name,B.Publisher,B.Year,B.Availability 
            FROM Books B,Author A WHERE B.Department='ECE' 
            AND B.Author_id==A.Author_id;
          """,connection))
        elif response==2:
            print("Computer Science Department Books:")
            print(pd.read_sql_query("""
            SELECT B.Book_id,B.Title,A.Author_name,B.Publisher,B.Year,B.Availability 
            FROM Books B,Author A WHERE B.Department='CSE' 
            AND B.Author_id==A.Author_id;
          """,connection))
        elif response==3:
            print("Mechanical Department Books:")
            print(pd.read_sql_query("""
            SELECT B.Book_id,B.Title,A.Author_name,B.Publisher,B.Year,B.Availability 
            FROM Books B,Author A WHERE B.Department='MECH' 
            AND B.Author_id==A.Author_id;
          """,connection))
        elif response==4:
            print("Automobile Department Books:")
            print(pd.read_sql_query("""
            SELECT B.Book_id,B.Title,A.Author_name,B.Publisher,B.Year,B.Availability 
            FROM Books B,Author A WHERE B.Department='AUTO' 
            AND B.Author_id==A.Author_id;
          """,connection))
        elif response==5:
            print("Aeronautical Department Books:")
            print(pd.read_sql_query("""
            SELECT B.Book_id,B.Title,A.Author_name,B.Publisher,B.Year,B.Availability 
            FROM Books B,Author A WHERE B.Department='AERO' 
            AND B.Author_id==A.Author_id;
          """,connection))
        elif response==6:
            print("All available Books:")
            print(pd.read_sql_query("""
            SELECT B.Book_id,B.Title,A.Author_name,B.Publisher,B.Year,B.Availability 
            FROM Books B,Author A WHERE B.Author_id==A.Author_id ORDER BY B.Department;
          """,connection))
        else:
            print("Select a valid number")
            print_books()
    except:
        print("Enter a valid number!!")

#Admin Logged In
def Admin_logged_in(staff_id):
    print(""" Choose an option:
    1) Add a book
    2) Delete a book
    3) Print Books
    4) Print profile details

    8)Log out
    """)
    res=int(input())
    if res==1:
        print("Adding a book")
        add_book(staff_id)
        Admin_logged_in(staff_id)
    elif res==2:
        print("Deleting a book")
        delete_book(staff_id)
        Admin_logged_in(staff_id)
    elif res==3:
        print("Printing all the books:")
        print_books()
        Admin_logged_in(staff_id)
    elif res==4:
        print("Profile Details:")
        query="""select * from Admin where Staff_id={0}""".format(staff_id)
        print(pd.read_sql_query(query,connection))
        Admin_logged_in(staff_id)
    else:
        print("Successfully logged out!")
        print_menu()

#Student Logged In
def Student_logged_in(student_id):
    print(""" Choose an option:
    1) Order book
    2) Return a book
    3) See your Transaction history
    4) Print Books details
    5) Print profile details

    8)Log out
    """)
    res=int(input())
    if res==1:
        print("Ordering a book")
        order_book(student_id)
        Student_logged_in(student_id) 
    elif res==2:
        print("Returning a book")
        returning_book(student_id)
        Student_logged_in(student_id)
    elif res==3:
        print("Showing your transaction history:")
        query="""
        SELECT S.Student_name,B.Book_id,B.Title,O.Issue_date,
        date(O.Issue_date,'+14 day') as Due_Date,O.Return_date FROM ((Orders O INNER JOIN Student S ON O.Student_id=S.Student_id)
        INNER JOIN Books B ON O.Book_id=B.Book_id) WHERE S.Student_id={};
        """.format(student_id)
        print(pd.read_sql_query(query,connection))
        Student_logged_in(student_id)
    elif res==4:
        print("Printing all the books:")
        print_books()
        Student_logged_in(student_id)
    elif res==5:
        print("Profile Details:")
        query="""select * from Student where Student_id={0}""".format(student_id)
        print(pd.read_sql_query(query,connection))
        Student_logged_in(student_id)
    else:
        print("Successfully logged out!")
        print_menu()

#Registering a student
def print_student_register():
    try:
        print("Enter The Following Details To Register Yourself")
        roll_no=int(input("Register number: "))
        name=input("Name: ")
        dept=input("Enter your Department (ECE,CSE,MECH,AUTO,AERO): ")
        phone=int(input("Phone: "))
        email=input("Email: ")
        passw=input("Password(max 8 char): ")
        query="""
            INSERT INTO Student(Student_id,Student_name,Department,Phone,Email,Password)
            VALUES({0},'{1}','{2}',{3},'{4}','{5}')
            """.format(roll_no,name,dept,phone,email,passw)
        cursor.execute(query)
        connection.commit()
        time.sleep(2)
        print("We've registered your name!")
        print_student_login()
    except:
        print("Enter Valid Details To Register!")
        print_student_login()
#Get Admin Login Details
def print_Admin_login():
    print("Enter Login Credantials")
    idi=int(input("Staff Id: "))
    passw=input("Password: ")
    command="""select staff_id from admin where staff_id={0} and password='{1}'""".format(idi,passw)
    t=cursor.execute(command)
    lst=t.fetchall()
    if(len(lst)):
        staff_id=int(lst[0][0])
        print("Succesfully Logged In!!!")
        Admin_logged_in(staff_id)
    else:
        print("Invalid Staff Id or Password!!!")
        print_menu()

#Get Student Login Details
def print_student_login():
    print("""Choose an option:
    1)Log in
    2)Register(Sign Up)
    .
    8)Go back""")
    res=int(input())
    if res==1:
        print("Enter your login credentials:")
        idi=int(input("Student Id: "))
        passw=input("Password: ")
        command="""select student_id from student where student_id={0} and password='{1}'""".format(idi,passw)
        t=cursor.execute(command)
        lst=t.fetchall()
        if(len(lst)):
            student_id=int(lst[0][0])
            print("Succesfully Logged In!!!")
            Student_logged_in(student_id)
        else:
            print("Oops. Invalid Student Id or Password!!!")
            print_menu()
    elif res==2:
        print_student_register()
    else:
        return
    

print_menu()

