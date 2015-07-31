echo make_all
echo are you sure to go on!!!!!
pause
echo sure???
pause
cd ..\ebin
del *.beam

cd ..

erl -make

pause

