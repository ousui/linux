#!/bin/sh

# is user root?
who=`whoami`
if [ "$who" != "root" ] ; then
  echo "[!] Please run $0 as root!"
  exit 1
fi

echo
_base=/home/owangshuaig/docker-tomcat

service=
dir=
while getopts ":d:s:" arg; do 
  case $arg in 
    d)
      dir=${OPTARG%/*}
      ;;
    s)
      service=$OPTARG
      ;;
    ?)
      printf "Usage %s: [−d dir(action dir)] [-s service(docker service name)] args\n" $0
      exit 2
      ;;
  esac
done

if [ -z "$dir" ] ; then
  echo "[!] Please use -d option to specified the action dir!"
  exit 1
fi

if [ -z "$service" ]; then
  service=tomcat-$dir
  echo [!] No specified service param, use default service name: $service
fi

test=`docker exec $service echo 1`
if [ "$test" != "1" ]; then
  echo [!] Docker container $service not found or no start!
  exit 2
fi


echo ------------------------------------- Begin: `date +"%F %H:%M:%S"`

function docker_stop() {
  echo [$service] Stop docker service......
  docker stop $service
  echo [$service] Stop docker success!
}

function docker_start() {
  echo [$service] Start docker service......
  docker start $service
  echo [$service] Start docker success!
}

function war_depoly() {
  war=$1
  echo [$service] Depoly $war file to webapps/...... 
  rm -fv  ./webapps/$war
  rm -rfv ./webapps/${war%%.*}
  mv -v $war ./webapps/
  echo [$service] Depoly $war file success!
}

echo [$service] Start check war update......
cd $_base/$dir

needup=`find -maxdepth 1 -name "*.war"`
if [ -z "$needup" ]; then
  echo [$service] No war found to update!
  exit 1
fi

docker_stop
for w in $needup; do
 war_depoly ${w#*/}
done
docker_start


echo ------------------------------------- End: `date +"%F %H:%M:%S"`
