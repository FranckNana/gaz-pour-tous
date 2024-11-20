from datetime import timedelta
import datetime
from flask import Flask, Response, redirect, url_for, request, session, abort, jsonify
from flask_login import LoginManager, UserMixin, login_required, login_user, logout_user, current_user
from flask_bcrypt import Bcrypt
from user import User 
from flasgger import Swagger
import pg_utils
from utils import getParam, sint, MyEncoder

app = Flask(__name__)
bcrypt = Bcrypt(app)
app.config['SWAGGER'] = {
    'title': 'Gaz API',
    'uiversion': 3
}
swagger = Swagger(app)
jsonEncoder = MyEncoder()

connectedUsers = {}

def allowConnexion(profilType = None): 
    if not current_user.is_authenticated:
        return False
    user = current_user
    if user.username in connectedUsers:
        if connectedUsers[user.username] < datetime.datetime.now():
            del connectedUsers[user.username]
            return False
    if profilType is not None:
        return current_user.profileType == profilType
    return True

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
      403:
        description: Non authorized
        schema:
          type: string
    """
    if not allowConnexion():
        return abort(403, "Not authorized")
    return Response("Hello World! " + str(current_user))

@app.route("/logout")
@login_required
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
    logout_user()
    del connectedUsers[current_user.username]
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
          sucess:
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
    username = getParam('username', request.form, request.json)
    profiles = getParam('profiles', request.form, request.json)
    password = getParam('password', request.form, request.json)
    if current_user.is_authenticated:
        return abort(403, "Should not be connected")
    if password is None or profiles is None or username is None:
        return abort(403, "Wrong form")
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
                return Response("{success: true}")
            except Exception as err:
                print(f"Unexpected {err=}, {type(err)=}")
                c.rollback()
                return abort(403, "Failed")


@app.route("/login", methods=["POST"])
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
          $ref: '#/definitions/LogResponse'
    """
    username = getParam('username', request.form, request.json)
    profil = getParam('profil', request.form, request.json)
    password = getParam('password', request.form, request.json)
    if password is None or profil is None or username is None:
        return abort(403, "Wrong form")
    if current_user.is_authenticated:
        return abort(403, "Should not be connected")
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
                user = User(*results[0])
                end_session = datetime.datetime.now() + datetime.timedelta(minutes = 30)
                if bcrypt.check_password_hash(user.passwordHash, password):
                    if user.username in connectedUsers:
                        if connectedUsers[user.username] < datetime.datetime.now():
                            del connectedUsers[user.username]
                        else:
                          return abort(401, "Same acounte all ready connected")
                    connectedUsers[user.username] = end_session
                    login_user(user, False, timedelta(minutes=30))
                    return Response("{success: true}")
            return abort(401, "Wrong credentials")

@login_manager.user_loader
def load_user(userid):
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
                      ''', (userid))
            results = s.fetchall()
            if len(results) == 1:
                return User(*results[0])
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
        return abort(403, "Not authorized")
    bottleHash = getParam('bottleHash', request.form, request.json)
    if bottleHash is None:
        return abort(400, "Bad request")
    bottleId = pg_utils.upsertBottle(bottleHash)
    try:
        pg_utils.addBottleLog(bottleId, 'prete a etre remplie', current_user.id)
        return Response("{success: true}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))
    
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
        return abort(403, "Not authorized")
    bottleHash = getParam('bottleHash', request.form, request.json)
    if bottleHash is None:
        return abort(400, "Bad request")
    bottleId = pg_utils.upsertBottle(bottleHash)
    try:
        pg_utils.addBottleLog(bottleId, 'prete a etre livree au marketeur', current_user.id)
        return Response("{success: true}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))
    
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
        return abort(403, "Not authorized")
    bottleHash = getParam('bottleHash', request.form, request.json)
    if bottleHash is None:
        return abort(400, "Bad request")
    bottleId = pg_utils.upsertBottle(bottleHash)
    try:
        pg_utils.addBottleLog(bottleId, 'en cours de livraison au marketeur', current_user.id)
        return Response("{success: true}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))
        

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
        return abort(403, "Not authorized")
    bottleHash = getParam('bottleHash', request.form, request.json)
    if bottleHash is None:
        return abort(400, "Bad request")
    bottleId = pg_utils.upsertBottle(bottleHash)
    try:
        pg_utils.addBottleLog(bottleId, 'chez marketeur', current_user.id)
        return Response("{success: true}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))

    
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
        return abort(403, "Not authorized")
    bottleHash = getParam('bottleHash', request.form, request.json)
    if bottleHash is None:
        return abort(400, "Bad request")
    bottleId = pg_utils.upsertBottle(bottleHash)
    try:
        pg_utils.addBottleLog(bottleId, 'vide chez marketeur', current_user.id)
        return Response("{success: true}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))

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
        return abort(403, "Not authorized")
    bottleHash = getParam('bottleHash', request.form, request.json)
    if bottleHash is None:
        return abort(400, "Bad request")
    bottleId = pg_utils.upsertBottle(bottleHash)
    try:
        pg_utils.addBottleLog(bottleId, 'en cours de livraison au revendeur', current_user.id)
        return Response("{success: true}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))

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
        return abort(403, "Not authorized")
    bottleHash = getParam('bottleHash', request.form, request.json)
    if bottleHash is None:
        return abort(400, "Bad request")
    bottleId = pg_utils.upsertBottle(bottleHash)
    try:
        pg_utils.addBottleLog(bottleId, 'pleine chez le revendeur', current_user.id)
        return Response("{success: true}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))


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
      InputClientBottle:
        type: object
        properties:
          bottleHash:
            type: string
            description: bottleHash
            required: true
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
          clientHash:
            type: string
            description: clientHash
            required: true
          amount:
            type: number
            description: amount
          mode:
            type: string
            description: Payment mode
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
        return abort(403, "Not authorized")
    bottleHash = getParam('bottleHash', request.form, request.json)
    clientHash = getParam('clientHash', request.form, request.json)
    amount = sint(getParam('amount', request.form, request.json))
    mode = getParam('mode', request.form, request.json)
    if bottleHash is None or clientHash is None or amount is None or mode is None: 
        return abort(400, "Bad request")
    if amount <= 0:
        return abort(400, "Bad request")
    bottleId = pg_utils.upsertBottle(bottleHash)
    clientId = pg_utils.upsertClient(clientHash)
    try:
        pg_utils.addBottlePayment(bottleId, current_user.id, clientId, amount, mode)
        pg_utils.addBottleLog(bottleId, 'pleine chez le client', clientId)
        return Response("{success: true}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))

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
        return abort(403, "Not authorized")
    bottleHash = getParam('bottleHash', request.form, request.json)
    clientHash = getParam('clientHash', request.form, request.json)
    if bottleHash is None or clientHash is None:
        return abort(400, "Bad request")
    bottleId = pg_utils.upsertBottle(bottleHash)
    clientId = pg_utils.upsertClient(clientHash)
    try:
        pg_utils.addBottleLog(bottleId, 'vide chez le client', clientId)
        pg_utils.addBottleLog(bottleId, 'vide chez le revendeur', current_user.id)
        return Response("{success: true}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))



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
        return abort(403, "Not authorized")
    bottleHash = getParam('bottleHash', request.form, request.json)
    if bottleHash is None:
        return abort(400, "Bad request")
    bottleId = pg_utils.upsertBottle(bottleHash)
    try:
        pg_utils.addBottleLog(bottleId, 'vide en cours de livraison au marketeur', current_user.id)
        return Response("{success: true}")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))


#########################################################################
## Every body

@app.route("/current-bottles", methods = ["POST"])
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
        return abort(403, "Not authorized")
    try:
        return jsonEncoder.encode(pg_utils.listUserBottle(current_user.id))
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        return abort(403, repr(err))

if __name__ == "__main__":
    app.run(host='0.0.0.0')