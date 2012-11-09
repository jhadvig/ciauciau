cat >> /root/.bashrc <<'EOF'
KATELLO_CLI=$(type -P katello || type -P headpin)
alias paste="curl -F 'sprunge=<-' http://sprunge.us"
alias kconf='katello-configure -b'
alias kconf-reset='katello-configure -b --reset-data=YES'
alias rst='katello-service restart'
alias kk="$KATELLO_CLI -u admin -p admin"
alias k="$KATELLO_CLI -u admin -p admin"
alias pp="$KATELLO_CLI -u admin -p admin ping"
alias gk='cd /usr/share/katello'
alias gf='cd /usr/share/foreman'
alias gkl='cd /var/log/katello'
alias gfl='cd /var/log/foreman'
alias gpl='cd /var/log/pulp'
alias gklc='cd /var/log/katello/katello-configure'
alias kst='/usr/share/katello/script/cli-tests/cli-system-test'
alias tailprod='tail -f -n400 /var/log/katello/production.log'
alias tailtom='tail -f -n400 /var/log/tomcat6/catalina.out'
alias tailpulp='tail -f -n400 /var/log/pulp/pulp.log'
alias tailgrind='tail -f -n400 /var/log/pulp/grinder.log'
alias versions='rpm -q katello katello-cli katello-agent pulp candlepin subscription-manager python-rhsm yum'

source /etc/bash_completion.d/katello
complete -F _katello kk
complete -F _katello k
EOF

source /root/.bashrc

