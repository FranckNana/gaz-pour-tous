CREATE TABLE IF NOT EXISTS "Account" (
        "Id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		"Username" VARCHAR NOT NULL UNIQUE,
		"PasswordHash" VARCHAR,
		"CreatedAt" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
	
CREATE TABLE IF NOT EXISTS "ProfilType" (
        "Id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		"Name" VARCHAR NOT NULL UNIQUE
	);
	
CREATE TABLE IF NOT EXISTS "AccountProfil" (
        "Id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        "AccountId" INT NOT NULL REFERENCES "Account"("Id"),
		"ProfilTypeId" INT NOT NULL REFERENCES "ProfilType"("Id"),
		UNIQUE("AccountId","ProfilTypeId")
    );
	
CREATE TABLE IF NOT EXISTS "BottleState" (
        "Id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		"StateName" VARCHAR NOT NULL UNIQUE,
		"Order" DECIMAL(20,10) NOT NULL UNIQUE,
		"ProfilTypeId" INT NOT NULL REFERENCES "ProfilType"("Id")
	);

CREATE TABLE IF NOT EXISTS "GasBottle" (
        "Id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		"QRCodeHash" VARCHAR NOT NULL UNIQUE,
		"Description" TEXT,
		"CapaciteEnKg" DECIMAL(5,2) NOT NULL CHECK("CapaciteEnKg" > 0)
    );

CREATE TABLE IF NOT EXISTS "GasBottleStateLog" (
        "Id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        "GasBottleId" INT NOT NULL REFERENCES "GasBottle"("Id"),
        "StateId" INT NOT NULL REFERENCES "BottleState"("Id"),
        "ModifierId" INT NOT NULL REFERENCES "AccountProfil"("Id"),
		"ExecutionTime" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
	);

CREATE TABLE IF NOT EXISTS "GasBottleSell" (
        "Id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        "GasBottleId" INT NOT NULL REFERENCES "GasBottle"("Id"),
        "SellerId" INT NOT NULL REFERENCES "AccountProfil"("Id"),
        "BuyerId" INT NOT NULL REFERENCES "AccountProfil"("Id"),
        "PaymentMode" VARCHAR NOT NULL DEFAULT 'Cash',
        "PaymentAmount" INT NOT NULL CHECK("PaymentAmount" > 0),
		"ExecutionTime" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
	);

CREATE OR REPLACE FUNCTION "preventModification"()
RETURNS TRIGGER AS $$ BEGIN RAISE EXCEPTION 'DATA MODIFICATION NOT ALLOWED'; END $$ LANGUAGE PLPGSQL;

/*
CREATE TABLE IF NOT EXISTS "Log" (
		"Id"  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		"LogSubject" VARCHAR NOT NULL,
		"Operation" VARCHAR NOT NULL,
		"ObjectId" INT,
		"Detail" TEXT
	);

CREATE TRIGGER "preventModificationLog"
BEFORE UPDATE OR DELETE OR TRUNCATE ON "Log" 
FOR STATEMENT EXECUTE PROCEDURE "preventModification"();
*/

CREATE TRIGGER "preventModificationGasBottleStateLog"
BEFORE UPDATE OR DELETE OR TRUNCATE ON "GasBottleStateLog" 
FOR STATEMENT EXECUTE PROCEDURE "preventModification"();


CREATE TRIGGER "preventModificationGasBottleSell"
BEFORE UPDATE OR DELETE OR TRUNCATE ON "GasBottleSell" 
FOR STATEMENT EXECUTE PROCEDURE "preventModification"();


CREATE OR REPLACE FUNCTION "preventGasBottleIncorrectStateModification"()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS $$
DECLARE
  currentStateInLog "GasBottleStateLog"%ROWTYPE;
  currentState "BottleState"%ROWTYPE;
  wantedState "BottleState"%ROWTYPE;
  nextState "BottleState"%ROWTYPE;
  /*adminStateId INTEGER;*/
  modifierProfil "AccountProfil"%ROWTYPE;
BEGIN
	/*
	SELECT "Id" INTO adminStateId FROM "ProfilType" WHERE "Name" = 'admin';
	IF NOT FOUND THEN
		RAISE NOTICE 'Admin id "%"', adminStateId;
		RAISE EXCEPTION 'Configuration ERROR: admin profile not Found';
	END IF;	
	*/
	SELECT * INTO wantedState FROM "BottleState" WHERE "Id" = NEW."StateId" LIMIT 1;
	SELECT * INTO modifierProfil FROM "AccountProfil" WHERE "Id" = NEW."ModifierId" LIMIT 1;
	SELECT * INTO currentStateInLog FROM "GasBottleStateLog" WHERE "GasBottleId" = NEW."GasBottleId" ORDER BY "ExecutionTime" DESC LIMIT 1;
	IF FOUND THEN 
		SELECT * INTO currentState FROM "BottleState" WHERE "Id" = currentStateInLog."StateId" LIMIT 1;
		SELECT * FROM "BottleState" WHERE "Order" > (SELECT "Order" FROM "BottleState" WHERE "Id" = currentStateInLog."StateId") ORDER BY "Order" LIMIT 1 INTO nextState;
		IF NOT FOUND THEN
			SELECT * FROM "BottleState" ORDER BY "Order" LIMIT 1 INTO nextState;
		END IF;
		IF NEW."StateId" <> nextState."Id" THEN 
			RAISE EXCEPTION 'Cannot Go from state "%" to state "%"', currentState."StateName", wantedState."StateName" USING HINT = 'Please check process';
		END IF;
		IF modifierProfil."ProfilTypeId" <> nextState."ProfilTypeId" /*AND adminStateId <> modifierProfil."ProfilTypeId"*/ THEN
			RAISE EXCEPTION 'Operation not authorized';
		END IF;
		RETURN NEW;
	ELSIF modifierProfil."ProfilTypeId" <> wantedState."ProfilTypeId" /*AND adminStateId <> modifierProfil."ProfilTypeId"*/ THEN
		RAISE EXCEPTION 'Operation not authorized' USING HINT = 'Please check process';
	END IF;
	RETURN NEW;
END $$;

CREATE TRIGGER "preventGasBottleIncorrectStateModificationGasBottleStateLog"
BEFORE INSERT ON "GasBottleStateLog" 
FOR ROW EXECUTE PROCEDURE "preventGasBottleIncorrectStateModification"();
	
	
--- Testing
INSERT INTO "Account" ("Username", "PasswordHash")
VALUES 
	('sandy', '$2b$12$pPmjYp5JvbCkJgXM0T6q3OrB.WQ5bMMN0zmLRj9DI/1gEtlQemIgC'),
	('0000 - 0000 - 000', '$2b$12$rifDmvqZaZ/YzHKCmBD6Tum/JecfXFY.IrVW5cNY7ezOMBnklyY2a'),
	('1000 - 0000 - 000', '$2b$12$/NAttS6I3WAE6Syg/pTAYe2FCmxyIFxH8EdpqCioMzjNvwCVDuxMu'),
	('2000 - 0000 - 000', '$2b$12$RlaQvi0UFtzin7SSalDe9uRceHVlWX.qTvx/OvkdjX/T3buEQJALq'),
	('3000 - 0000 - 000', '$2b$12$7jGY2HrLvlp20DRCp/RSJexRTHtpFCaQWu17QU1rTmp6eH1Mb71rm')
;


INSERT INTO "ProfilType" ("Name")
VALUES 
	('admin'), --1
	('emplisseur'), --2
	('marketeur'), --3
	('revendeur'), --4
	('client') --5
;

INSERT INTO "AccountProfil" ("AccountId","ProfilTypeId")
VALUES
	('1', '1'),
	('1', '2'),
	('1', '3'),
	('1', '4'),
	('1', '5'),
	('2', '2'),
	('3', '3'),
	('4', '4'),
	('5', '5')
;

INSERT INTO "BottleState" ("StateName", "Order", "ProfilTypeId")
VALUES
	('vide chez marketeur', '1', '3'),
	('prete a etre remplie', '2', '2'),
	('prete a etre livree au marketeur', '3', '2'),
	('en cours de livraison au marketeur', '4', '2'),
	('chez marketeur', '5', '3'),
	('en cours de livraison au revendeur', '6', '3'),
	('pleine chez le revendeur', '7', '4'),
	('pleine chez le client', '8', '5'),
	('vide chez le client', '9', '5'),
	('vide chez le revendeur', '10', '4'),
	('vide en cours de livraison au marketeur', '11', '4')
;

INSERT INTO "GasBottle" ("QRCodeHash", "Description", "CapaciteEnKg")
VALUES
	('1', 'bouteille 1', 12.5)
;


/*
INSERT INTO "GasBottleStateLog" ("GasBottleId", "StateId", "ModifierId")
VALUES
	('1', '1', '3')
;*/