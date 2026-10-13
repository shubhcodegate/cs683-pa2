

# Build with docker + gcc7

## Build Champsim binary using gcc7 inside a docker container

Run below commands to get the binary in `./bin` folder then run the binary in the a different terminal.
```bash
docker run --rm -it   \
    -v "$PWD:/workspace"   \
    -w /workspace   \
    ubuntu:20.04 \
    /bin/bash
```
Now in docker running run these commands to install gcc7:
```bash
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential gcc-7 g++-7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 100
update-alternatives --config gcc
update-alternatives --config g++
gcc --version
g++ --version
```
Now below steps to build the champsim binary:
```bash
./build_champsim.sh no lru baseline
```
Now to run a test simulation to see build was successful, binary is running successfully do the following commands:
```bash
./bin/hashed_perceptron-no-no-no-no-no-no-no-lru-lru-lru-lru-lru-lru-lru-lru-1core-baseline\
    -warmup_instructions 1   \
    -simulation_instructions 1   \
    -traces ./traces/Trace1.gz
```
You will see something like below in the end of the output:
```
CPU 0 Branch Prediction Accuracy: 0% MPKI: 200 Average ROB Occupancy at Mispredict: 9
Branch types
NOT_BRANCH: 2 200%
BRANCH_DIRECT_JUMP: 0 0%
BRANCH_INDIRECT: 0 0%
BRANCH_CONDITIONAL: 1 100%
BRANCH_DIRECT_CALL: 0 0%
BRANCH_INDIRECT_CALL: 0 0%
BRANCH_RETURN: 0 0%
BRANCH_OTHER: 0 0%

DRAM PAGES: 1048576
Allocated PAGES: 6
root@b2d974a96db8:/workspace#               <- docker root shell prompt
```

## Run the Champsim binary

Now that we have the Champsim binary (in previous step). We will run the simulation outside docker because its faster to do so.
Now you have the build binary ready in `./bin`folder.
Now we need to run the binary outside the docker
To run the simulation with the desired number of instructions do below command, in different terminal do:
```bash
./bin/hashed_perceptron-no-no-no-no-no-no-no-lru-lru-lru-lru-lru-lru-lru-lru-1core-baseline   \
    -warmup_instructions 25000000   \
    -simulation_instructions 25000000   \
    -traces ./traces/Trace1.gz
```
