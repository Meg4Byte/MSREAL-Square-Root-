#include <stdio.h>

/**
 * @brief Pronalazi celobrojni kvadratni koren datog broja koristeci binarnu pretragu.
 *
 * Ova funkcija koristi algoritam binarne pretrage za pronalazenje najveceg celog broja
 * ciji kvadrat nije veci od datog broja n. Ukoliko je n negativan, funkcija vraca -1,
 * jer kvadratni koren negativnog broja nije definisan u realnom domenu.
 *
 * @param n Broj za koji se trazi celobrojni kvadratni koren. Mora biti nenegativan.
 * @return Najveci ceo broj ciji kvadrat nije veći od n. Ako je n negativan, vraca -1.
 */
int binary_search_sqrt(int n)
{
    if (n < 0)
    {
        return -1;  // Kvadratni koren negativnog broja nije definisan u realnom domenu
    }

    int low = 0, high = n, mid;
    while (low <= high)
    {
        mid = (low + high) / 2;
        if (mid * mid == n)
        {
            return mid;
        }
        else if (mid * mid < n)
        {
            low = mid + 1;
        }
        else
        {
            high = mid - 1;
        }
    }

    return high;
}

int main()
{
    int arr[] = {16 , 15 , 0 , -32 , 1073741824 , 99 , 225 , 2 , 70707 };
    int array_size = sizeof(arr) / sizeof(arr[0]);

    for (int i = 0; i < array_size; ++i)
    {
        int result = binary_search_sqrt(arr[i]);
        printf("Kvadratni koren broja %d je %d\n", arr[i], result);
    }
}

