
KATELLO_SRC_DIR="/root/katello/"

git clone git@github.com:tstrachota/katello.git "$KATELLO_SRC_DIR"
pushd "$KATELLO_SRC_DIR"
git remote add upstream git@github.com:Katello/katello.git
git fetch upstream
git checkout master
git merge upstream/master
git submodule init
git submodule update
popd
