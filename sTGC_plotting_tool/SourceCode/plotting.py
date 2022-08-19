#!/usr/bin/python3

import ROOT as R
import argparse
import os
R.gROOT.SetBatch(True)

parser = argparse.ArgumentParser()

parser.add_argument("--runNumber", default = "run_410000", help = "Enter the name of the run.")
parser.add_argument("--inputROOTFile", default = "monitor_sTgc.root", help = "Name of the input samples with histograms and directories")
parser.add_argument("--side", default = "ASide", help = "Select the side over which you want to extract the plots (ASide or CSide).")
parser.add_argument("--folder", default = "Overview", help = "Select the directory over which you want to extract the plots (Overview, Summary).")
args = parser.parse_args()


ROOT_file_base_dir = None

if (args.folder == "Overview"):
    ROOT_file_base_dir   = "run_" + args.runNumber + "/Muon/MuonRawDataMonitoring/sTgc/Overview" 
    os.chdir("/home/sebastian/sTGC_output_plots/plots/" + args.inputROOTFile + "/" + args.folder)
else:
    ROOT_file_base_dir   = "run_" + args.runNumber + "/Muon/MuonRawDataMonitoring/sTgc/" + args.side  + "/" + args.folder
    os.chdir("/home/sebastian/sTGC_output_plots/plots/" + args.inputROOTFile + "/" + args.folder + "/" + args.side)
    
input_ROOT_file_path = args.inputROOTFile + "._0001.1"


ROOT_file = R.TFile.Open(input_ROOT_file_path, "read")
get_keys_base_dir = ROOT_file.Get(ROOT_file_base_dir)

for keysROOTFile in get_keys_base_dir.GetListOfKeys():
    get_keys_dir = keysROOTFile.GetName()
    get_type = keysROOTFile.GetClassName()
    
    if (get_type == "TTree"):
        continue

    c1 = R.TCanvas()
    c1.SetTickx()
    c1.SetTicky()
    c1.SetLeftMargin(0.1)
    c1.SetRightMargin(0.18)
    
    if (get_type == "TH1F"):
        h = get_keys_base_dir.Get(get_keys_dir)
        h.SetStats(0)
        h.Draw()
        c1.Print(str(get_type) + "_" + str(get_keys_dir) + ".png")

    elif (get_type == "TH2F"):
        h = get_keys_base_dir.Get(get_keys_dir)
        h.GetZaxis().SetLabelSize(0.024)
        h.SetStats(0)
        h.GetZaxis().SetRangeUser(0, 500)
        h.Draw("colz")
        h.GetZaxis().SetTitle("Hits")
        c1.Print(str(get_type) + "_" + str(get_keys_dir) + ".png")
        
    c1.Update()
    c1.Clear()
