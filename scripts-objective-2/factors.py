nxs = []
nys = []
thread_list = []
unique_thread_list = []
uniq_nx = []
uniq_ny = []

# Script comment update 8/19/2024, Morgan Newton:

# 720 resolution run = 0.25 of 2880:
# 5*126 = 630 = 5 nodes, 126 tasks per node
# Therefore, approximately 576 total tasks needed

# 1440 resolution run is 2x the 720 resolution run
# Therefore, 630*2 = 1260 total tasks

# 2880 resolution run is 4x the 720 resolution run
# Therefore, 630*4 = 2520 total tasks

for threads in range(0, 576, 12):
    cc = 0
    for nx in range(1, 51):
        ny = threads / nx
        if ny % 24 == 0 and nx < ny: # Change this modulo number to the number of aggregators you're using (must be a multiple of 6)
            cc += 1
            print("NX is {}, NY is {}, which is the {} time we got a combo for {}".format(nx,ny, cc, threads))
            print(ny/24)
            if cc < 3 and threads > 180 and (abs(threads - last_added) > 120):
                nxs.append(nx)
                nys.append(ny)
                thread_list.append(threads)
            elif cc < 3 and threads < 180:
                nxs.append(nx)
                nys.append(ny)
                thread_list.append(threads)
                last_added = threads
            if threads in thread_list and cc >= 3:
                last_added = threads
            print(threads, last_added)

with open("720_params_24.txt", "w") as f: # Change the filename to whatever you'd like
    for i in range(len(nxs)):
        f.write("{}\t{}\n".format(int(nxs[i]),int(nys[i])))  # The other scripts depend on this tab separation