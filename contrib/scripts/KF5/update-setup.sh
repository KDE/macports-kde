# Checkout mp-osx-ci
if [ ! -d mp-osx-ci ]; then
        mkdir -p mp-osx-ci
fi
pushd mp-osx-ci
(
    if [ ! -d .git ]; then
        git clone git://anongit.kde.org/clones/websites/build-kde-org/kaning/mp-osx-ci.git .
    fi
    git fetch origin
    git checkout mp-osx-ci
)
popd
