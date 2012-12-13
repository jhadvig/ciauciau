vim +2 /etc/katello/katello.yml 2> /dev/null <<EOF
/test:
:r !grep '^  database:' -A 6 /etc/katello/katello.yml |sed -s 's/katelloschema/katellotest/'
:wq
EOF

su postgres -c 'createdb katellotest --owner katellouser' 2> /dev/null
