
from json import JSONEncoder
import base64
import os
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
from dotenv import load_dotenv

def getParam(key, *args):
    for arg in args:
        v = arg.get(key)
        if v is not None:
            return v
    return None


def ignore_exception(IgnoreException=Exception,DefaultVal=None):
    """ Decorator for ignoring exception from a function
    e.g.   @ignore_exception(DivideByZero)
    e.g.2. ignore_exception(DivideByZero)(Divide)(2/0)
    """
    def dec(function):
        def _dec(*args, **kwargs):
            try:
                return function(*args, **kwargs)
            except IgnoreException:
                return DefaultVal
        return _dec
    return dec

sint = ignore_exception(Exception)(int)

class MyEncoder(JSONEncoder):
    def default(self, o):
        return o.__dict__    


# Fonction pour chiffrer un identifiant avec AES, en limitant la sortie à 32 caractères
def encrypt_unique_id(unique_id, key):
    # Convertir l'identifiant en bytes
    data = unique_id.encode()
   
    # Créer un vecteur d'initialisation (IV) aléatoire
    iv = os.urandom(AES.block_size)
   
    # Initialiser le chiffreur AES en mode CBC
    cipher = AES.new(key, AES.MODE_CBC, iv)
   
    # Ajouter du padding pour que la taille soit un multiple de 16 octets
    padded_data = pad(data, AES.block_size)
   
    # Chiffrer les données
    encrypted_data = cipher.encrypt(padded_data)
   
    # Combiner IV et texte chiffré, puis encoder en Base64
    combined_data = iv + encrypted_data
    encrypted_base64 = base64.b64encode(combined_data).decode()
    
    return encrypted_base64

def decrypt_unique_id(encrypted_id, key):
    try:
        # Décoder les données chiffrées de Base64
        encrypted_data = base64.b64decode(encrypted_id + '===='[:len(encrypted_id) % 4])  # Pad Base64 si nécessaire
        iv = encrypted_data[:AES.block_size]
        encrypted_text = encrypted_data[AES.block_size:]
        # Initialiser le déchiffreur AES en mode CBC
        cipher = AES.new(key, AES.MODE_CBC, iv)
        toBeUnpadded = cipher.decrypt(encrypted_text)
        # Déchiffrer et retirer le padding
        decrypted_data = unpad(toBeUnpadded, AES.block_size)
        return decrypted_data.decode()
    except Exception as e:
        print(f"Key '{key}' Input '{encrypted_id}' Exception {type(e)=} details {repr(e)}")
        raise
    
def testCrypt(uniqueId, key):
    return {"encrypted": encrypt_unique_id(uniqueId, key), "decrypted": decrypt_unique_id(encrypt_unique_id(uniqueId, key), key), "uniqueId": uniqueId}