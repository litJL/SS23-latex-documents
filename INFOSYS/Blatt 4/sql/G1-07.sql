SELECT name FROM professoren WHERE rang = 'C1';


SELECT DISTINCT rang FROM professoren;


SELECT titel FROM vorlesungen,hoeren WHERE hoeren.matrnr = 378319 AND vorlesungen.vorlnr = hoeren.vorlnr;


SELECT name, studenten.matrnr FROM studenten, hoeren, vorlesungen WHERE studenten.matrnr = hoeren.matrnr AND hoeren.vorlnr = vorlesungen.vorlnr AND vorlesungen.titel = 'Information Retrieval';