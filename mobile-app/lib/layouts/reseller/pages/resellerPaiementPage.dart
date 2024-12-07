import 'package:flutter/material.dart';
import 'package:gazpourtous/constants/colorsConstants.dart';
import 'package:gazpourtous/controllers/bottlesController.dart';
import 'package:gazpourtous/enums/enums.dart';
import 'package:gazpourtous/layouts/default/widgets/progressIndicator.dart';
import 'package:get/get.dart';

class ResellerPaiementPage extends StatefulWidget {
  ResellerPaiementPage(
      {super.key,
      required this.targetStatus,
      required this.bottleCode,
      required this.clientCode});

  BottleStatus targetStatus;

  String bottleCode;
  String clientCode;

  @override
  State<ResellerPaiementPage> createState() => _ResellerPaiementPageState();
}

class _ResellerPaiementPageState extends State<ResellerPaiementPage> {
  String? paiementMode;
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _refController = new TextEditingController();
  BottlesController _bottlesController = Get.find();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paiement"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Montant",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _amountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Saisissez le prix à payer',
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Moyen de paiement",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  InkWell(
                    onTap: () => onPaiementMode("cash"),
                    child: ClipRRect(
                      child: Container(
                        alignment: Alignment.center,
                        height: 90.0,
                        width: 90.0,
                        child: Text(
                          "Cash",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.fromBorderSide(
                            BorderSide(
                                color: paiementMode == "cash"
                                    ? ColorsConstants.orangeColor
                                    : Colors.grey,
                                width: 5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  getPaiementIconWidget("om"),
                  getPaiementIconWidget("mtn"),
                  getPaiementIconWidget("wave"),
                  getPaiementIconWidget("moov-money")
                ],
              ),
              SizedBox(
                height: 40,
              ),
              paiementMode != null && paiementMode != "cash"
                  ? Text(
                      "Référence paiement",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  : SizedBox.shrink(),
              paiementMode != null && paiementMode != "cash"
                  ? SizedBox(
                      height: 10,
                    )
                  : SizedBox.shrink(),
              paiementMode != null && paiementMode != "cash"
                  ? TextField(
                      keyboardType: TextInputType.text,
                      controller: _refController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Saisissez la référence du paiement',
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 40,
              ),
              isLoading
                  ? Center(child: GPTProgressindicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsConstants.orangeColor),
                        onPressed: () {
                          if (_amountController.value.text.isEmpty ||
                              (_refController.value.text.isEmpty &&
                                  paiementMode != "cash") ||
                              paiementMode == null) {
                            Get.showSnackbar(GetSnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red.shade300,
                                title: "Erreur",
                                message: "Veuillez remplir tous les champs"));
                          } else {
                            _proceedToPaiement(
                                widget.clientCode, widget.bottleCode);
                          }
                        },
                        child: Text(
                          "Valider",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget getPaiementIconWidget(String mode) {
    return InkWell(
      onTap: () => onPaiementMode(mode),
      child: ClipRRect(
          child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.fromBorderSide(
            BorderSide(
                color: paiementMode == mode
                    ? ColorsConstants.orangeColor
                    : Colors.grey,
                width: 5),
          ),
        ),
        child: Image.asset(
          fit: BoxFit.fill,
          "assets/images/$mode.png",
          height: 80.0,
          width: 80.0,
        ),
      )),
    );
  }

  onPaiementMode(mode) {
    setState(() {
      paiementMode = mode;
    });
  }

  Future<void> _proceedToPaiement(clientCode, bottleCode) async {
    setIsLoading(true);
    String title;
    String message;
    String res = await _bottlesController.onResellerSellBottle(
        bottleCode,
        clientCode,
        paiementMode,
        _amountController.value.text,
        _refController.value.text);
    Duration duration = Duration(seconds: 2);
    Color bgColor = Colors.red.shade200;
    if (res == "success") {
      title = "Opération réussie";
      message = "Le statut de la bouteille a été mis à jour";
      Get.back();
      Get.back();
      bgColor = Colors.green.shade200;
    } else if (res == "forbidden") {
      title = "Echec";
      message =
          "Vous ne pouvez pas réaliser cette opération sur cette bouteille";
    } else {
      title = "Echec";
      message = "une erreur s'est produite";
    }
    setIsLoading(false);
  }

  setIsLoading(val) {
    setState(() {
      isLoading = val;
    });
  }

  @override
  void dispose() {
    _refController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
