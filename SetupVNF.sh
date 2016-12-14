
VNF=$1

case "$VNF" in
    "0") #Firewall
        FUNCTION="Click/firewall.click"
        ;;
    "1") #DPI
        FUNCTION="Click/DPI.click"
        ;;
    "2") #NAT
        FUNCTION="Click/NAT.click"
        ;;
esac
./runClickFunction.sh $FUNCTION
