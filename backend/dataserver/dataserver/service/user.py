class UserService:
    def __init__(self, users):
        self.users = users


    def get_user(self, user_id):
        return self.users.get(user_id, None)