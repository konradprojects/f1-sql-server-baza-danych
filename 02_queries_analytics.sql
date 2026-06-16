/*
    Zapytania analityczne - baza wyników Formuły 1
    Microsoft SQL Server
    Autor: Konrad Cieślak
*/

-- Zapytanie 1
-- Klasyfikacja kierowców według liczby punktów,
-- liczby startów i średniej punktów na wyścig.

SELECT
    K.IMIE,
    K.NAZWISKO,
    SUM(WW.PUNKTY) AS SUMA_PUNKTOW,
    COUNT(*) AS LICZBA_STARTOW,
    CAST(
        AVG(CAST(WW.PUNKTY AS DECIMAL(5, 2)))
        AS DECIMAL(5, 2)
    ) AS SREDNIA_PUNKTOW_NA_WYSCIG
FROM WYNIK_WYSCIGU AS WW
JOIN KIEROWCA AS K
    ON K.ID_KIEROWCY = WW.ID_KIEROWCY
GROUP BY
    K.ID_KIEROWCY,
    K.IMIE,
    K.NAZWISKO
ORDER BY
    SUMA_PUNKTOW DESC;


-- Zapytanie 2
-- Klasyfikacja zespołów według sumy punktów oraz liczby startów ich kierowców.

SELECT
    Z.NAZWA AS ZESPOL,
    SUM(WW.PUNKTY) AS SUMA_PUNKTOW,
    COUNT(*) AS LICZBA_STARTOW_KIEROWCOW
FROM WYNIK_WYSCIGU AS WW
JOIN WYSCIG AS W
    ON W.ID_WYSCIGU = WW.ID_WYSCIGU
JOIN KONTRAKT_KIEROWCY AS KK
    ON KK.ID_KIEROWCY = WW.ID_KIEROWCY
    AND KK.ID_SEZONU = W.ID_SEZONU
JOIN ZESPOL AS Z
    ON Z.ID_ZESPOLU = KK.ID_ZESPOLU
GROUP BY
    Z.ID_ZESPOLU,
    Z.NAZWA
ORDER BY
    SUMA_PUNKTOW DESC;


-- Zapytanie 3
-- Liczba zwycięstw, miejsc na podium i najszybszych okrążeń kierowców.

SELECT
    K.IMIE,
    K.NAZWISKO,
    SUM(
        CASE
            WHEN WW.POZYCJA_KONCOWA = 1 THEN 1
            ELSE 0
        END
    ) AS ZWYCIESTWA,
    SUM(
        CASE
            WHEN WW.POZYCJA_KONCOWA BETWEEN 1 AND 3 THEN 1
            ELSE 0
        END
    ) AS PODIA,
    SUM(
        CASE
            WHEN WW.NAJSZYBSZE_OKRAZENIE = 1 THEN 1
            ELSE 0
        END
    ) AS NAJSZYBSZE_OKRAZENIA
FROM WYNIK_WYSCIGU AS WW
JOIN KIEROWCA AS K
    ON K.ID_KIEROWCY = WW.ID_KIEROWCY
GROUP BY
    K.ID_KIEROWCY,
    K.IMIE,
    K.NAZWISKO
ORDER BY
    ZWYCIESTWA DESC,
    PODIA DESC,
    NAJSZYBSZE_OKRAZENIA DESC;


-- Zapytanie 4
-- Porównanie pozycji startowej i końcowej kierowców w poszczególnych wyścigach.

SELECT
    W.NUMER_RUNDY,
    W.NAZWA AS WYSCIG,
    K.IMIE,
    K.NAZWISKO,
    WW.POZYCJA_STARTOWA,
    WW.POZYCJA_KONCOWA,
    WW.POZYCJA_STARTOWA - WW.POZYCJA_KONCOWA AS ZYSK_POZYCJI,
    WW.STATUS
FROM WYNIK_WYSCIGU AS WW
JOIN WYSCIG AS W
    ON W.ID_WYSCIGU = WW.ID_WYSCIGU
JOIN KIEROWCA AS K
    ON K.ID_KIEROWCY = WW.ID_KIEROWCY
ORDER BY
    ZYSK_POZYCJI DESC,
    W.NUMER_RUNDY;


-- Zapytanie 5
-- Podsumowanie bilansu pozycji każdego kierowcy w ukończonych wyścigach.

SELECT
    K.IMIE,
    K.NAZWISKO,
    SUM(
        WW.POZYCJA_STARTOWA - WW.POZYCJA_KONCOWA
    ) AS LACZNY_BILANS_POZYCJI,
    CAST(
        AVG(
            CAST(
                WW.POZYCJA_STARTOWA - WW.POZYCJA_KONCOWA
                AS DECIMAL(5, 2)
            )
        )
        AS DECIMAL(5, 2)
    ) AS SREDNI_BILANS_POZYCJI,
    MAX(
        WW.POZYCJA_STARTOWA - WW.POZYCJA_KONCOWA
    ) AS NAJWIEKSZY_ZYSK,
    MIN(
        WW.POZYCJA_STARTOWA - WW.POZYCJA_KONCOWA
    ) AS NAJWIEKSZA_STRATA
FROM WYNIK_WYSCIGU AS WW
JOIN KIEROWCA AS K
    ON K.ID_KIEROWCY = WW.ID_KIEROWCY
WHERE WW.STATUS = 'ukończył'
GROUP BY
    K.ID_KIEROWCY,
    K.IMIE,
    K.NAZWISKO
ORDER BY
    LACZNY_BILANS_POZYCJI DESC;


-- Zapytanie 6
-- Liczba startów i wyników DNF zespołów oraz procent startów zakończonych wynikiem DNF.

SELECT
    Z.NAZWA AS ZESPOL,
    COUNT(*) AS LICZBA_STARTOW,
    SUM(
        CASE
            WHEN WW.STATUS = 'DNF' THEN 1
            ELSE 0
        END
    ) AS LICZBA_DNF,
    CAST(
        100.0 * SUM(
            CASE
                WHEN WW.STATUS = 'DNF' THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5, 2)
    ) AS PROCENT_DNF
FROM WYNIK_WYSCIGU AS WW
JOIN WYSCIG AS W
    ON W.ID_WYSCIGU = WW.ID_WYSCIGU
JOIN KONTRAKT_KIEROWCY AS KK
    ON KK.ID_KIEROWCY = WW.ID_KIEROWCY
    AND KK.ID_SEZONU = W.ID_SEZONU
JOIN ZESPOL AS Z
    ON Z.ID_ZESPOLU = KK.ID_ZESPOLU
GROUP BY
    Z.ID_ZESPOLU,
    Z.NAZWA
ORDER BY
    LICZBA_DNF DESC,
    PROCENT_DNF DESC;


-- Zapytanie 7
-- Klasyfikacja wszystkich kierowców, również tych, którzy nie mają jeszcze wyników w wyścigach.

SELECT
    K.IMIE,
    K.NAZWISKO,
    COUNT(WW.ID_WYNIKU) AS LICZBA_WYNIKOW,
    ISNULL(SUM(WW.PUNKTY), 0) AS SUMA_PUNKTOW
FROM KIEROWCA AS K
LEFT JOIN WYNIK_WYSCIGU AS WW
    ON WW.ID_KIEROWCY = K.ID_KIEROWCY
GROUP BY
    K.ID_KIEROWCY,
    K.IMIE,
    K.NAZWISKO
ORDER BY
    SUMA_PUNKTOW DESC;


-- Zapytanie 8
-- Punkty zespołów w poszczególnych wyścigach oraz podsumowania utworzone za pomocą ROLLUP.

SELECT
    CASE
        WHEN W.NAZWA IS NULL THEN 'RAZEM'
        ELSE W.NAZWA
    END AS WYSCIG,
    CASE
        WHEN Z.NAZWA IS NULL THEN 'RAZEM'
        ELSE Z.NAZWA
    END AS ZESPOL,
    SUM(WW.PUNKTY) AS SUMA_PUNKTOW
FROM WYNIK_WYSCIGU AS WW
JOIN WYSCIG AS W
    ON W.ID_WYSCIGU = WW.ID_WYSCIGU
JOIN KONTRAKT_KIEROWCY AS KK
    ON KK.ID_KIEROWCY = WW.ID_KIEROWCY
    AND KK.ID_SEZONU = W.ID_SEZONU
JOIN ZESPOL AS Z
    ON Z.ID_ZESPOLU = KK.ID_ZESPOLU
GROUP BY
    W.NAZWA,
    Z.NAZWA
WITH ROLLUP;


-- Zapytanie 9
-- Przekrój punktów według wyścigów i zespołów z podsumowaniami utworzonymi za pomocą CUBE.

SELECT
    CASE
        WHEN W.NAZWA IS NULL THEN 'RAZEM'
        ELSE W.NAZWA
    END AS WYSCIG,
    CASE
        WHEN Z.NAZWA IS NULL THEN 'RAZEM'
        ELSE Z.NAZWA
    END AS ZESPOL,
    SUM(WW.PUNKTY) AS SUMA_PUNKTOW
FROM WYNIK_WYSCIGU AS WW
JOIN WYSCIG AS W
    ON W.ID_WYSCIGU = WW.ID_WYSCIGU
JOIN KONTRAKT_KIEROWCY AS KK
    ON KK.ID_KIEROWCY = WW.ID_KIEROWCY
    AND KK.ID_SEZONU = W.ID_SEZONU
JOIN ZESPOL AS Z
    ON Z.ID_ZESPOLU = KK.ID_ZESPOLU
GROUP BY
    W.NAZWA,
    Z.NAZWA
WITH CUBE;


-- Zapytanie 10
-- Punkty zespołów w formie tabeli przestawnej. Zespoły znajdują się w wierszach, a wyścigi w kolumnach.

SELECT
    ZESPOL,
    ISNULL(
        [Grand Prix Australii],
        0
    ) AS [Grand Prix Australii],
    ISNULL(
        [Grand Prix Chin],
        0
    ) AS [Grand Prix Chin],
    ISNULL(
        [Grand Prix Japonii],
        0
    ) AS [Grand Prix Japonii],
    ISNULL(
        [Grand Prix Bahrajnu],
        0
    ) AS [Grand Prix Bahrajnu],
    ISNULL(
        [Grand Prix Arabii Saudyjskiej],
        0
    ) AS [Grand Prix Arabii Saudyjskiej]
FROM
(
    SELECT
        Z.NAZWA AS ZESPOL,
        W.NAZWA AS WYSCIG,
        WW.PUNKTY
    FROM WYNIK_WYSCIGU AS WW
    JOIN WYSCIG AS W
        ON W.ID_WYSCIGU = WW.ID_WYSCIGU
    JOIN KONTRAKT_KIEROWCY AS KK
        ON KK.ID_KIEROWCY = WW.ID_KIEROWCY
        AND KK.ID_SEZONU = W.ID_SEZONU
    JOIN ZESPOL AS Z
        ON Z.ID_ZESPOLU = KK.ID_ZESPOLU
) AS DANE
PIVOT
(
    SUM(PUNKTY)
    FOR WYSCIG IN
    (
        [Grand Prix Australii],
        [Grand Prix Chin],
        [Grand Prix Japonii],
        [Grand Prix Bahrajnu],
        [Grand Prix Arabii Saudyjskiej]
    )
) AS TABELA_PRZESTAWNA
ORDER BY
    ZESPOL;


-- Zapytanie 11
-- Kierowcy, którzy zdobyli więcej punktów niż średnia punktów wszystkich kierowców.

WITH PUNKTY_KIEROWCOW AS
(
    SELECT
        K.ID_KIEROWCY,
        K.IMIE,
        K.NAZWISKO,
        SUM(WW.PUNKTY) AS SUMA_PUNKTOW
    FROM WYNIK_WYSCIGU AS WW
    JOIN KIEROWCA AS K
        ON K.ID_KIEROWCY = WW.ID_KIEROWCY
    GROUP BY
        K.ID_KIEROWCY,
        K.IMIE,
        K.NAZWISKO
)
SELECT
    IMIE,
    NAZWISKO,
    SUMA_PUNKTOW,
    (
        SELECT
            CAST(
                AVG(
                    CAST(
                        SUMA_PUNKTOW AS DECIMAL(10, 2)
                    )
                )
                AS DECIMAL(10, 2)
            )
        FROM PUNKTY_KIEROWCOW
    ) AS SREDNIA_PUNKTOW
FROM PUNKTY_KIEROWCOW
WHERE SUMA_PUNKTOW >
(
    SELECT
        AVG(
            CAST(
                SUMA_PUNKTOW AS DECIMAL(10, 2)
            )
        )
    FROM PUNKTY_KIEROWCOW
)
ORDER BY
    SUMA_PUNKTOW DESC;


-- Zapytanie 12
-- Ranking kierowców według liczby zdobytych punktów.

SELECT
    RANK() OVER (
        ORDER BY SUM(WW.PUNKTY) DESC
    ) AS MIEJSCE,
    K.IMIE,
    K.NAZWISKO,
    SUM(WW.PUNKTY) AS SUMA_PUNKTOW
FROM WYNIK_WYSCIGU AS WW
JOIN KIEROWCA AS K
    ON K.ID_KIEROWCY = WW.ID_KIEROWCY
GROUP BY
    K.ID_KIEROWCY,
    K.IMIE,
    K.NAZWISKO
ORDER BY
    MIEJSCE;


-- Zapytanie 13
-- Podział kierowców na dwie grupy według liczby zdobytych punktów.

SELECT
    NTILE(2) OVER (
        ORDER BY SUM(WW.PUNKTY) DESC
    ) AS GRUPA,
    K.IMIE,
    K.NAZWISKO,
    SUM(WW.PUNKTY) AS SUMA_PUNKTOW
FROM WYNIK_WYSCIGU AS WW
JOIN KIEROWCA AS K
    ON K.ID_KIEROWCY = WW.ID_KIEROWCY
GROUP BY
    K.ID_KIEROWCY,
    K.IMIE,
    K.NAZWISKO
ORDER BY
    GRUPA,
    SUMA_PUNKTOW DESC;


-- Zapytanie 14
-- Najlepsza, najgorsza i średnia pozycja końcowa kierowców w ukończonych wyścigach.

SELECT
    K.IMIE,
    K.NAZWISKO,
    COUNT(*) AS LICZBA_UKONCZONYCH_WYSCIGOW,
    MIN(WW.POZYCJA_KONCOWA) AS NAJLEPSZA_POZYCJA,
    MAX(WW.POZYCJA_KONCOWA) AS NAJGORSZA_POZYCJA,
    CAST(
        AVG(
            CAST(
                WW.POZYCJA_KONCOWA AS DECIMAL(5, 2)
            )
        )
        AS DECIMAL(5, 2)
    ) AS SREDNIA_POZYCJA_KONCOWA
FROM WYNIK_WYSCIGU AS WW
JOIN KIEROWCA AS K
    ON K.ID_KIEROWCY = WW.ID_KIEROWCY
WHERE WW.STATUS = 'ukończył'
GROUP BY
    K.ID_KIEROWCY,
    K.IMIE,
    K.NAZWISKO
ORDER BY
    SREDNIA_POZYCJA_KONCOWA,
    NAJLEPSZA_POZYCJA;


-- Zapytanie 15
-- Liczba startów, ukończonych wyścigów i wyników DNF oraz procent DNF poszczególnych kierowców.

SELECT
    K.IMIE,
    K.NAZWISKO,
    COUNT(*) AS LICZBA_STARTOW,
    SUM(
        CASE
            WHEN WW.STATUS = 'ukończył' THEN 1
            ELSE 0
        END
    ) AS UKONCZONE_WYSCIGI,
    SUM(
        CASE
            WHEN WW.STATUS = 'DNF' THEN 1
            ELSE 0
        END
    ) AS LICZBA_DNF,
    CAST(
        100.0 * SUM(
            CASE
                WHEN WW.STATUS = 'DNF' THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5, 2)
    ) AS PROCENT_DNF
FROM WYNIK_WYSCIGU AS WW
JOIN KIEROWCA AS K
    ON K.ID_KIEROWCY = WW.ID_KIEROWCY
GROUP BY
    K.ID_KIEROWCY,
    K.IMIE,
    K.NAZWISKO
ORDER BY
    LICZBA_DNF DESC,
    PROCENT_DNF DESC,
    K.NAZWISKO;
