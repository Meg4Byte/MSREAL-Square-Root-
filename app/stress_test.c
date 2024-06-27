/**
 * @file stress_test.c
 * @brief Program za stres testiranje drajvera.
 *
 * Ovaj program generise nasumicne brojeve u datom opsegu (4-8 brojeva )
 * i salje ih drajveru u nasumičnim intervalima (1 - 5 s)
 * Potom cita rezultate txt fajla "results.txt" koji ima rezultate iz drajvera
 * i proverava ih u odnosu na ocekivane vrednosti koje je izracunao softverski.
 *
 * @author Nenad Petrovic EE69/2018
 * @date 15.06.2024.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>
#include <math.h>

#define MIN_INTERVAL_WRITE 1
#define MAX_INTERVAL_WRITE 5

#define MIN_INTERVAL_READ 3
#define MAX_INTERVAL_READ 5

#define MIN_ARRAY_LENGTH 4
#define MAX_ARRAY_LENGTH 8

#define MAX_NUMBER 1073741824  // 2^30

#define INPUT_FILE "input_sim.txt"
#define RESULTS_FILE "results_sim.txt"


/**
 * @brief generise nasumicni broj u zadatom opsegu
 *
 * Ova funkcija koristi rand() za generisanje nasumicnog broja
 * izmedju min i max (i min i max brojeve)
 *
 * @param min minimalna vrednost opsega
 * @param max maksimalna vrednost opsega
 * @return nasumicno generisan broj u zadatom opsegu
 */
int random_range(int min, int max)
{
    return min + rand() % (max - min + 1);
}

/**
 * @brief generise niz nasumicnih brojeva
 *
 * Ova funkcija popunjava niz sa nasumicno generisanim
 * brojevima koji su kvadrati brojeva u opsegu od 0 do sqrt(2^30)
 *
 * @param arr pokazivac na niz koji će biti popunjen
 * @param length duzina niza
 */
void generate_random_array(int *arr, int len)
{
    for (int i = 0; i < len; ++i)
    {
        int num = random_range(0, (int)sqrt(MAX_NUMBER));
        arr[i] = num * num;
    }
}

/**
 * @brief funkcija za citanje iz fajla
 *
 * Ova funkcija cita iz fajla koji je drajver napunio rezultatima
 * potom parsira x i y u proverava da li uvek postoje uredjeni parovi
 * ako postoje softverski izracunaj sqrt(x) i uporedi sa y
 * ako je sqrt(x) == y printuj tacno
 * u suprotnom netacno i korektan rezultat za koren
 * ako fajl ne postoji vrati error
 *
 * @param results const pointer na fajl
 */
void check_results()
{
    FILE *file = fopen(RESULTS_FILE, "r");      // pokazivac na fajl (FILE *file ) otvori i citaj

    if (file == NULL)
    {
        perror("Error , cannot open file!");    //printuj error ako fajl ne postoji
        return;
    }

    char line[256];
    /*
     * citaj ceo fajl i posto su rezultati u formatu x:y , onda parsiraj x i y
     * gledaj svaki x i y par i racunaj sqrt(x) u softveru
     * ispisi ako je tacno , ispisi ako je natacno i koren koji bi trebao da bude umesto netacnog
     */
    while (fgets(line, sizeof(line), file))
    {
        int x, y;
        if (sscanf(line, "%d:%d", &x, &y) == 2)
        {
            /*
             * ovaj kod je modifikacija u odnosu na sqrt(x) = y , jer nije
             * dobra ideja raditi poredjenje float vrednosti , usled
             * greske zaokruzivanja , iako je pretpostavljeno da su
             * svi brojevi int i njihovi rezultati moraju biti int
             * ipak ovo provera stoji za svaki slucaj
             * sqrt_x * sqrt_x -- mora biti int , to je dodatna provera
             * a sqrt_x = y je standarna provera korektnosti
            */

            int sqrt_x = (int)sqrt(x);
            if (sqrt_x * sqrt_x == x && sqrt_x == y)
            {
                printf("Tacan rezultat: %d:%d\n", x, y);
            }

            else
            {
                printf("Netacan rezultat: %d:%d (tacan rezultat je : %d)\n", x, y, (int)sqrt(x));
            }
        }
    }

    fclose(file);
}


int main()
{
    srand(time(NULL));

    while (1)
    {
        int write_interval = random_range(MIN_INTERVAL_WRITE, MAX_INTERVAL_WRITE);
        sleep(write_interval);

        int array_length = random_range(MIN_ARRAY_LENGTH, MAX_ARRAY_LENGTH);
        int random_array[MAX_ARRAY_LENGTH];
        generate_random_array(random_array, array_length);

        FILE *input_file = fopen(INPUT_FILE , "w");
        if (input_file == NULL)
        {
            perror("Error, cannot open input file!");
            return 1;
        }

        for (int i = 0; i < array_length; ++i)
        {
            fprintf(input_file, "%d\n", random_array[i]);
        }

        fclose(input_file);

        printf("Poslato %d brojeva\n", array_length);

        int read_interval = random_range(MIN_INTERVAL_READ, MAX_INTERVAL_READ);
        sleep(read_interval);

        check_results();
    }

    return 0;
}
