# gaz-pour-tous
projet gaz pour tous

## Running Back-end

Pour lancer, depuis le dossier `backend`:

`docker-compose -f docker-compose-back.yaml up`

Après un correctif, 


`docker-compose -f docker-compose-back.yaml build --no-cache`

puis

`docker-compose -f docker-compose-back.yaml up`


## Info Back-end

Sur `localhost:5000/apidocs` se trouve la doc swagger écrite à la main. N'hésitez pas en cas de retour.

### Un utilisateur pour jouer
#### username: sandy
#### password: yesYes
Ce compte a tous les profils.

### Pour se connecter au PG admin
#### username: gazdb@stack-it.fr
#### password: gazman
