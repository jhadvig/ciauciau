
if [ "$RPM_PROXY" == "" ]; then
    echo "No rpm proxy set, skipping.";
    echo "Use envrironment variable RPM_PROXY to setaddres of a proxy";
else
    echo "Setting rpm proxy to http://$RPM_PROXY"
    sed -i /etc/yum.conf -e 's/^\(\w*proxy=.*\)$/#\1/g' && echo -e "\n# CUSTOM RPM PROXY\nproxy=http://$RPM_PROXY" >> /etc/yum.conf
fi

