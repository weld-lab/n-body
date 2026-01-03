export OMP_NUM_THREADS=8

FLAGS="-O3 \
       -ffast-math \
       -fstack-arrays
       -fopenmp \
       -Wall \
-L/opt/homebrew/opt/libomp/lib -I/opt/homebrew/opt/libomp/include"

echo "Compiling with flang..."
flang -c params.f90 $FLAGS
flang -c subrs.f90  $FLAGS
flang -c main.f90   $FLAGS

echo "Linking..."
flang params.o subrs.o main.o $FLAGS -o main

echo "Done"

if [ "$1" = "run" ]; then
    echo "Running ..."
    ./main
fi
