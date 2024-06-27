#include <stdio.h>

/**
 * @brief Funkcija za trazenje celobrojnog kvadratnog korena koristeci brute force metod
 *
 * Ova funkcija koristi jednostavan iterativni pristup za pronalazenje najveceg celog broja
 * ciji kvadrat ne prelazi dati broj n.
 *
 * @param n Broj za koji se trazi celobrojni kvadratni koren
 * @return Najveci ceo broj ciji kvadrat ne prelazi n
 */
int brute_force_sqrt(int n)
{
    if (n < 0)
    {
        return -1;  // Kvadratni koren negativnog broja nije definisan u realnom domenu
    }

    int candidate = 0;
    while (candidate * candidate <= n)
    {
        ++candidate;
    }

    return candidate - 1;
}

int main()
{

    int arr[] = {16 , 15 , 0 , -32 , 1073741824 , 99 , 225 , 2 , 70707 };
    int array_size = sizeof(arr) / sizeof(arr[0]);

    for (int i = 0; i < array_size; ++i)
    {
        int result = brute_force_sqrt(arr[i]);
        printf("Kvadratni koren broja %d je %d\n", arr[i], result);
    }
}
