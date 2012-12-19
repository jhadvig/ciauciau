
UTILS_SRC_DIR="/root/katello-utils"

git clone git@github.com:tstrachota/katello-utils.git "$UTILS_SRC_DIR"
cat >> ~/.bashrc <<'EOF'
source ~/katello-utils/api/api.sh
source ~/katello-utils/api/completion.sh
EOF

