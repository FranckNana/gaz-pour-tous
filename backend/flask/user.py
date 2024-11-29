from flask_login import UserMixin
import datetime

class User(UserMixin):

    def __init__(self, accountProfilId, username, passwordHash, createdAt, profileType, connexionTime):
        self.id = (username, datetime.datetime.timestamp(connexionTime), accountProfilId)
        self.accountId = accountProfilId
        self.username = username
        self.passwordHash = passwordHash
        self.createdAt = createdAt
        self.profileType = profileType
        self.connexionTime = connexionTime
        
        
    def __repr__(self):
        return "%d/%s/%s-%s" % (self.accountId, self.username, self.profileType, self.connexionTime)
    
