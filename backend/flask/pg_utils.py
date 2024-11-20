import os
import psycopg2
from bottle import Bottle
from dotenv import load_dotenv

load_dotenv()

def getConnection():
    return psycopg2.connect(os.getenv("DATABASE_URL"))

def upsertBottle(bottleHash, bottleCapacity = 12.5):
    with getConnection() as c:
        with c.cursor() as s:
            s.execute(''' 
                      INSERT INTO "GasBottle" ("QRCodeHash", "CapaciteEnKg")
                      VALUES (%s, %s) 
                      ON CONFLICT ("QRCodeHash")
                      DO UPDATE SET
                        "CapaciteEnKg" = EXCLUDED."CapaciteEnKg"
                      RETURNING "Id"
                      ''', (bottleHash, bottleCapacity))
            return s.fetchall()[0]
        
def upsertClient(username):
    with getConnection() as c:
        with c.cursor() as s:
            s.execute(''' 
                      INSERT INTO "Account" ("Username")
                      VALUES (%s) 
                      ON CONFLICT ("Username")
                      DO UPDATE SET
                        "Username" = EXCLUDED."Username"
                      RETURNING "Id"
                      ''', (username, ))
            accountId = s.fetchall()[0]
            s.execute(''' 
                      INSERT INTO "AccountProfil" ("AccountId", "ProfilTypeId")
                      SELECT DISTINCT %s, "Id" FROM "ProfilType" WHERE "Name" = 'client' 
                      ON CONFLICT ("AccountId","ProfilTypeId")
                      DO UPDATE SET
                        "AccountId" = EXCLUDED."AccountId",
                        "ProfilTypeId" = EXCLUDED."ProfilTypeId"
                      RETURNING "Id"
                      ''', (accountId, ))
            accountProfilId = s.fetchall()[0]
            return accountProfilId
        
def addBottleLog(bottleId, stateString, modifierId):
    with getConnection() as c:
        with c.cursor() as s:
            s.execute(''' 
                        INSERT INTO "GasBottleStateLog" ("GasBottleId", "StateId", "ModifierId")
                        SELECT DISTINCT %s, "Id", %s FROM "BottleState" WHERE "StateName" = %s 
                        ''', (bottleId, modifierId, stateString))


def addBottlePayment(bottleId, sellerId, buyerId, amount, mode = 'cash'):
    with getConnection() as c:
        with c.cursor() as s:
            s.execute(''' 
                        INSERT INTO "GasBottleSell" 
                            ("GasBottleId", "SellerId", "BuyerId", "PaymentAmount", "PaymentMode")
                        VALUES (%s, %s, %s, %s, %s)
                        ''', (bottleId, sellerId, buyerId, amount, mode))
            
def listUserBottle(userProfilId):
    with getConnection() as c:
        with c.cursor() as s:
            s.execute(''' 
                        SELECT DISTINCT ON(gl."GasBottleId") gl."ModifierId", gl."GasBottleId", bs."StateName", gl."ExecutionTime", g."CapaciteEnKg" 
                            FROM  "GasBottleStateLog" gl
                            JOIN "GasBottle" g ON g."Id" = gl."GasBottleId"
                            JOIN "BottleState" bs ON bs."Id" = gl."StateId"
                        ORDER BY gl."GasBottleId", gl."ExecutionTime" DESC
                        ''')
            return list(map(lambda x: Bottle(*x), filter(lambda x: x[0] == userProfilId, s.fetchall())))
