from gorani import firebase

firebase.init('env') 
db = firebase.db()

def due_check(event, context):
    print(db)