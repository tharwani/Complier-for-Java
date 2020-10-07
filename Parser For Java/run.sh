cd src
$a;
if [ "$1" = "-h" ];
then
    python3 main.py $1    
else
    python3 main.py ../tests/$1 $2 $3 $4
    mv *.dot ../out/DOT
    mv *.png ../out/PNG
fi
cd ..