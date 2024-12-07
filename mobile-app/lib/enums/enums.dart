enum BottleStatus {
  emptyReadyToBeFilledAtFiller,
  filledAtFiller,
  filledAtFillerReadyToShipToMarketer,
  emptyAtMarketer,
  filledAtMarketer,
  filledAtMarketerReadyToShipToReseller,
  filledAtReseller,
  emptyAtReseller,
  filledAtClient,
  emptyAtClient
}

enum Profile { none, client, emplisseur, marketeur, revendeur }

enum LoginStatus { none, loggedIn, loading }
