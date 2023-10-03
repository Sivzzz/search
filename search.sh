#!/bin/bash
rech="RECHERCHER un DOSSIER/FICHIER"
rechd="RECHERCHER un DOSSIER"
rechf="RECHERCHER un FICHIER"
servstat="GESTION des SERVICES"
afficher="AFFICHER une partition"
extend="ETENDRE une partition"
chvm="CHANGER de VM"
quit='QUITTER'

fvm (){
        echo -e "\n\n\n\n\n\n\n\n\n\n\n\n$(tput setaf 3)                                ----Sur quelle VM souhaites-tu te connecter ?----\n$(tput sgr0)"
        read vmM
}
fpaquet (){
        echo -e "\n\n$(tput setaf 6)                                ----install/remove nom du paquet----\n$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal, TAPE M$(tput sgr0)"
        read -p "install/remove nomdupaquet " pinstall ppaquet
        if [ $pinstall = "M" ];
        then fmenu
        else
        ssh -q $vmM "apt $pinstall $ppaquet"
        fpaquet
        fi
}
fpartition (){
        echo -e "\n\n$(tput setaf 6)===[1]===AFFICHER les partitions ?===\n===[2]===EXTEND une partition ?===\n===[3]Voir l'arborescence ?===\n===[4]===Voir le nombre de fichier dans un dossier ?===$(tput sgr0) \n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
read -n 1 vfpartition
        if [ $vfpartition = "M" ]; then
                fmenu
        elif [ $vfpartition = 1 ];then
                fafficher
        elif [ $vfpartition = 2 ];then
                fextend
        elif [ $vfpartition = 4 ];then
                echo -e "                                \n\n$(tput setaf 6)----Quel dossier souhaites-tu vérifie ? ----\n
                     Exemple, /var/www$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal, tape M$(tput sgr0)"
                read wcpart
                if [ $wcpart = "M" ];then
                        fmenu
                else ssh -q $vmM "cd $wcpart && ls -lah |wc -l"
                fpartition
                fi
        elif [ $vfpartition = 3 ];then
                echo -e "                               $(tput setaf 6)----Quel point de montage souhaites-tu vérifie---- \n
                       Exemple, /var/www\n\n$(tput sgr0)$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
        read pm
        if [ $pm = "M" ];then
                fmenu
        else
        ssh -q $vmM "du -hsx * $pm |sort -rh"
        fpartition
        fi
        fpartition
        fi
}

fafficher (){
        ssh -q $vmM "df -h"
        fpartition
}

fextend (){
        echo -e "\n\n$(tput setaf 6)                                ----Quelle partition souhaites-tu augmenter ?---- \n
                   Exemple, /var/www----\n\n$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
        read montage
        if [ $montage = "M" ];
        then fmenu
        else
                echo -e "\n\n$(tput setaf 6)                                ----De combien souhaites tu étendre la patition ? en Gb---- \n                                Exemple,  2 pour 2GB----\n\n$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
        fi
        read -n 1 extend
        if [ $extend = "M" ];
        then fmenu
        else
        ssh -q $vmM "sudo lvextend -L +$extend /dev/mapper/vg0/$extend && sudo xfs_growfs $montage && df -h $montage"
        fpartition
        fi
}

frechd (){
        echo -e "\n\n$(tput setaf 6)                                -----Quel DOSSIER souhaites-tu rechercher ?----$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
        read PARAM2
        if [ $PARAM2 = "M" ];
        then fmenu
        else
        echo -e "\n\n$(tput setaf 6)                                ----Dans quel arborescence souhaites-tu chercher ?------\n                                Exemple, dans /etc/----$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
        fi
        read PARAM3
        if [ $PARAM3 = "M" ];
        then fmenu
        else
        ssh -q $vmM "find $PARAM3 -type d -iname $PARAM2 |grep $PARAM2"
        frechd
        fi
}



frechf (){
        echo -e "\n\n$(tput setaf 6)                                ----Quel FICHIER souhaites-tu rechercher ?----$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)\n\n"
        read PARAM4
        if [ $PARAM4 = "M" ];
        then fmenu
        else
                echo -e "\n\n$(tput setaf 6)                                ----Dans quel arborescence souhaites-tu chercher ?----\n                                Exemple, dans /etc/----$(tput sgr0) \n\n$(tput setaf 5)Pour revenir au menu Principal tape, M\n\n$(tput sgr0)"
        read PARAM5
        fi
        if [ $PARAM5 = "M" ];
        then fmenu
        else
        ssh -q $vmM "find $PARAM5 -type d -iname $PARAM4 |grep $PARAM4"
        frechf
        fi
}


frech (){
        echo -e "\n\n$(tput setaf 6)===[1]===FICHIER===\n===[2]===DOSSIER====$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
read vfrech
if [ $vfrech = "M" ]; then
        fmenu
elif [ $vfrech = 1 ]; then
        frechf
elif [ $vfrech = 2 ]; then
        frechd
fi
        frech
}
ffservstat (){
        echo -e "\n\n$(tput setaf 6)                                \n\n----Quel action ?----\n\n\n===[1]===RESTART===\n===[2]===START===\n===[3]===STOP===\n===[4]===STATUS===\n$(tput setaf 2)===[5]===CHANGEMENT DE VM===\n$(tput sgr0)$(tput setaf 5)Pour revenir au menu PRECEDENT tape, P$(tput sgr0)"
        read PARAM7
        if [ $PARAM7 = "P" ]; then
                fservstat
        elif [ $PARAM7 = 1 ]; then
                ssh -q $vmM "systemctl restart $PARAM6"
        elif [ $PARAM7 = 2 ]; then
                ssh -q $vmM "systemctl start $PARAM6"
        elif [ $PARAM7 = 3 ]; then
                ssh -q $vmM "systemctl stop $PARAM6"
        elif [ $PARAM7 = 4 ]; then
                ssh -q $vmM "systemctl status $PARAM6"
        elif [ $PARAM7 = 5 ]; then
                fvm
                ffservstat
        fi
        ffservstat
}


fservstat (){
        echo -e "\n\n$(tput setaf 6)                                ----Quel SERVICE ?----$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal, tape M \n\n$(tput sgr0)"
        read PARAM6
        if [ $PARAM6 = "M" ];
        then
                fmenu
        else
                ffservstat
        fi
        ffservstat
}

fweb (){
        echo -e "$(tput setaf 6)===[1]===VERIFIER CERTIFICAT===\n\n===[2]===CREER VHOSTS===\n\n===[3]===CREER un certificat autosigné===\n\n===[4]===CREER UN CSR===\n\n$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
        read -n 1 vfweb
        if [ $vfweb = "M" ];
        then fmenu
        elif [ $vfweb = 1 ];
        then
                echo -e "                                $(tput setaf 6)----Quel est le PATH du CRT ?----$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal, tape M$(tput sgr0)"
                read vfweb1
                if [ $vfweb1 = "M" ];then
                        fmenu
                else
                        echo -e "                                $(tput setaf 6)----Quel est le PATH de la PKEY ?----$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
                        read vfweb2
                fi
                        if [ $vfweb2 = "M" ];
                        then fmenu
                        else
                                ssh -q $vmM "openssl x509 -noout -modulus -in $vfweb1 | openssl md5 && openssl rsa -noout -modulus -in $vfweb2 | openssl md5"
                        fweb
                        fi
        elif [ $vfweb = 3 ];
        then
                echo -e "                                \n\n$(tput setaf 6)----Chemin absolu ESPACE nom du fichier----\n
                    Exemple, /etc/apache2/ssl/2023/ monsite$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
                read vfweb3 vfweb4
                if [ $vfweb3 = "M" ]; then
                        fmenu
                else
                ssh -q $vmM "cd $vfweb3 && openssl req -new -newkey rsa:4096 -sha256 -days 365 -nodes -x509 -keyout $vfweb3$vfweb4.key -out $vfweb4.crt"
                fweb
                fi

        elif [ $vfweb = 4 ]; then
                echo -e "                                \n\n$(tput setaf 6)----Chemin absolu ESPACE nom du fichier----\n
                    Exemple, /etc/apache2/ssl/2023/ monsite$(tput sgr0)"
                read vfweb5 vfweb6
                        if [ $vfweb5 = "M" ];
                        then fmenu
                else
                ssh -q $vmM "openssl req -new -newkey rsa:4096 -nodes -out $vfweb6.rsa.csr -keyout vfweb6.rsa.pkey -subj '/C=Pays/ST=Département/L=Ville/O=Nom_Entreprise/C=$vfweb6"
                        fweb
                        fi
        elif [ $vfweb = 2 ];
        then
                echo -e "                                 $(tput setaf 6)\n\n----EN COURS DE DEV----$(tput sgr0)"
                fweb
        fi
}

fuser (){
        echo -e "$(tput setaf 6)\n\n===[1]===ADD/DEL UTILISATEUR===\n\n===[2]===ADD/DEL COMPTE SFTP===\n\n===[3]===DROITS UTILISATEUR/GROUPE===$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
        read vfuser
        if [ $vfuser = M ]; then
                fmenu
        elif [ $vfuser = 1 ]; then
                vfaddu
        elif [ $vfuser = 2 ]; then
                vfaddsftp
        elif [ $vfsert = 3 ]; then
                vfchm
        fuser
        fi
}

freseau ()
{
        echo -e "\n\n$(tput setaf 6)===[1]===VOIR LES CARTES===\n===[2]===PING IP===\n===[3]===MODIF IP===\n===[4]===VOIR ROUTE===\n===[5]===MODIF ROUTE===\n$(tput sgr0)\n\n$(tput setaf 5)Pour revenir au menu principal tape, M$(tput sgr0)"
       read vfreseau
if [ $vfreseau = "M" ]; then
        fmenu
elif [ $vfreseau = 1 ]; then
        ssh -q $vmM "ip -c a"
        freseau
elif [ $vfreseau = 2 ];then
        echo -e "\n\n$(tput setaf 6)                                ----Quelle IP ?----$(tput sgr0)"
        read vfreseau1
        if [ $vfreseau1 1 = "M" ]; then
                fmenu
                else
        ssh -q $vmM "ping $vfreseau1"
        freseau
        fi
elif [ $vfreseau = 3 ];then
        echo -e "\n\n                                ----Quelle IP ?(en CIDR)----$(tput sgr0)\n$(tput setaf 5)Pour revenir au menu principal tape, M"
        read vfreseau2
        if [ $vfreseau2 = "M"]; then
                fmenu
        else
                echo "en cours de dev"
                freseau
                fi
elif [ $vfreseau = 4 ]; then
        echo -e "en cours de dev"
        freseau
elif [ $vfreseau = 5 ]; then
        echo -e "en cours de dev"
        freseau
fi

}

fmenu ()
{
        echo -e "\n\n$(tput setaf 4)                      $(date +"Aujourd'hui c'est : %A, %d of %B,%T")$(tput sgr0)\n\n
                   $(tput setaf 1)Vous êtes sur la$(tput sgr0) $(tput setaf 3)$vmM$(tput sgr0)"
        echo -e "\n\n$(tput setaf 2)===[1]===$rech===\n\n===[2]===$servstat===\n\n===[3]===GESTION des PAQUETS===\n\n===[4]===GESTION des PARTITIONS===\n\n===[5]===GESTION HTTP/S===\n\n===[6]===GESTION USERS===\n\n===[7]===GESTION RESEAUX===\n\n$(tput setaf 3)===[8]===$chvm===$(tput sgr0)\n\n$(tput setaf 2)===[9]===$quit===\n\n\n\n$(tput sgr0)"
read -n 1 PARAM1
if [ $PARAM1 = 1 ]; then
        frech
elif [ $PARAM1 = 2 ]; then
        fservstat
elif [ $PARAM1 = 3 ]; then
        fpaquet
elif [ $PARAM1 = 4 ]; then
        fpartition
elif [ $PARAM1 = 5 ]; then
        fweb
elif [ $PARAM1 = 6 ]; then
        fuser
elif [ $PARAM1 = 7 ]; then
        freseau
elif [ $PARAM1 = 8 ]; then
        fvm
elif [ $PARAM1 = 9 ]; then
        echo "$(tput setaf 4)Bonne journée$(tput sgr0)"
        exit
fi
        fmenu
}

fvm
fmenu
