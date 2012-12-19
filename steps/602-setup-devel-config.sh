
SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp $SCRIPT_DIR/../scripts/katello-config.template.sh ~/katello-config.sh
cat >> ~/.bashrc <<'EOF'
KATELLO_CONFIG_FILE="~/katello-config.sh"
EOF

source ~/.bashrc

