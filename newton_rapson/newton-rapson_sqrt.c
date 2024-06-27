#include <stdio.h>
#include <stdlib.h>

// Funkcija za apsolutnu vrednost
int abs(int x)
{
    return x < 0 ? -x : x;
}

/**
 * @brief Pronalazi celobrojni kvadratni koren datog broja koristeci Newton-Raphsonov metod.
 *
 * Ova funkcija koristi iterativni Newton-Raphsonov algoritam za pronalazenje najveceg celog broja
 * ciji kvadrat nije veci od datog broja n. Ukoliko je n negativan, funkcija vraca -1,
 * jer kvadratni koren negativnog broja nije definisan u realnom domenu. Za nule i jedinice,
 * funkcija vraca sam n jer su njihovi kvadratni koreni 0 i 1.
 *
 * @param n Broj za koji se trazi celobrojni kvadratni koren. Mora biti nenegativan.
 * @return Najveci ceo broj ciji kvadrat nije veci od n. Ako je n negativan, vraća -1.
 */
int newton_sqrt(int n)
{
    if (n < 0)
    {
        return -1; // Kvadratni koren negativnog broja nije definisan u realnom domenu
    }
    if (n == 0 || n == 1)
    {
        return n;
    }

    int x = n;                  // Početna procena
    int y = (x + n / x) / 2;    // Prva iteracija

    // Iteriramo dok ne dostignemo odredjenu preciznost (u clucaju korena to je 1 jer najmanja greska je za sqrt(2) = 1
    while (abs(y - x) > 1)
    {
        x = y;
        y = (x + n / x) / 2;
    }

    return y;
}

int main()
{
    int arr[] = {16 , 15 , 0 , -32 , 1073741824 , 99 , 225 , 2 , 70707 };
    int array_size = sizeof(arr) / sizeof(arr[0]);

    for (int i = 0; i < array_size; ++i)
    {
        int result = newton_sqrt(arr[i]);
        printf("Kvadratni koren broja %d je %d\n", arr[i], result);
    }

    return 0;
}
