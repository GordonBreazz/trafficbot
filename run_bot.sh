#!/bin/bash
# run traffic bot in loop
# docker run -d -p 8118:8118 -p 2090:2090 -e tors=25 -e privoxy=1 zeta0/alpine-tor
# chmod +x ./run_bot.sh
printf "\n\n"
echo "+---========================================---+"
echo "|                 Traffic bot                  |"
echo "+----------------------------------------------+"
echo "| Start proxy deamon                           |"
echo "+----------------------------------------------+"
echo "{"
docker start tor_proxy || docker run -d --name tor_proxy -p 8118:8118 -p 2090:2090 -e tors=25 -e privoxy=1 zeta0/alpine-tor
echo "}"
echo "+----------------------------------------------+"
echo "| Test  proxy deamon                           |"
echo "+----------------------------------------------+"
sleep 15s
echo "{"
curl --proxy localhost:8118 http://httpbin.org/ip
echo "}"
echo "+----------------------------------------------+"
echo "| Start job in loop                            |"
run_count=0
for ((;;))
do
run_count=$(( $run_count + 1 ));
now=$(date +"%T");
echo "+----------------------------------------------+"
echo "| Iteration #$run_count running at $now             |"
echo "+----------------------------------------------+"
echo "{"
#result=$(xvfb-run --auto-servernum --server-num=1 --server-args="-screen 0 1024x768x24" node --harmony /root/traffic/trafficbot/index.js ->
timeout 5m  xvfb-run --auto-servernum --server-num=1 --server-args="-screen 0 1024x768x24" node --harmony /root/traffic/trafficbot/index.js>
echo "}"
#echo "$result"
start_date=$(date -u -d "$now" +"%s")
now=$(date +"%T")
final_date=$(date -u -d "$now" +"%s");
dif=$(date -u -d "0 $final_date sec - $start_date sec" +"%H:%M:%S");
echo "+----------------------------------------------+"
echo "| Iteration #$run_count done at $now.               |"
echo "| The task was performed in $dif           |"
echo "| Wait 15 second. Press CTRL+C for stop        |"
sleep 15s
pkill -f node
done
echo "+----------------------------------------------+"
echo "| Script execution over                        |"
echo "+----------------------------------------------+"
