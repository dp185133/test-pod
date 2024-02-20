#!/bin/bash

BASEPATH="/home/pcrfuel/Radiant/FastPoint"
LOGPATH="${BASEPATH}/Log"
LOGROTATEPATH="${LOGPATH}/crossover"
DATAPATH="${BASEPATH}/Data"
CERTPATH="${DATAPATH}/Cert"
AUDITPATH="${BASEPATH}/Audit"
ARCHIVEPATH="${AUDITPATH}/Archive"

NODE_LINKING_SERVER_ENABLED_FILE="${DATAPATH}/node_linking_server.enabled"

SITE_TRUST_DIR="/opt/sitetrust/home/.local/share/Ncr/SiteTrust"
NODE_LINKING_SERVER_DIR="${SITE_TRUST_DIR}/NodeLinkingServer"
NODE_LINKING_SERVER_CERT_FILE="${NODE_LINKING_SERVER_DIR}/NcrSiteRootCert.pfx"
SECURITY_SERVICE_DIR="${SITE_TRUST_DIR}/SecurityService"
SECURITY_SERVICE_CERT_FILE="${SECURITY_SERVICE_DIR}/NcrSiteNodeCert.pfx"

echo "dmp230219a STARTING SITETRUST SCRIPT"

verifypaths() {
    for DIR in $LOGPATH $LOGROTATEPATH $DATAPATH $AUDITPATH $ARCHIVEPATH; do 
        if [ -d ${DIR} ]; then
            chmod 774 ${DIR}
        else
            mkdir -m774 -p ${DIR}
        fi
        chown pcrfuel:pcrfuel ${DIR}
    done

    if [ -d ${CERTPATH} ]; then
        chmod 770 ${CERTPATH}
    else
        mkdir -m770 -p ${CERTPATH}
    fi
    chown pcrfuel:pcrfuel ${CERTPATH}
}

LOGFILE="${LOGPATH}/sitetrust.service.log"
LOGFILE_NLS="${LOGPATH}/nls.service.log"

verifyfiles() {
    touch ${LOGFILE}
    chown sitetrust:pcrfuel ${LOGFILE}
    chmod 664 ${LOGFILE}
}

verifypaths
verifyfiles

wait_for_node_linking_server() {
    response_code=$(curl -i -s -k -w "%{http_code}" -o /dev/null https://localhost:451/Time/currentDateTime)

    while [ ! "$response_code" = "200" ]; do
        echo "Waiting for Node Linking Server to complete startup."
        sleep 1
        response_code=$(curl -i -s -k -w "%{http_code}" -o /dev/null https://localhost:451/Time/currentDateTime)
    done

    echo "Node Linking Server has started up."
}

######################################
# Check flag file to disable sitetrust
######################################
if [ -e /home/pcrfuel/Radiant/FastPoint/Data/sitetrust.disabled ]; then
    echo `date` "SiteTrust disabled."
    exit 3
fi

# Fuel Connect environments need to potentially run Node Linking Server for local-linking.
cp /home/pcrfuel/.wine/system.reg /var/log/saved-system.reg
ls -la /home/pcrfuel/.wine/ >> /var/log/stcheck-whats-in-wine-dir.txt
fuel_product=`grep -i \"FuelProduct\" /home/pcrfuel/.wine/system.reg | awk -F= '{print \$2}' | sed 's/"//g' | sed 's/\r//g'`
echo $fuel_product >> /var/log/stcheck-fuel-product.txt
grep -i FuelProduct /home/pcrfuel/.wine/system.reg >> /var/log/stcheck-fuelproduct-grep.txt
fuel_product="Fuel Connect" # cannot figure out why this is not working
if [ "$fuel_product" == "Fuel Connect" ]; then
    run_nls=false

    # If either the Node Linking Server certificate or Security Service certificate is
    # missing, automatically perform local-linking.    
    if [ ! -e "${NODE_LINKING_SERVER_CERT_FILE}" ]; then
        echo `date` "Node Linking Server certificate is missing. Performing local-linking."
        run_nls=true
    fi

    if [ ! -e "${SECURITY_SERVICE_CERT_FILE}" ]; then
        echo `date` "Security Service certificate is missing. Performing local-linking."
        run_nls=true
    fi

    # If the file node_linking_server.enabled exists, 
    if [ -e "${NODE_LINKING_SERVER_ENABLED_FILE}" ]; then
        echo `date` "Node Linking Server is explicitly enabled. Performing local-linking."
        run_nls=true
    fi

    if [ $run_nls == true ]; then
        if [ -d "${NODE_LINKING_SERVER_DIR}" ]; then
            echo `date` "Removing old root certificate."
            rm ${NODE_LINKING_SERVER_DIR}/*
        fi

        if [ -d "${SECURITY_SERVICE_DIR}" ]; then
            echo `date` "Removing old client node certificate."
            rm ${SECURITY_SERVICE_DIR}/*
        fi

        export AutoApproveLinking=true
        setcap cap_net_bind_service+ep /home/sitetrust/NodeLinkingServer/Ncr.SiteTrust.NodeLinkingServer
        node_linking_server_command="env AutoApproveLinking=true DOTNET_GCHeapHardLimit=0xC800000 /home/sitetrust/NodeLinkingServer/Ncr.SiteTrust.NodeLinkingServer --urls https://*:451"
        cd /home/sitetrust/NodeLinkingServer
        su -c "$node_linking_server_command >> $LOGFILE_NLS 2>&1" - sitetrust &
        
        wait_for_node_linking_server

        # If Node Linking Server was explicitly enabled, now disable it.
        if [ -e "${NODE_LINKING_SERVER_ENABLED_FILE}" ]; then
            rm ${NODE_LINKING_SERVER_ENABLED_FILE}
        fi
    else
        echo `date` "Node linking already performed, not necessary to run Node Linking Service"
    fi
else
    echo "Product not fuel connect, not starting Node Linking Server"
fi

if [ "$#" -eq 0 ]; then
    setcap cap_net_bind_service+ep /home/sitetrust/SecurityService/Ncr.SiteTrust.SecurityService
    cd /home/sitetrust/SecurityService
    DOTNET_GCHeapHardLimit=0xC800000 su -c "/home/sitetrust/SecurityService/Ncr.SiteTrust.SecurityService --urls https://*:452" sitetrust
    exit 0
else
    echo "Usage: $0"
    exit 3
fi
