#!/bin/sh

SCRIPT_DIR=$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

export KATELLO_CONFIG_FILE
source "$KATELLO_CONFIG_FILE"

# Start daemon for asynchronous processing
kat-start-jobs() {
  cd $KAT_SRC_HOME
  rake jobs:work
}

# Print version of all subsystems
kat-versions() {
  rpm -qa | egrep -e ^candlepin-[0-9] -e ^pulp-[0-9] -e ^subscription-manager-[0-9] -e ^python-rhsm-[0-9] -e ^foreman-[0-9]
}


# Print what branches need to be tagger
kat-needed-tags() {
  cd $KAT_HOME/rel-eng/
  if [ "$1" == "-v" ]; then
    echo "------------------------------------------"
    ./git-untagged-commits.pl
  else
    ./git-untagged-commits.pl | grep "..HEAD" | sed -e "s/..HEAD://" -e "s/^/ * /"
  fi
  cd - > /dev/null
}

# Run katello cli tests
kat-test-system() {
  $KAT_HOME/scripts/system-test/cli-system-test $*
}

# Run katello cli unit tests
kat-test-cli() {
  cd $KAT_CLI_HOME/test/
  nosetests $*
  cd - > /dev/null
}

# Run katello spec tests
kat-test-spec() {
  cd $KAT_SRC_HOME
  if [ $# -gt 0 ]; then
    ruby -S rspec $@
  else
    find ./spec/ -name *_spec.rb | xargs ruby -S rspec
  fi
  cd - > /dev/null
}

#set client config file
kat-client-cfg() {
  cfg_file="$HOME/.katello/client.conf.$1"
  if [ -f $cfg_file ]; then
    cp $cfg_file "$HOME/.katello/client.conf"
  else
     echo "File $cfg_file not found!"
  fi
}

# E201 whitespace after '{'
# E202 whitespace before ')'
# E203 whitespace before ','
# E221 multiple spaces before operator
# E222 multiple spaces after operator
# E225 missing whitespace around operator
# E231 missing whitespace after ','
# E251 no spaces around keyword / parameter equals
# E261 at least two spaces before inline comment
# E302 expected 2 blank lines, found 1
# E303 too many blank lines (2)
# E401 multiple imports on one line
# E501 line too long (82 characters)
# E701 multiple statements on one line (colon)
# W601 .has_key() is deprecated, use 'in'
kat-test-pep8() {
  pep8 $KAT_CLI_HOME --statistics --ignore W293,E501,E201,E202,E203,E221,E222,E225,E231,E251,E302,E303,E501 $* -r | sed "s\\$KAT_CLI_HOME\\./\\g"
}

# check for cli python errors
# for list of messages run: pylint --list-msgs
kat-test-pylint() {
  pylint --rcfile=/etc/spacewalk-pylint.rc --additional-builtins=_ --output-format=colorized $KAT_CLI_HOME/src/katello/
}

# Fill katello with basic test data
alias kat-fill=$SCRIPT_DIR/fill_katello.sh


# completion for kat-test-system
_kat-test-system() {
    local opts cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=`ls $KAT_HOME/scripts/system-test/cli_tests/ | sed 's/.sh$//' | egrep -v '^_.*'`
    opts="all $opts"

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    return 0
}

# completion for kat-test-cli
_kat-test-cli() {
    local opts cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=`ls $KAT_CLI_HOME/test/ | grep -v 'cli_test_utils.py' | grep -v 'test_data.py' | egrep -v ".*\.pyc"`

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    return 0
}

kat-start() {
    if [ "$1" == "prod" ]; then
        environment="production"
    else
        environment="development"
    fi

    cd $KAT_SRC_HOME
    export RAILS_RELATIVE_URL_ROOT=/$KAT_PREFIX
    if [ "$KAT_PORT" != "" ]; then 
        rails s thin -p $KAT_PORT -e $environment
    else    
        rails s thin -e $environment
    fi
}

fm-start() {
    if [ "$1" == "prod" ]; then
        environment="production"
    else
        environment="development"
    fi

    cd $FOREMAN_SRC_HOME
    export RAILS_RELATIVE_URL_ROOT=/$FOREMAN_PREFIX
    if [ "$FOREMAN_PORT" != "" ]; then 
        bundle exec rails s -p $FOREMAN_PORT -e $environment
    else    
        bundle exec rails s -e $environment
    fi
}

kat-bundler-ext-on() {
    if [ -f $KAT_SRC_HOME/Gemfile ]; then
        mv $KAT_SRC_HOME/Gemfile $KAT_SRC_HOME/Gemfile.in
    fi
}

kat-bundler-ext-off() {
    if [ -f $KAT_SRC_HOME/Gemfile.in ]; then
        mv $KAT_SRC_HOME/Gemfile.in $KAT_SRC_HOME/Gemfile
    fi
}


# Alias to katello shell
alias kat="$KAT_CLI_HOME/bin/katello -u $KAT_USER -p $KAT_PASSWORD"
alias katello="$KAT_CLI_HOME/bin/katello"

# Path to modules needed for katello cli
export PYTHONPATH="$KAT_CLI_HOME/src"

# Katello CLI tab completion in bash
_katello() {
  COMPREPLY=($($KAT_HOME/cli/bin/_complete_katello "${COMP_WORDS[*]}" | sed 's/^[^a-z\-]*\w//'))
  return 0
}

complete -F _katello kat
complete -F _katello katello

# Katello utils completion
complete -F _kat-test-system kat-test-system
complete -F _kat-test-cli    kat-test-cli
complete -F _kat-fill        kat-fill








