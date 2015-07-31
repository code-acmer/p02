TARGET=server_p02
mkdir -p $TARGET
cd $TARGET
mkdir -p ebin/
cp ../../ebin/* ebin/

for dir in `ls ../../deps/`; do    
    mkdir -p deps/$dir/ebin/
    cp ../../deps/$dir/ebin/* deps/$dir/ebin/
done

mkdir sh
cp -r ../../sh/node_config_example/ ./sh/
cd ../
tar zcvf $TARGET.tar.gz $TARGET/
