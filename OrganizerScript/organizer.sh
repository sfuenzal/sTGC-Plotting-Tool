#!/usr/bin/bash

base_path=/home/sebastian/sTGC_output_plots/plots
input_path=/home/sebastian/sTGC_output_plots/sTGC_plotting_tool/InputHistograms
script_path=/home/sebastian/sTGC_output_plots/OrganizerScript
python_script_path=/home/sebastian/sTGC_output_plots/sTGC_plotting_tool/SourceCode

sub_folders=("Overview" "Summary")
sub_sub_folders=("ASide" "CSide")
run_number=()
file_names=()

cd $base_path

for i in $(ls $input_path); do
    #echo "In the path, "$base_path" we are creating the folders: "$i
    run_number+=($(echo $i | cut -b 18-23))
    file_names+=($i)
    for j in ${sub_folders[@]}; do

	mkdir -p -v $i/$j
	
	if [[ $j == "Summary" ]]; then
	    for k in ${sub_sub_folders[@]}; do
		mkdir -p -v $i/$j/$k
	    done
	fi
    done  
done


cd $python_script_path

for i in ${!run_number[@]}; do
    for j in ${!sub_folders[@]}; do
	for k in ${!sub_sub_folders[@]}; do
	    python3 plotting.py --runNumber ${run_number[$i]} --inputROOTFile ${file_names[$i]} --side ${!sub_folders[j]} --folder ${!sub_sub_folders[k]}
	done
    done
done


#cd $script_path

#mkdir
#cd


#python3 plotting.py --runNumber run_430616 --inputPath /home/sebastian/sTGC_output_plots/sTGC_plotting_tool/InputHistograms/data22_13p6TeV.00430616.physics_Main.merge.HIST.f1259_h388/data22_13p6TeV.00430616.physics_Main.merge.HIST.f1259_h388._0001.1 --side ASide --folder Summary
