#!/usr/bin/bash

base_path=$(realpath ../)
package_path=$base_path
name_folder_with_input_histograms="InputHistograms" # This folder must be located inside the folder sTGC_plotting_tool (You have to create it first!)
# Inside that folder you have to put your inputs divided in different folders, where each folders hold input Run 3 ROOT files with histograms

output_plots_path=$base_path/plots
input_ROOT_files_path=$base_path/sTGC_plotting_tool/$name_folder_with_input_histograms
organizer_bash_script_path=$base_path/OrganizerScript
python_sTGC_plotting_tool_path=$base_path/sTGC_plotting_tool/SourceCode

sub_folders=("Overview" "Summary")
sub_sub_folders=("ASide" "CSide")
run_number=()
file_names=()

echo "What operation do you want to execute?"
echo "Create skeleton            -> 0"
echo "Reorganize inputs          -> 1"
echo "Execute sTGC plotting tool -> 2"
read answer

if (( $answer == 0 )); then
    echo "Creating skeleton..."
    for i in $(ls $input_ROOT_files_path); do
	if [[ $i == "inputsOrganized" ]]; then
	    continue
	fi
	
	for j in ${sub_folders[@]}; do
	    if [[ $j == "Overview" ]]; then
		mkdir -p -v $output_plots_path/$i/$j
	    else
		for k in ${sub_sub_folders[@]}; do
		    mkdir -p -v $output_plots_path/$i/$j/$k
		done
	    fi
	done  
    done
    echo "Skeleton created!"
elif (( $answer == 1 )); then
    echo "Organizing input histogram ROOT files..."
    mkdir -p -v $input_ROOT_files_path/inputsOrganized
    
    for i in $(ls $input_ROOT_files_path); do
	if [[ $i == "inputsOrganized" ]]; then
	    continue
	fi

	for j in $(ls $input_ROOT_files_path/$i); do
	    cp -v $input_ROOT_files_path/$i/$j $input_ROOT_files_path/inputsOrganized 
	done
    done
    
    echo "Files organized!"
elif (( $answer == 2 )); then
    echo "Executing python sTGC plotting tool..."
    
    for i in $(ls $input_ROOT_files_path/inputsOrganized); do
	if [[ $i == "inputsOrganized" ]]; then
	    continue
	fi
	
	run_number+=($(echo $i | cut -b 18-23))
	file_names+=($(echo $i | cut -b 1-58))
    done

    cd $python_sTGC_plotting_tool_path
    
    for i in ${!file_names[@]}; do
	for j in ${!sub_folders[@]}; do
	    if [[ ${sub_folders[j]} == "Overview" ]]; then
		echo "file: "${file_names[i]}", run: "${run_number[i]}", folder: "${sub_folders[j]}
		python3 plotting.py --runNumber ${run_number[i]} --inputROOTFile ${file_names[i]} --folder ${sub_folders[j]}  
	    else
		for k in ${!sub_sub_folders[@]}; do
		    echo "file: "${file_names[i]}", run: "${run_number[i]}", folder: "${sub_folders[j]}", side: "${sub_sub_folders[k]}
		    python3 plotting.py --runNumber ${run_number[i]} --inputROOTFile ${file_names[i]} --side ${sub_sub_folders[j]} --folder ${sub_folders[k]}
		done
	    fi
	done
    done
    
    echo "Execution finalized!"
else
    echo "Invalid option entered :( Try again!"
    return
fi

cd $package_path
