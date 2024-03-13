if [ "$1" == "" ]; then
    echo "Give version, like 0.1.5"
    exit 1
fi
helm package -d charts/docs --version $1 charts/vxfuel
helm repo index charts
git add charts/docs/vxfuel-${1}.tgz

