enum BottleStatus {
  emptyReadyToBeFilledAtFiller,
  filledAtFiller,
  filledAtFillerReadyToShipToMarketer,
  emptyAtMarketer,
  filledAtMarketer,
  filledAtMarketerReadyToShipToReseller,
  atReseller,
  atClient
}

enum Profile { none, client, emplisseur, marketeur, revendeur }

enum LoginStatus { none, loggedIn, loading }
