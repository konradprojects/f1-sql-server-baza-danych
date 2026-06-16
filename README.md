# Baza danych wyników Formuły 1

Projekt relacyjnej bazy danych dotyczącej wyników Formuły 1, wykonany w środowisku Microsoft SQL Server.

Baza przechowuje informacje o sezonach, zespołach, kierowcach, torach, kontraktach kierowców, wyścigach oraz wynikach uzyskanych w poszczególnych rundach.

Projekt został wykonany jako praca zaliczeniowa na IV semestrze studiów informatycznych, a następnie uporządkowany i rozbudowany na potrzeby repozytorium GitHub.

## Technologie

- Microsoft SQL Server
- SQL Server Management Studio
- T-SQL
- Git
- GitHub

## Struktura bazy danych

Baza zawiera 7 tabel:

- `SEZON` — informacje o sezonach Formuły 1,
- `ZESPOL` — dane zespołów,
- `KIEROWCA` — informacje o kierowcach,
- `TOR` — dane torów wyścigowych,
- `KONTRAKT_KIEROWCY` — przypisanie kierowcy do zespołu w danym sezonie,
- `WYSCIG` — informacje o rundach Grand Prix,
- `WYNIK_WYSCIGU` — wyniki kierowców w poszczególnych wyścigach.

W bazie zastosowano:

- klucze podstawowe,
- klucze obce,
- relacje pomiędzy tabelami,
- kolumny `IDENTITY`,
- ograniczenie `UNIQUE`, które zapobiega zapisaniu dwóch wyników tego samego kierowcy w jednym wyścigu.

## Zawartość repozytorium

### `01_schema_and_data.sql`

Skrypt tworzący tabele, relacje, ograniczenia oraz przykładowe dane w utworzonej wcześniej pustej bazie danych.

### `02_queries_analytics.sql`

Zestaw zapytań analitycznych obejmujący między innymi:

- klasyfikację kierowców i zespołów,
- liczbę zwycięstw, miejsc na podium i najszybszych okrążeń,
- porównanie pozycji startowej i końcowej,
- analizę wyników DNF,
- złączenia wewnętrzne i zewnętrzne,
- funkcje agregujące,
- `GROUP BY`,
- `ROLLUP`,
- `CUBE`,
- `PIVOT`,
- CTE,
- `RANK()`,
- `NTILE()`.

### `03_crud_examples.sql`

Przykłady operacji wykonywanych na danych:

- `INSERT`,
- `SELECT`,
- `UPDATE`,
- `DELETE`.

Operacje przedstawiają dodanie zespołu Aston Martin, zmianę jego dostawcy silnika oraz usunięcie rekordu.

## Przykładowe analizy

Na podstawie danych zapisanych w bazie można sprawdzić między innymi:

- klasyfikację kierowców według zdobytych punktów,
- klasyfikację zespołów,
- średnią liczbę punktów kierowcy na wyścig,
- liczbę zwycięstw i miejsc na podium,
- bilans zyskanych i straconych pozycji,
- liczbę nieukończonych wyścigów,
- procent wyników DNF,
- kierowców z wynikiem powyżej średniej,
- ranking oraz podział kierowców na grupy,
- punkty zespołów w formie tabeli przestawnej.

## Uruchomienie projektu

1. Otwórz Microsoft SQL Server Management Studio.
2. Połącz się z lokalnym lub zdalnym serwerem SQL Server.
3. Utwórz pustą bazę danych, np. `F1_BAZA`.
4. Wybierz utworzoną bazę jako aktywną bazę w SSMS.
5. Otwórz plik `01_schema_and_data.sql` i uruchom cały skrypt.
6. Otwórz plik `02_queries_analytics.sql` i uruchamiaj wybrane zapytania analityczne.
7. Otwórz plik `03_crud_examples.sql`, aby przetestować operacje dodawania, modyfikowania i usuwania danych.

Skrypt `01_schema_and_data.sql` należy uruchomić przed pozostałymi plikami.

## Dane testowe

Projekt zawiera przykładowe dane kierowców, zespołów, torów i wyścigów Formuły 1.

Tabela `WYNIK_WYSCIGU` zawiera 30 przykładowych wyników, które umożliwiają wykonanie zapytań analitycznych i sprawdzenie działania relacji między tabelami.

## Autor

Konrad Cieślak

Projekt wykonany w ramach studiów informatycznych.
