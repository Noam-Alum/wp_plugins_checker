#!/bin/bash
domainname="$1"

if [ -z "$(echo $domainname)" ]; then
        echo -e "\033[1;92mCorrect usage:\033[0m"" curl -Ls 'alum.sh/NF'|bash -s https://yourdomain.com"
else
if [ -z "$(find . -type d -name wp-content)" ]; then
        echo -e "ERROR: ""\033[1;31mWordpress installation was not detected.\033[0m"
else
        if [ -z "$(echo "$domainname" | sed s#'/'#' '#g | grep -v 'http')" ]; then
                echo -e "
    _   _____    __ __ _   ________ __
   / | / /   |  / //_// | / /  _/ //_/
  /  |/ / /| | / ,<  /  |/ // // ,<
 / /|  / ___ |/ /| |/ /|  // // /| |
/_/ |_/_/__|_/_/_|_/_/_|_/___/_/_|_|______  _   __
   / ____/ / / / | / / ____/_  __/  _/ __ \/ | / /
  / /_  / / / /  |/ / /     / /  / // / / /  |/ /
 / __/ / /_/ / /|  / /___  / / _/ // /_/ / /|  /
/_/    \____/_/ |_/\____/ /_/ /___/\____/_/ |_/

"
                FILE=( $(find wp-content/plugins -type d -maxdepth 1 2> /dev/null | tail -n +2) )
                NUM=${#FILE[@]}

                echo "Problematic plugins:"
                echo ""
                function NAKNIK() {
                    for ((i=0; i<$NUM; i++)); do
                        chmod 0 "${FILE[i]}"
                    done
                    RESULT=$(
                        for ((i=0; i<$NUM; i++)); do
                        chmod 755 "${FILE[i]}"
                        RES=$(curl -sI "$domainname" | head -n 1 | awk {'print $2'})
                        if [ "$RES" = "500" ]; then
                                 chmod 0 "${FILE[i]}"
                                 paste <(echo "$i. ""$RES" "${FILE[i]}" | sed s#'/'#' '#g | awk {'print $1, $2, $NF'} | grep -v '200') <(echo -e "\033[1;31mWAS SHUT DOWN\033[0m")

                        elif [ -z "$RES" ]; then
                                echo -e "• ERROR: ""\033[1;31mCouldn't resolve host \"$domainname\"\033[0m"
                                echo ""
                                for ((i=0; i<$NUM; i++)); do
                                        chmod 755 "${FILE[i]}"
                                done
                                return

                        elif [ "$RES" = "404" ]; then
                                echo -e "• ERROR: ""\033[1;31m404\033[0m"
                                echo "• Server could not find the requested resource on \"$domainname\"."
                                for ((i=0; i<$NUM; i++)); do
                                        chmod 755 "${FILE[i]}"
                                done
                                return

                        elif [ "$RES" = "301" ]; then
                                echo -e "• ERROR: ""\033[1;31m301\033[0m"
                                echo "• Requested resource has been permanently moved to a new location on \"$domainname\"."
                                chmod 755 "${FILE[i]}"
                                return

                        elif [ "$RES" = "302" ]; then
                                echo -e "• ERROR: ""\033[1;31m302\033[0m"
                                echo "• Requested resource has been temporarily moved to a new location on \"$domainname\"."
                                for ((i=0; i<$NUM; i++)); do
                                        chmod 755 "${FILE[i]}"
                                done
                                return

                        elif [ "$RES" = "403" ]; then
                                echo -e "• ERROR: ""\033[1;31m403\033[0m"
                                echo "• Access to the requested resource has been denied by the server on \"$domainname\"."
                                for ((i=0; i<$NUM; i++)); do
                                        chmod 755 "${FILE[i]}"
                                done
                                return

                         elif [ "$RES" = "401" ]; then
                                echo -e "• ERROR: ""\033[1;31m401\033[0m"
                                echo "• do not have valid authentication credentials for the target resource on \"$domainname\"."
                                chmod 755 "${FILE[i]}"
                                return

                         elif [ "$RES" = "408" ]; then
                                echo -e "• ERROR: ""\033[1;31m408\033[0m"
                                echo "• the server timed out while waiting for the request on \"$domainname\"."
                                for ((i=0; i<$NUM; i++)); do
                                        chmod 755 "${FILE[i]}"
                                done
                                return

                         elif [ "$RES" = "501" ]; then
                                echo -e "• ERROR: ""\033[1;31m501\033[0m"
                                echo "• server does not support the functionality required to fulfill the request on \"$domainname\"."
                                for ((i=0; i<$NUM; i++)); do
                                        chmod 755 "${FILE[i]}"
                                done
                                return

                         elif [ "$RES" = "502" ]; then
                                echo -e "• ERROR: ""\033[1;31m502\033[0m"
                                echo "• the server received an invalid response from a server upstream on \"$domainname\"."
                                for ((i=0; i<$NUM; i++)); do
                                        chmod 755 "${FILE[i]}"
                                done
                                return

                         elif [ "$RES" = "503" ]; then
                                echo -e "• ERROR: ""\033[1;31m503\033[0m"
                                echo "• the server is currently unavailable or overloaded and cannot handle the request on \"$domainname\"."
                                for ((i=0; i<$NUM; i++)); do
                                        chmod 755 "${FILE[i]}"
                                done
                                return

                         elif [ "$RES" = "504" ]; then
                                echo -e "• ERROR: ""\033[1;31m504\033[0m"
                                echo "• the server did not receive a timely response from an upstream server on \"$domainname\"."
                                for ((i=0; i<$NUM; i++)); do
                                        chmod 755 "${FILE[i]}"
                                done
                                return
                         elif [ "$RES" != "200" ]; then
                                echo -e "• ERROR: ""\033[1;31m"$RES"\033[0m"
                                echo "• Error occurred while browsing $domainname"
                                for ((i=0; i<$NUM; i++)); do
                                        chmod 755 "${FILE[i]}"
                                done
                                return
                        fi
                        done
                    )
                    echo "$RESULT"
                    echo ""
                }
                NAKNIK
                RES=$(curl -sI "$domainname" | head -n 1 | awk {'print $2'})
                if [ "$RES" = "200" ]; then
                        echo "Result:"
                        echo ""
                        echo -e "• STATUS CODE: ""\033[1;92m200\033[0m"
                        echo "• Request has succeeded, it seems that the website "$domainname" is functioning properly."

                        echo ""
                fi
        else
                echo -e "\033[1;92mCorrect usage:\033[0m"" curl -Ls 'alum.sh/NF'|bash -s https://yourdomain.com"
        fi
fi
fi
