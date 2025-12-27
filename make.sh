export OMP_NUM_THREADS=8
FLAGS="-Ofast -march=native -funroll-loops -Wall -Wextra -Wpedantic -fcheck=all -fopenmp -Accelerate"

echo "Compiling..."
gfortran -c params.f90 $FLAGS
gfortran -c subrs.f90 $FLAGS
gfortran -c main.f90 $FLAGS

echo "Linking..."
gfortran params.o subrs.o main.o $FLAGS -o main

echo "Done"
if [ "$1" = "run" ]; then
    echo "Running ..."
    ./main
fi
