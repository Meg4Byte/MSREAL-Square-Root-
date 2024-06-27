# MSREAL-Square-Root-
Razviti Linux drajver i odgovarajuću aplikaciju koja koristi drajver i demonstrira kontrolu i upravljanje sqrt IP jezgrom
## Intro
- [Detaljan opis projekta](#detaljan-opis-projekta)
  - [Tekst zadatka projekta](#tekst-zadatka-projekta)
  - [Opis strukture hardvera](#opis-strukture-hardvera)
  - [Registar Ofseti](#registar-ofseti)
  - [Koraci](#koraci)
  - [Primer korišćenja drajvera](#primer-korišćenja-drajvera)
## Detaljan opis projekta
    
### Tekst zadatka projekta
Razviti Linux drajver i odgovarajuću aplikaciju koja koristi drajver i demonstrira kontrolu i upravljanje sqrt IP jezgrom.
    
### Opis strukture hardvera
Četiri identična sqrt IP jezgra (zelena boja na blok dijagramu) su memorijski mapirana u adresni prostor ZYNQ procesora. Sqrt jezgro služi za računanje celobrojnog kvadratnog korena. IP jezgro koristi brute-force algoritam, pri čemu jezgru treba “n” mašinskih ciklusa za računanje kvadratnog korena broja “n” [vreme izvršavanja je linearno O(n)]. Sva jezgra na fpga čipu rade na frekvenciji od 100MHz. Nakon što sqrt ip jezgro izračuna kvadratni koren, ono šalje interrupt prekidni signal procesoru (ljubičasta boja na blok dijagramu), čime signalizira da je obrada podatka završena.
    
Sqrt jezgro ima četiri registra: `X`, `start`, `Y` i `ready` koja su memorijski mapirana i kojima se pristupa uz baznu adresu sqrt modula i ofseta za određeni registar (videti ofsete registara u datoj tabeli).

### Registar Ofseti
| Offset          | Registar         |
|-----------------|------------------|
| 0               | X                |        
| 4               | start            |
| 8               | Y                |
| 12              | ready            |
| 16              | interrupt_flag   |

- **X registar:** Smešta 32-bitni broj čiji se koren traži.
- **Start registar:** Služi za pokretanje jezgra i početak računanja korena.
- **Y registar:** Po završetku računanja, smešta rezultat, tj. kvadratni koren broja `X`.
- **Ready registar:** Indikuje da li je sqrt završio sa računanjem.

### Koraci
1. **Priprema SD kartice:**
    - Pripremiti SD karticu sa svim potrebnim datotekama (`BOOT.bin`, `devicetree.dtb` i `uImage`) koje omogućavaju podizanje Linux operativnog sistema, sa gore opisanim dizajnom uključenim u `BOOT.bin` datoteku.
2. **Linux drajver:**
    - Napisati Linux drajver za sqrt modul i propratnu aplikaciju sa sledećim funkcionalnostima:
        - Drajver dobija slobodne upravljačke brojeve (MAJOR, MINOR) od operativnog sistema.
        - Automatski kreira node fajl `/dev/sqrt`.
        - Kontroliše četiri sqrt modula i gpio modul koji se koristi za kontrolu dioda.
3. **Aplikacija:**
    - Aplikacija u C jeziku koja stres-testira drajver tako što u nasumičnim intervalima od 1-5 sekundi šalje nizove nasumične dužine (4-8 članova) nasumičnih brojeva (koji imaju celobrojne kvadrate, te su u dozvoljenom opsegu). Takođe, aplikacija u nasumičnim intervalima od 3-5 sekundi čita do tog trenutka izračunate brojeve i proverava dobijene rezultate (parove x:y).

### Primer korišćenja drajvera
```bash
echo “16,255,9,10000,176400,16000000,25,1073741824” > /dev/sqrt
```
```bash
cat /dev/sqrt
```
# Očekivani izlaz:
# 16:4, 255:25, 9:3, 10000:100, 176400:420, 16000000:4000, 25:5, 1073741824:32768
