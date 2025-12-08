FLAGS="-O3 -Wall -Wextra -Wpedantic -fcheck=all"

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
