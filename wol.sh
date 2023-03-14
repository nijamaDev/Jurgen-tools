#!/usr/bin/bash

# Mac address variables

A0="98:90:96:ae:d6:5a" a0=$A0

A1="18:a9:05:b6:d2:dd" a1=$A1
A2="98:90:96:ae:d7:0b" a2=$A2
A3="98:90:96:ae:b2:4d" a3=$A3
A4="98:90:96:ae:c2:67" a4=$A4
A5="98:90:96:ae:d7:88" a5=$A5
A6="98:90:96:ae:c2:4c" a6=$A6
A7="98:90:96:ae:c2:d3" a7=$A7
A8="98:90:96:ae:b9:1a" a8=$A8

B1="b8:ac:6f:40:29:13" b1=$B1
B2="98:90:96:ae:9f:2c" b2=$B2
B3="98:90:96:ae:b6:bf" b3=$B3
B4="98:90:96:ae:b6:b1" b4=$B4
B5="98:90:96:ae:c3:c5" b5=$B5
B6="98:90:96:ae:aa:0a" b6=$B6
B7="98:90:96:ae:d2:03" b7=$B7
B8="b8:ac:6f:3f:ff:66" b8=$B8

C1="b8:ac:6f:3c:76:74" c1=$C1
C2="98:90:96:ae:d4:04" c2=$C2
C3="98:90:96:ae:d9:61" c3=$C3
C4="98:90:96:ae:d7:b7" c4=$C4
C5="98:90:96:ae:c3:38" c5=$C5
C6="98:90:96:ae:bc:83" c6=$C6
C7="98:90:96:ae:d6:37" c7=$C7
C8="b8:ac:6f:3c:47:11" c8=$C8

D1="b8:ac:6f:3c:c6:81" d1=$D1
D2="98:90:96:ae:d8:11" d2=$D2
D3="98:90:96:ae:c7:3d" d3=$D3
D4="98:90:96:ae:c2:94" d4=$D4
D5="98:90:96:ae:d3:36" d5=$D5
D6="98:90:96:ae:d2:fb" d6=$D6
D7="98:90:96:ae:b1:36" d7=$D7
D8="00:1f:29:02:eb:bd" d8=$D8

E1="00:68:eb:c6:95:88" e1=$E1
E2="00:68:eb:c6:94:92" e2=$E2
E3="98:90:96:ae:d6:74" e3=$E3
E4="" e4=$E4
E5="98:90:96:ae:d8:d2" e5=$E5
E6="98:90:96:ae:d3:24" e6=$E6
E7="98:90:96:ae:d6:98" e7=$E7
E8="18:a9:05:b6:d2:aa" e8=$E8

crow0="10:60:4b:af:da:08"
crow1="10:60:4b:af:ab:7c" crow=$crow1
crow2="10:60:4b:af:"
crow3="10:60:4b:af:cb:ac"
# Create groups of MACs

i9=("E1" "E2")
xeon=("A0" "A4" "A5" "B4" "B5" "C4" "C5" "D4" "D5" "E5" "A3" "A6" "B3" "B6" "C3" "C6" "D3" "D6" "E3" "E6" "A2" "A7" "B2" "B7" "C2" "C7" "D2" "D7" "E7" "A8" )
old=("A1" "B1" "B8" "C1" "C8" "D1" "D8" "E8")
cluster=("crow0" "crow1" "crow2" "crow3")
# Display help if there aren't arguments
if [ $# -le 0 ]; then

	printf "
	Wake-On-LAN
This utility sends a magic packet to wake up a machine properly configured to listen to Wake-On-LAN/WLAN requests.
	Usage:  wol.sh [PC-NAME] ... [PC-GROUP]
	
	PC-NAME:	Example: 
					wol.sh E5
					wol.sh B2 B3
					wol.sh B6 A2 C5 E7
	
	PC-GROUP:	Example: 
					wol.sh all
					wol.sh xeon
					wol.sh i9
					wol.sh old
"
exit
fi

# function for sending the wol command for groups (arrays of MACs)
on(){
	printf "\n"
	arr=("$@")
	for k in ${arr[@]};
	do
		printf "$k: "
		wol ${!k}
		sleep 1
	done
	printf "\n"
}

for i in "$@";
do
	case $i in
		[Ii]9)
			printf "  [i9]"
			on ${i9[@]}
		;;
		[Xx]eon)
			printf "  [xeon]"
			on ${xeon[@]}
		;;
		[Oo]ld)
			printf "  [old]"
			on ${old[@]}
		;;
		[Aa]ll)
			printf "[all]\n  [i9]"
			on ${i9[@]}
			printf "  [xeon]"
			on ${xeon[@]}
			printf "  [old]"
			on ${old[@]}
		;;
                [Cc]luster)
                       	printf "  [cluster]"
                        on ${cluster[@]}
                ;;
		crow|crow[0-3])
			printf "$i: "
			wol ${!i}
		;;
		[A-E][1-8]|[a-e][1-8]|[Aa]0)
                        printf "$i: "
                        wol ${!i}
                ;;

		*)
			echo "argument error"
		;;
	esac
	sleep 0.4
done

