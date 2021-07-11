# alias start_sdk='sudo docker run -v /home/share:/data -v /dev:/dev -v 
# /lib/modules/:/lib/modules/ -v /run:/run --add-host='osc:127.0.0.1' -e UID=1001 
# --privileged -i --rm -t huawei-ec-iot/sdk:buster /bin/bash'

docker run -v ${PWD}/:/workdir -w /workdir --add-host='osc:127.0.0.1' -e UID=1001 --privileged -i --rm -t rust_env:u20.04 /bin/bash
