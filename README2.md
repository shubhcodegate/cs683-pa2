

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

# Build with Dockerfile (recommended)

In this way we will first create a docker image named `champsim-gcc7:1.0` and then run that docker image to create the build binary of champsim. Once we get that build binary and we will run that binar outside the container (for faster runtime).


Run below command to build Docker Image `champsim-gcc7:1.0`:
```bash
docker build -t champsim-gcc7:1.0 .
```
To verify:
```bash
docker images
```
You will see `champsim-gcc7:1.0` in the list.


Now to run the docker image:

```bash
docker run --rm -it   \
    -v "$PWD:/workspace"   \
    -w /workspace   \
    champsim-gcc7:1.0 \
    /bin/bash
```
Now you will be in you docker container with gcc7 now run inside the docker terminal:
```bash
./build_champsim.sh no lru baseline
./bin/hashed_perceptron-no-no-no-no-no-no-no-lru-lru-lru-lru-lru-lru-lru-lru-1core-baseline\
    -warmup_instructions 1   \
    -simulation_instructions 1   \
    -traces ./traces/Trace1.gz
```

Now you will see something like below at end of output on successful simulation:
```bash
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
root@0ed6a47f1e9e:/workspace# 
```


## Building using `mybuild.sh`
`mybuild.sh` runs the compile in the docker container and give the output binary.
To run do:
```bash
./mybuild.sh spp lru baseline
./bin/hashed_perceptron-no-spp-no-no-no-no-no-lru-lru-lru-lru-lru-lru-lru-lru-1core-baseline -warmup_instructions 25000000   \
    -simulation_instructions 25000000   \
    -traces ./traces/Trace1.gz
```

# Commands used to build and test
To generate and run final after Task 3:
```bash
./mybuild.sh spp dyn_irrip baseline
./bin/hashed_perceptron-no-spp-no-no-no-no-no-lru-lru-lru-dyn_irrip-lru-lru-lru-lru-1core-baseline \
-warmup_instructions 25000000      \
-simulation_instructions 25000000       \
-traces ./traces/Trace1.gz > ./results/task3-spp-dynirrip-trace1.txt
```