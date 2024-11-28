from datetime import timedelta
import datetime
from flask import Flask, Response, redirect, url_for, request, session, abort, jsonify
from flask_login import LoginManager, UserMixin, login_required, login_user, logout_user, current_user
from flask_bcrypt import Bcrypt
from user import User 
from flasgger import Swagger
import pg_utils
from utils import getParam, sint, MyEncoder, ignore_exception, decrypt_unique_id, testCrypt
import os
from dotenv import load_dotenv
from flask_cors import CORS, cross_origin
import jwt
import time


ignoreExceptionDefault_12_5 = ignore_exception(Exception, 12.5)(float)

load_dotenv()

app = Flask(__name__)
bcrypt = Bcrypt(app)
app.config['SWAGGER'] = {
    'title': 'Gaz pour tous API doc',
    'uiversion': 3,
}

app.config['SECRET_KEY'] = 'your_strong_secret_key'
app.config["JWT_SECRET_KEY"] = 'your_jwt_secret_key'
app.config['JWT_TOKEN_LOCATION'] = ['headers']


template = {
  "swagger": "2.0",
  "info": {
    "title": "Gaz API",
    "description": "API for GPT",
    "contact": {
      "responsibleOrganization": "ME",
      "responsibleDeveloper": "Me",
      "email": "ouedraogo.wendlasida@gmail.com",
    },
    "version": "0.0.1"
  },
  "securityDefinitions": {
        "Bearer": {
            "type": "apiKey",
            "scheme": "bearer",
            "in": "header",
            "name": "Authorization",
            "description": "\
            JWT Authorization header using the Bearer scheme. Example: \"Authorization: Bearer {token}\""
        }
    },
    "security": [
        {
            "Bearer": []
        }
    ]

}


swagger = Swagger(app, template=template)
CORS(app, resources={r"/*": {"origins": "*"}})
jsonEncoder = MyEncoder()

connectedUsers = {}
sessionTimeInSeconds = sint(os.getenv("SessionTimeInSeconds"))
if sessionTimeInSeconds is None:
    sessionTimeInSeconds = 10 * 60

defaultAESKey = os.getenv("AESSecretKey")
if defaultAESKey is None:
    defaultAESKey = b"WeAreKompyutaDeamTeamForSirexe=="
else:
    defaultAESKey = defaultAESKey.encode('UTF-8')

def allowConnexion(profilType = None): 
    if not current_user.is_authenticated:
        return False
    if (datetime.datetime.now() - current_user.connexionTime).total_seconds() > sessionTimeInSeconds:
        if current_user.username in connectedUsers and connectedUsers[current_user.username][0] == current_user.connexionTime:
            del connectedUsers[current_user.username]
        logout_user()
        return False
    connectedUsers[current_user.username] = (current_user.connexionTime, current_user.accountId)
    if profilType is not None:
        return current_user.profileType == profilType
    return True

def isConnected():
    if current_user.is_authenticated and (datetime.datetime.now() - current_user.connexionTime).total_seconds() > sessionTimeInSeconds:
        if current_user.username in connectedUsers and connectedUsers[current_user.username][0] == current_user.connexionTime:
            del connectedUsers[current_user.username]
        logout_user()
        return False
    return current_user.is_authenticated

app.config.update(
    DEBUG = True,
    SECRET_KEY = 'secret_xxx'
)

login_manager = LoginManager()
login_manager.session_protection = "strong"
login_manager.init_app(app)

@app.route('/test')
@login_required
def home():
    """Endpoint to test.
    ---
    responses:
      200:
        description: Tested result
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion():
        print("============== > User is not connected")
        return Response("Not authorized", 401)
    print("============== > Test du print.. OK")
    return Response("Hello World! " + str(current_user))

@app.route("/logout")
def logout():
    """Endpoint to logout.
    ---
    responses:
      200:
        description: Logged out
        schema:
          type: string
      403:
        description: Bad request
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if current_user.is_authenticated:
        if current_user.username in connectedUsers and connectedUsers[current_user.username][0] == current_user.connexionTime:
            del connectedUsers[current_user.username]
    logout_user()
    return Response('Logged out')

@app.route("/register", methods=["POST"])
def register():
    """Endpoint to register a user.
    ---
    parameters:
      - name: credentials
        description: credentials
        in: body
        required: true
        "schema": {
          "$ref": "#/definitions/CredentialsRegister"
        }
    definitions:
      LogResponse:
        type: object
        properties:
          success:
            type: boolean
      Profil:
        description: profil
        type: string
        enum: ['admin', 'emplisseur', 'liveur', 'marketeur', 'revendeur', 'client']
      Credentials:
        type: object
        properties:
          username:
            type: string
            description: username
            required: true
          password:
            type: string
            description: password
            required: true
          profil:
            required: true
            description: profil
            type: string
            enum: ['admin', 'emplisseur', 'liveur', 'marketeur', 'revendeur', 'client']
      CredentialsRegister:
        type: object
        properties:
          username:
            type: string
            description: username
            required: true
          password:
            type: string
            description: password
            required: true
          profiles:
            description: profiles
            type: array
            required: true
            items:
              $ref: '#/definitions/Profil'
    responses:
      403:
        description: Bad request
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
    """
    if isConnected():
        print("============== > User is connected")
        return Response("Non authorized: Should not be connected", 401)
    username = getParam('username', request.form, request.json)
    profiles = getParam('profiles', request.form, request.json)
    password = getParam('password', request.form, request.json)
    if password is None or profiles is None or username is None:
        print(f"============== > Incorrect form: password={password} profiles={profiles} username={username}")
        return Response("Wrong form", 403)
    pw_hash = bcrypt.generate_password_hash(password).decode('utf-8')
    with pg_utils.getConnection() as c:
        with c.cursor() as s:
            try:
                s.execute('''
                    INSERT INTO "Account" ("Username", "PasswordHash") VALUES (%s, %s) RETURNING "Id"
                    ''', (username, pw_hash))
                accountId = s.fetchone()[0]
                print(accountId)
                print(pw_hash)
                s.execute('''
                    INSERT INTO "AccountProfil" ("AccountId", "ProfilTypeId") SELECT DISTINCT %s, "Id" FROM "ProfilType" WHERE "Name" = ANY (%s) RETURNING "Id"
                    ''', (accountId, profiles))
                id = s.fetchone()[0]
                c.commit()
                return jsonify({"success": True})
            except Exception as err:
                print(f"Unexpected {err=}, {type(err)=}")
                c.rollback()
                return Response(repr(err), 400)


@app.route("/login", methods=["POST"])
@cross_origin()
def login():
    """Endpoint to login.
    ---
    parameters:
      - name: credentials
        description: credentials
        in: body
        required: true
        "schema": {
          "$ref": "#/definitions/Credentials"
        }
    responses:
      403:
        description: Bad request
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
      200:
        description: User registered
        schema:
          id: User
          properties:
            token:
              type: string
              description: Token to add in Authorization
            success:
              type: boolean
          
    """
    if isConnected():
        print(f"============== > User is connected")
        return Response("Non authorized: Should not be connected", 401)
    username = getParam('username', request.form, request.json)
    profil = getParam('profil', request.form, request.json)
    password = getParam('password', request.form, request.json)
    if password is None or profil is None or username is None:
        print(f"============== > Incorrect form: password={password} profil={profil} username={username}")
        return Response("Wrong form", 403)
    with pg_utils.getConnection() as c:
        with c.cursor() as s:
            s.execute(''' 
                      SELECT 
                        acc_prof."Id",  
                        acc."Username",
                        acc."PasswordHash",
                        acc."CreatedAt",
                        prof."Name"
                      FROM "Account" acc 
                      JOIN "AccountProfil" acc_prof ON acc_prof."AccountId" = acc."Id"
                      JOIN "ProfilType" prof ON prof."Id" = acc_prof."ProfilTypeId"
                      WHERE acc."Username" = %s AND prof."Name" = %s
                      ''', (username, profil))
            results = s.fetchall()
            if len(results) == 1:
                now = datetime.datetime.now()
                user = User(*results[0], now)
                if bcrypt.check_password_hash(user.passwordHash, password):
                    if user.username in connectedUsers and (datetime.datetime.now() - connectedUsers[user.username][0]).total_seconds() < sessionTimeInSeconds:
                        print(f"============== > User already connected -- all of them will be disconnected")
                        del connectedUsers[user.username]
                        return Response("Same account all ready connected -- all of them will be disconnected", 401)
                    connectedUsers[user.username] = (now, results[0][0])
                    login_user(user, False, timedelta(seconds = sessionTimeInSeconds))
                    token = jwt.encode({
                      'sub': user.username,
                      'iat': datetime.datetime.timestamp(now),
                      'exp': now + timedelta(seconds=sessionTimeInSeconds)},
                      app.config['SECRET_KEY'], algorithm='HS256')
                    return {"success": True, "token": token}
            print(f"============== > Wrong credentials")
            return Response("Wrong credentials", 401)

def get_user_from_userId(userid, connectionTimeFloat):
    print(f"================> Conditions to accept auth: {userid in connectedUsers}, {userid}, {connectionTimeFloat}, {datetime.datetime.timestamp(connectedUsers[userid][0]) if userid in connectedUsers else False}, {connectedUsers}, {datetime.datetime.now()}, {sessionTimeInSeconds}")
    if userid in connectedUsers and (datetime.datetime.now() - connectedUsers[userid][0]).total_seconds() < sessionTimeInSeconds and datetime.datetime.timestamp(connectedUsers[userid][0]) == connectionTimeFloat:
        with pg_utils.getConnection() as c:
            with c.cursor() as s:
                s.execute(''' 
                          SELECT 
                            acc_prof."Id",  
                            acc."Username",
                            acc."PasswordHash",
                            acc."CreatedAt",
                            prof."Name"
                          FROM "Account" acc 
                          JOIN "AccountProfil" acc_prof ON acc_prof."AccountId" = acc."Id"
                          JOIN "ProfilType" prof ON prof."Id" = acc_prof."ProfilTypeId"
                          WHERE acc_prof."Id" = %s
                          ''', (connectedUsers[userid][1], ))
                results = s.fetchall()
                if len(results) == 1:
                    print("================> user connected")
                    return User(*results[0], connectedUsers[userid][0])
    return None

@login_manager.user_loader
def load_user(userid):
    return get_user_from_userId(*eval(userid))

@login_manager.request_loader
def load_user_from_request(request):
    if session.get("_fresh") and session.get("_user_id") is not None:
        print("================> Using session")
        current_userData = get_user_from_userId(*eval(session.get("_user_id")))
        if current_userData is not None:
            return current_userData
    print("================> Using headers Authorization")
    auth_headers = request.headers.get('Authorization', '').split()
    print("================> headers Authorization: " + str(auth_headers))
    if len(auth_headers) != 2:
        print("================> No token found")
        return None
    try:
        token = auth_headers[1]
        print("================> token=" + token)
        data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
        if data['sub'] is not None and data['exp'] > time.time():
            return get_user_from_userId(data['sub'], data['iat'])
    except jwt.ExpiredSignatureError as err:
        print(f"ExpiredSignatureError {err=}, {type(err)=}")
        return None
    except (jwt.InvalidTokenError, Exception) as err:
        print(f"InvalidTokenError {err=}, {type(err)=}")
        return None
    return None

#### Metier

#########################################################################
## emplisseur

@app.route("/emplisseur/receive-empty-bottle", methods = ["POST"])
@login_required
def emplisseur_receive_empty_bottle():
    """Endpoint to receive an empty bottle.
    ---
    parameters:
      - name: bottleHash
        description: bottleHash
        in: body
        required: true
        schema:
          $ref: '#/definitions/InputBottle'
    responses:
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion('emplisseur'):
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    bottleHash = getParam('bottleHash', request.form, request.json)
    bottleCapacity = ignoreExceptionDefault_12_5(getParam('bottleCapacity', request.form, request.json))
    if bottleHash is None or bottleCapacity <= 0:
        print(f"============== > Incorrect form: bottleHash={bottleHash} {bottleCapacity=}")
        return Response("Bad request", 400)
    try:
        bottleId = pg_utils.upsertBottle(decrypt_unique_id(bottleHash, defaultAESKey), bottleCapacity)
        pg_utils.addBottleLog(bottleId, 'prete a etre remplie', current_user.accountId)
        return jsonify({"success": True})
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)
    
@app.route("/emplisseur/fill-empty-bottle", methods = ["POST"])
@login_required
def emplisseur_fill_empty_bottle():
    """Endpoint to fill an empty bottle.
    ---
    parameters:
      - name: bottleHash
        description: bottleHash
        in: body
        required: true
        schema:
          $ref: '#/definitions/InputBottle'
    responses:
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion('emplisseur'):
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    bottleHash = getParam('bottleHash', request.form, request.json)
    bottleCapacity = ignoreExceptionDefault_12_5(getParam('bottleCapacity', request.form, request.json))
    if bottleHash is None or bottleCapacity <= 0:
        print(f"============== > Incorrect form: bottleHash={bottleHash} or bottleCapacity <= 0")
        return Response("Bad request", 400)
    try:
        bottleId = pg_utils.upsertBottle(decrypt_unique_id(bottleHash, defaultAESKey), bottleCapacity)
        pg_utils.addBottleLog(bottleId, 'prete a etre livree au marketeur', current_user.accountId)
        return jsonify({"success": True})
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)
    
@app.route("/emplisseur/ship-bottle", methods = ["POST"])
@login_required
def emplisseur_ship_empty_bottle():
    """Endpoint to ship an empty bottle.
    ---
    parameters:
      - name: bottleHash
        description: bottleHash
        in: body
        required: true
        schema:
          $ref: '#/definitions/InputBottle'
    responses:
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion('emplisseur'):
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    bottleHash = getParam('bottleHash', request.form, request.json)
    bottleCapacity = ignoreExceptionDefault_12_5(getParam('bottleCapacity', request.form, request.json))
    if bottleHash is None or bottleCapacity <= 0:
        print(f"============== > Incorrect form: bottleHash={bottleHash} {bottleCapacity=}")
        return Response("Bad request", 400)
    try:
        bottleId = pg_utils.upsertBottle(decrypt_unique_id(bottleHash, defaultAESKey), bottleCapacity)
        pg_utils.addBottleLog(bottleId, 'en cours de livraison au marketeur', current_user.accountId)
        return jsonify({"success": True})
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)
        

#########################################################################
## marketeur
    
@app.route("/marketeur/receive-full-bottle", methods = ["POST"])
@login_required
def marketeur_receive_full_bottle():
    """Endpoint to receive a full bottle.
    ---
    parameters:
      - name: bottleHash
        description: bottleHash
        in: body
        required: true
        schema:
          $ref: '#/definitions/InputBottle'
    responses:
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion('marketeur'):
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    bottleHash = getParam('bottleHash', request.form, request.json)
    bottleCapacity = ignoreExceptionDefault_12_5(getParam('bottleCapacity', request.form, request.json))
    if bottleHash is None or bottleCapacity <= 0:
        print(f"============== > Incorrect form: bottleHash={bottleHash} {bottleCapacity=}")
        return Response("Bad request", 400)
    try:
        bottleId = pg_utils.upsertBottle(decrypt_unique_id(bottleHash, defaultAESKey), bottleCapacity)
        pg_utils.addBottleLog(bottleId, 'chez marketeur', current_user.accountId)
        return jsonify({"success": True})
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)

    
@app.route("/marketeur/receive-empty-bottle", methods = ["POST"])
@login_required
def marketeur_receive_empty_bottle():
    """Endpoint to receive a empty bottle.
    ---
    parameters:
      - name: bottleHash
        description: bottleHash
        in: body
        required: true
        schema:
          $ref: '#/definitions/InputBottle'
    responses:
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion('marketeur'):
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    bottleHash = getParam('bottleHash', request.form, request.json)
    bottleCapacity = ignoreExceptionDefault_12_5(getParam('bottleCapacity', request.form, request.json))
    if bottleHash is None or bottleCapacity <= 0:
        print(f"============== > Incorrect form: bottleHash={bottleHash} {bottleCapacity=}")
        return Response("Bad request", 400)
    
    try:
        bottleId = pg_utils.upsertBottle(decrypt_unique_id(bottleHash, defaultAESKey), bottleCapacity)
        pg_utils.addBottleLog(bottleId, 'vide chez marketeur', current_user.accountId)
        return jsonify({"success": True})
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)

@app.route("/marketeur/ship-full-bottle", methods = ["POST"])
@login_required
def marketeur_ship_full_bottle():
    """Endpoint to ship a full bottle.
    ---
    parameters:
      - name: bottleHash
        description: bottleHash
        in: body
        required: true
        schema:
          $ref: '#/definitions/InputBottle'
    responses:
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion('marketeur'):
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    bottleHash = getParam('bottleHash', request.form, request.json)
    bottleCapacity = ignoreExceptionDefault_12_5(getParam('bottleCapacity', request.form, request.json))
    if bottleHash is None or bottleCapacity <= 0:
        print(f"============== > Incorrect form: bottleHash={bottleHash} {bottleCapacity=}")
        return Response("Bad request", 400)
    try:
        bottleId = pg_utils.upsertBottle(decrypt_unique_id(bottleHash, defaultAESKey), bottleCapacity)
        pg_utils.addBottleLog(bottleId, 'en cours de livraison au revendeur', current_user.accountId)
        return jsonify({"success": True})
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)

#########################################################################
## revendeur

@app.route("/revendeur/receive-full-bottle", methods = ["POST"])
@login_required
def revendeur_receive_full_bottle():
    """Endpoint to receive a full bottle.
    ---
    parameters:
      - name: bottleHash
        description: bottleHash
        in: body
        required: true
        schema:
          $ref: '#/definitions/InputBottle'
    responses:
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion('revendeur'):
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    bottleHash = getParam('bottleHash', request.form, request.json)
    bottleCapacity = ignoreExceptionDefault_12_5(getParam('bottleCapacity', request.form, request.json))
    if bottleHash is None or bottleCapacity <= 0:
        print(f"============== > Incorrect form: bottleHash={bottleHash} {bottleCapacity=}")
        return Response("Bad request", 400)
    try:
        bottleId = pg_utils.upsertBottle(decrypt_unique_id(bottleHash, defaultAESKey), bottleCapacity)
        pg_utils.addBottleLog(bottleId, 'pleine chez le revendeur', current_user.accountId)
        return jsonify({"success": True})
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)


@app.route("/revendeur/sell-bottle", methods = ["POST"])
@login_required
def revendeur_sell_bottle():
    """Endpoint to receive a full bottle.
    ---
    parameters:
      - name: sellBottle
        description: sellBottle data
        in: body
        required: true
        schema:
          $ref: '#/definitions/SellBottle'
    definitions:
      InputBottle:
        type: object
        properties:
          bottleHash:
            type: string
            description: bottleHash
            required: true
          bottleCapacity:
            type: number
            description: capacite en Kg
            default: 12.5
      InputClientBottle:
        type: object
        properties:
          bottleHash:
            type: string
            description: bottleHash
            required: true
          bottleCapacity:
            type: number
            description: amount
            default: 12.5
          clientHash:
            type: string
            description: clientHash
            required: true
      SellBottle:
        type: object
        properties:
          bottleHash:
            type: string
            description: bottleHash
            required: true
          bottleCapacity:
            type: number
            description: amount
            default: 12.5
          clientHash:
            type: string
            description: clientHash
            required: true
          amount:
            type: number
            description: amount
            required: true
          mode:
            type: string
            description: Payment mode
            required: true
    responses:
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion('revendeur'):
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    bottleHash = getParam('bottleHash', request.form, request.json)
    bottleCapacity = ignoreExceptionDefault_12_5(getParam('bottleCapacity', request.form, request.json))
    clientHash = getParam('clientHash', request.form, request.json)
    amount = sint(getParam('amount', request.form, request.json))
    mode = getParam('mode', request.form, request.json)
    if bottleHash is None or clientHash is None or amount is None or mode is None or amount <= 0 or bottleCapacity <= 0: 
        print(f"============== > Incorrect form: bottleHash={bottleHash} clientHash={clientHash} amount={amount} mode={mode} {bottleCapacity=}")
        return Response("Bad request", 400)
    try:
        bottleId = pg_utils.upsertBottle(decrypt_unique_id(bottleHash, defaultAESKey), bottleCapacity)
        clientId = pg_utils.upsertClient(clientHash)
        pg_utils.addBottlePayment(bottleId, current_user.accountId, clientId, amount, mode)
        pg_utils.addBottleLog(bottleId, 'pleine chez le client', clientId)
        return jsonify({"success": True})
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)

@app.route("/revendeur/receive-bottle-from-client", methods = ["POST"])
@login_required
def revendeur_receive_empty_bottle():
    """Endpoint to receive an empty bottle.
    ---
    parameters:
      - name: inputBottle
        description: InputBottle data
        in: body
        required: true
        schema:
          $ref: '#/definitions/InputClientBottle'
    responses:
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion('revendeur'):
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    bottleHash = getParam('bottleHash', request.form, request.json)
    clientHash = getParam('clientHash', request.form, request.json)
    bottleCapacity = ignoreExceptionDefault_12_5(getParam('bottleCapacity', request.form, request.json))
    if bottleHash is None or clientHash is None or bottleCapacity <= 0:
        print(f"============== > Incorrect form: bottleHash={bottleHash} clientHash={clientHash}  {bottleCapacity=}")
        return Response("Bad request", 400)
    try:
        bottleId = pg_utils.upsertBottle(decrypt_unique_id(bottleHash, defaultAESKey), bottleCapacity)
        clientId = pg_utils.upsertClient(clientHash)
        pg_utils.addBottleLog(bottleId, 'vide chez le client', clientId)
        pg_utils.addBottleLog(bottleId, 'vide chez le revendeur', current_user.accountId)
        return jsonify({"success": True})
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)



@app.route("/revendeur/ship-bottle", methods = ["POST"])
@login_required
def revendeur_ship_bottle():
    """Endpoint to receive a full bottle.
    ---
    parameters:
      - name: bottleHash
        description: bottleHash
        in: body
        required: true
        schema:
          $ref: '#/definitions/InputBottle'
    responses:
      200:
        description: User registered
        schema:
          $ref: '#/definitions/LogResponse'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion('revendeur'):
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    bottleHash = getParam('bottleHash', request.form, request.json)
    bottleCapacity = ignoreExceptionDefault_12_5(getParam('bottleCapacity', request.form, request.json))
    if bottleHash is None or bottleCapacity <= 0:
        print(f"============== > Incorrect form: bottleHash={bottleHash} {bottleCapacity=}")
        return Response("Bad request", 400)
    try:
        bottleId = pg_utils.upsertBottle(decrypt_unique_id(bottleHash, defaultAESKey), bottleCapacity)
        pg_utils.addBottleLog(bottleId, 'vide en cours de livraison au marketeur', current_user.accountId)
        return jsonify({"success": True})
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)


#########################################################################
## Every body

@app.route("/current-bottles", methods = ["GET"])
@login_required
def user_current_bottles():
    """Endpoint to receive a full bottle.
    ---
    definitions:
      Bottle:
        type: object
        properties:
          currentOwnerId:
            type: int
            description: current owner Id
            required: true
          bottleId:
            type: int
            description: bottleId
            required: true
          state:
            type: string
            description: current state
            required: true
          last_update:
            type: datetime
            description: last_update
            required: true
          capacity:
            type: int
            description: capacity
            required: true
    responses:
      200:
        description: User registered
        type: array
        required: true
        items:
          $ref: '#/definitions/Bottle'
      400:
        description: Bad request
        schema:
          type: string
      403:
        description: Forbidden
        schema:
          type: string
      401:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion():
        print(f"============== > User is not connected to with the write profile {str(current_user)}")
        return Response("Not authorized", 401)
    try:
        return jsonEncoder.encode(pg_utils.listUserBottle(current_user.accountId))
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return Response(repr(err), 400)


########### Playground Debug -- Start
@app.route("/verify-bottle-hash", methods = ["GET"])
def hashPassword():
    """
    Verifies bottle Hash code
    ---
    parameters:
      - name: q
        description: bottleHash
        in: query
        required: true
        type: string
    responses:
      200:
        description: Is code recognized
        type: boolean

    """
    try:
        decrypt_unique_id(request.args.get('q'), defaultAESKey)
        return {"success": True}
    except Exception as err:
        return Response(repr(err), 400)

# @app.route("/decrypt-qr", methods = ["GET"])
# def decryptqr():
#     return decrypt_unique_id(request.args.get('q'), defaultAESKey)

# @app.route("/testcrypt-qr", methods = ["GET"])
# def testcryptqr():
#     return testCrypt(request.args.get('q'), defaultAESKey)
############ Playground Debug -- End

if __name__ == "__main__":
    app.run(host='0.0.0.0')