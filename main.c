#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
//#include <cblas.h>

#define MAX(a,b) (a) < (b) ? (b) : (a)
#define ABS(x)	(((x) < 0) ? -(x) : (x))	

/* Generate a vector with double random values */
void generate_vector(double *vec, long int size);

/* Generate a matrix with double random values */
void generate_matrix(double **mat, long int size);

/* Check the result of the matrix we calculate against the result
 * the library function returns.
 * Return 0 if the result differ and 1 if they are the same 
 */
int check(double *mat1, long int size1, double *mat2, long int size2);

/* Check if the generated matrix is a symmetric one.
 * Return 0 if the result differ and 1 if they are the same 
 */
int check_symmetric(double *mat, long int size);

void generate_matrix(double **mat, long int size)
{

	long int i, j;
	double h[size][size], b[size], fi, fj;

	fi = 0.0;
	for (i = 0; i < size; i += 1)
	{
		b[i] = 0.0;
		fj = 0.0;

		for (j = 0; j < size; j += 1)
		{
			mat[i][j] = 1.0 / (fi + fj + 1.0);
			h[i][j] = mat[i][j];
			b[i] = b[i] + mat[i][j];
			fj = fj + 1.0;
		}
		fi = fi + 1.0;
		mat[i][size] = b[i];
	}
	
}

void init_mat(double **mat, double *vec, long int size)
{
	long int i, j;

	for (i = 0; i < size; i += 1)
	{
		for (j = 0; j < size; j += 1)
		{
			vec[i * size + j] = mat[i][j];
		}
	}
}

int check_symmetric(double *mat, long int size)
{

        long int i, j;

        for (i = 0; i < size; i += 1)
        {
		for (j = i; j < size; j += 1)
		{
			if (mat[j * size + i] != mat[i * size + j])
			{
				return 0;
			}
		}
	}

	return 1;
}


int check(double *mat1, long int size1, double *mat2, long int size2)
{
	long int i;
	double eps = 0.0000001, ret;

	if (size1 != size2)
	{
		return 0;
	}

	for (i = 0; i < size1; i += 1)
	{
		if (mat1[i] < mat2[i])
		{
			ret = mat1[i] / mat2[i];
		} else
		{
			ret = mat2[i] / mat1[i];
		}
		if (ABS(ret - 1) > eps) 
		{
			return 0;
		}
	}

	return 1;
}

void generate_vector(double *vec, long int size)
{
	long int i;

	for (i = 0; i < size; i += 1)
	{
		vec[i] = ((double) rand() / (double) RAND_MAX) * 100.0;
	}
}

/* The implementation of the dsymv function */

void dsymv1(int uplo, long int n, double alpha, double *a, long int lda, double *x,
	long int incx, double beta, double *y, long int incy)
{
	double temp1, temp2;
	int i, info, ix, iy, j, jx, jy, kx, ky, max;

	/* sanity checks*/
	max = MAX(1, n);
	info = 0;
	if ((uplo != 121))
	{
		info = 1;
	} else if (n < 0)
	{
		info = 2;
	} else if (lda < max)
	{
		info = 5;
	} else if (incx == 0)
	{
		info = 7;
	} else if (incy == 0)
	{
		info = 10;
	}
	if (info != 0)
	{
		fprintf(stdout, "info = %d\n", info);
		return;
	}


	if ((n == 0) || ((alpha == 0) && (beta == 1)))
		return;

	if (incx > 0)
	{
		kx = 1;
	} else
	{
		kx = 1 - (n - 1) * incx;
	}

	if (incy > 0)
	{
		ky = 1;
	} else
	{
		ky = 1 - (n - 1) * incy;
	}

	if (beta != 1)
	{
		if (beta == 0)
		{
			for (i = 0; i < n; i += 1)
			{
				y[i] = 0;
			}
		} else
		{
			double aux;
			for (i = 0; i < n; i += 1)
			{
				y[i] *= beta;
			}
		}
	}

	if (alpha == 0)
	{
		return;
	}

	for (i = 0; i < n; i += 1)
	{
		temp1 = 0;
		for (j = 0; j < n; j += 1)
		{
			temp1 += a[i * n + j] * x[j];
		}

		if (alpha != 1)
		{
			temp1 *= alpha;
		}

		y[i] += temp1;
	}
}

int main(int argc, char* argv[])
{
	long int n, lda = 1, incx = 1, incy = 1, alpha, beta, sec, usec, i, j;
	struct timeval tvstart, tvstop;
	double *a, *x, *y, *oldy;
	double **bA;
	double diff1, diff2;
	FILE *f;
	FILE *vecx, *vecy;
	int ret = -1;

   	if (argc < 3)
   	{
        	printf("ERROR! Not enough arguments\n");
        	return 1;
    	}
    
    	n = atoi(argv[1]);

	lda = MAX(1, n);

	srand(time(NULL));

	alpha = ((double) rand() / (double) RAND_MAX) * 100.0;

	beta = ((double) rand() / (double) RAND_MAX) * 100.0;

	a = malloc(lda * n * sizeof(double));
	x = malloc(n * incx * sizeof(double));
	y = malloc(n * incy * sizeof(double));
	oldy = malloc(n * incy * sizeof(double));

	bA = malloc(n * sizeof(double *));
	for (i = 0; i < n; i += 1)
	{
		bA[i] = malloc(n * sizeof(double));
	}

	generate_matrix(bA, n);
	init_mat(bA, a, n);
	generate_vector(x, n * incx);
	generate_vector(y, n * incy);

	ret = check_symmetric(a, n);
	
	if (ret == 0)
	{
        printf("ERROR! Not a symmetric matrix!\n");
        return 1;
	}

	for (i = 0; i < n * incy; i += 1)
	{
		oldy[i] = y[i];
	}

	gettimeofday(&tvstart, NULL);
	dsymv1(121, n, alpha, a, lda, x, incx, beta, y, incy);
	gettimeofday(&tvstop, NULL);

	diff1 = (tvstop.tv_sec - tvstart.tv_sec) + (tvstop.tv_usec - tvstart.tv_usec)/10e6;

	gettimeofday(&tvstart, NULL);
	//cblas_dsymv(101, 121, n, alpha, a, lda, x, incx, beta, oldy, incy);
	gettimeofday(&tvstop, NULL);


	diff2 = (tvstop.tv_sec - tvstart.tv_sec) + (tvstop.tv_usec - tvstart.tv_usec)/10e6;
	printf("%s\t%ld\t%lf\t%lf\n", argv[2], n, diff1, diff2);
	
	ret = check(y, n, oldy, n);

	if (ret == 0)
	{
        printf("ERROR! The returned array don't match.\n");
        return 1;
	}
	

	free(x);
	free(y);
	free(oldy);
	free(a);

	for (i = 0; i < n; i += 1)
	{
		free(bA[i]);
	}

	free(bA);

	return 0;
}
