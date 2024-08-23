1. Build MAPL - Follow "https://github.com/GEOS-ESM/MAPL/wiki/Building-and-Testing-MAPL-as-a-standalone" but add "git checkout develop" before the "mkdir build" step.

You may want to build on a btch node.

In your install/bin directory, you will have the executable ExtDataDriver.x

2. Test runs to mimic GEOS GCM
   Two groups: Checkpoint followed by Restart
               History followed by Extdata

   Checkpoint: Writes data
   Restart   : Reads data written by Checkpoint

   History   : Writes data
   Extdata   : Reads data written by History

3. /discover/nobackup/aoloso/for_Lucas contains two directories corresponding to the two groups i.e. checkpoint_restart and history_extdata.

  Each directory contains sample setups for the tests.
  checkpoint_restart:
     AGCM1.rc, CAP1.rc, and HISTORY1.rc are for checkpointing
     AGCM2.rc, CAP2.rc, and HISTORY2.rc are for restart
     Please note HISTORY?.rc is empty and extdata is not referenced at all - focus is on checkpoint and restart
  history-extdata:
     Similar arrangement except HISTORY1.rc contains data for the hsitory part and extdata.yaml contains data for the ExtData part.

  How to run (don't forget to always source g5_modules):
     checkpoint:
       i. Comment out CAP2.rc in CAP.rc (insert # at the beginning of the line)
       ii. Total number of MPI processes (hence CPU cores) needed is the product of NX and NY in AGCM?.rc. The example provided requires 24 cores i.e. 2*12.
       iii. Simply do "mpirun -np <num_procs> <full_path_to_ExtDataDriver.x>
       iv. Successful run produces file root_import_checkpoint.
       v. Profiler provides time it takes to write data

     restart:
       i. Uncomment CAP2.rc and comment out CAP1.rc
       ii. Run the same was as before (i.e. as in step iii for checkpoint)
       iii. Profiler provides time it takes to read data

4. Benchmark the following resolutions:
       Root.LM: 91
       Root.IM_WORLD: 720

       Root.LM: 91
       Root.IM_WORLD: 1440

       Root.LM: 91
       Root.IM_WORLD: 2880

       Root.LM: 91
       Root.IM_WORLD: 5760

       Root.LM: 181
       Root.IM_WORLD: 2880

       Root.LM: 181
       Root.IM_WORLD: 5760

       Please note that as you increase resolution, you need to increase correspondingly the number of total CPU cores (hence nodes). Typically when you double the horizontal resolution, you may need to quadruple the number of nodes. Also note that the paramter NY must always be a multiple of 6 due to the fact that GEOS is on cubed-sphere grid.

       Also please note to change Root.GRIDNAME AGCM?.rc files to reflect the horizontal resolution i.e. PE<IM_WORLD>x<IM_WORLD*6>-CF. For example For IM_WORLD=720, it will be PE720x4320-CF.

5. Variant of checkpoint and restart to also benchmark:
       As resolution increases, for memory reasons, in real life, we split the data by cubed-sphere face such that instead of the ntire grid written to or read from a signle file, the data is split into six parts, each part corresponding to a face of the cubed-sphere.  To achieve this, there are three additional parameters added to the AGCM?.rc files. For checkpoint (AGCM1.rc), the parameters are:
      NUM_READERS: 6
      NUM_WRITERS: 6
      WRITE_RESTART_BY_FACE: YES

      For restart (AGCM2.rc), the parameters are
      NUM_READERS: 6
      NUM_WRITERS: 6
      READ_RESTART_BY_FACE: YES

      You can play with NUM_READERS and NUM_WRITERS to see their effects on timing.  They are bot set to 6 in the example. Of course you need to uncomment them to test this feature.

6. Follow the same process described for checkpoint-restart for history-extdata.
   The variant described in 5 for checkpoint-restart does not apply to history-extdata.
   However, history-extdata does have its own variant where we use what we call the o-server (that runs on a separate MPI communicator to asynchronously write data such that communication is overlapped with data dump). To benchmark this variant:
   i. Request excess nodes more than you need for the model
   ii. Supply arguments to ExtDataDriver.x.
   To demonstrate this for our example case, we know we need 24 cores to run the model. That fits in one Skylake node, for example. To exercise the o-server, we will then need at least two nodes, one for the model, one for the o-server. The run command will look like:

   mpirun -np 80  <full_path_to_ExtDataDriver.x> --npes_model 24 --nodes_ouput_server 1 --oserver_type multigroup --npes_backend_pernode 16

   In this example, we have a total of 80 cores (2 Skylake nodes). We are using only 24 cores for the model since NX*NY=2*12=24, one exclusive node for the oserver, and 16 backend processes to handle data writing. Please note that this is a very small case. For the hgher resolutions, the number of nodes for the model will be much larger than the number of nodes for the o-server. For example, one might have over 200 nodes for the model and only 8 nodes for the o-server with each o-server node having 2 backend processes.

  Try to benchmark with the asynchronous o-server. Play with the --nodes_ouput_server and --npes_backend_pernode parameters.
