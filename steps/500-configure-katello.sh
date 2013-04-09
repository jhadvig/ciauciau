echo "katello" > /root/my-oauth-token-file
katello-configure --user-pass=admin --no-bars --debug --oauth-token-file=/root/my-oauth-token-file
