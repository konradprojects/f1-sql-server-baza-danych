/*
    Przykłady wstawiania, modyfikowania i usuwania danych
    Baza wyników Formuły 1
    Microsoft SQL Server
    Autor: Konrad Cieślak
*/

-- Operacja 1 - INSERT
-- Wprowadzenie nowego zespołu Aston Martin do tabeli ZESPOL.

INSERT INTO ZESPOL
(
    NAZWA,
    KRAJ,
    DOSTAWCA_SILNIKA
)
VALUES
(
    'Aston Martin',
    'Wielka Brytania',
    'Mercedes'
);

-- Sprawdzenie, czy nowy zespół został dodany.

SELECT *
FROM ZESPOL
WHERE NAZWA = 'Aston Martin';


-- Operacja 2 - UPDATE
-- Zmiana dostawcy silnika zespołu Aston Martin
-- na bardziej szczegółową nazwę.

UPDATE ZESPOL
SET DOSTAWCA_SILNIKA = 'Mercedes-AMG'
WHERE NAZWA = 'Aston Martin';

-- Sprawdzenie, czy dane zespołu zostały zmodyfikowane.

SELECT *
FROM ZESPOL
WHERE NAZWA = 'Aston Martin';


-- Operacja 3 - DELETE
-- Usunięcie zespołu Aston Martin z tabeli ZESPOL.

DELETE FROM ZESPOL
WHERE NAZWA = 'Aston Martin';

-- Sprawdzenie, czy zespół został usunięty.

SELECT *
FROM ZESPOL
WHERE NAZWA = 'Aston Martin';
