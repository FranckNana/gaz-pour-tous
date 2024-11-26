# gaz-pour-tous
projet gaz pour tous

## Running Back-end

Pour lancer, depuis le dossier `backend`:

`docker-compose up`

Après un correctif, 


`docker-compose build --no-cache`

puis

`docker-compose up`


## Info Back-end

Sur `localhost:5000/apidocs` se trouve la doc swagger écrite à la main. N'hésitez pas en cas de retour.

### Utilisateurs pour jouer
#### username: sandy
#### password: yesYes
Ce compte a tous les profils.

---

#### username: 0000 - 0000 - 000
#### password: 0000-0000-000
#### profil: emplisseur

---


#### username: 1000 - 0000 - 000
#### password: 1000-0000-000
#### profil: marketeur

---


#### username: 2000 - 0000 - 000
#### password: 2000-0000-000
#### profil: revendeur

---


#### username: 3000 - 0000 - 000
#### password: 3000-0000-000
#### profil: client


### Pour se connecter au PG admin
#### username: gazdb@stack-it.fr
#### password: gazman
#### database: gazdb



### Authentification dans l'applie
#### path: /login
#### requires: username, password, profil
#### returns: token and set-cookies for session

Pour l'utiliser, le swagger mets directement à jour les cookies et sessions... Si cela ne fonctionne pas pour vous, récuperer le token, et pour chaque requête, rajouter dans le header sur le champ `Authorization` la valeur `JWT [token]` ou `[token]` est la valeur du token de retour du login.. Cela devrait fonctionner après.
