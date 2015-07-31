compile libraknet.a:
1. g++ -c *.cpp
   ar rc libraknet.a *.o
   g++ -shared -O3 -fPIC -o libraknet.so.0.0.0 *.cpp
2. cp libraknet.so.0.0.0 libraknet.a /usr/local/lib/
3. ln -s /usr/local/lib/libraknet.so.0.0.0 /usr/local/lib/libraknet.so.0
   ln -s /usr/local/lib/libraknet.so.0.0.0 /usr/local/lib/libraknet.so
4. mkdir /usr/local/include/raknet
   cp *.h  /usr/local/include/raknet
   ldconfig
5. g++ testraknet.cpp -o raknet /usr/local/lib/libraknet.so -lpthread

