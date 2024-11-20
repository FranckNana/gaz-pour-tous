from flask_login import UserMixin

class User(UserMixin):

    def __init__(self, accountProfilId, username, passwordHash, createdAt, profileType):
        self.id = accountProfilId
        self.username = username
        self.passwordHash = passwordHash
        self.createdAt = createdAt
        self.profileType = profileType
        
    def __repr__(self):
        return "%d/%s/%s" % (self.id, self.username, self.profileType)
    
