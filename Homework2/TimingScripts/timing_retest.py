#!/usr/bin/env python

# import modules
import re #regex module

# open file
with open("/Users/Kayleigh/Dropbox/IBRAIN/Homework2/sub-03/ses-retest/func/sub-03_ses-retest_task-linebisection_events.tsv", 'r') as f:
    s=f.read()

# setup dictionary
timing_dic = {"LCor": [], "LIncor": [], "DResp": [], "LNR": [], "DNR": []}

regex = re.compile(r"([\d.]+)+\t([\d.]+)+\t([\d.]+)\t([\w]+)", re.MULTILINE)

matches = regex.finditer(s)

for m in matches:
	if m.groups()[3] == "Correct_Task":
		timing_dic["LCor"].append(m.groups()[0])
	elif m.groups()[3] == "Incorrect_Task":
		timing_dic["LIncor"].append(m.groups()[0])
	elif m.groups()[3] == "Response_Control":
		timing_dic["DResp"].append(m.groups()[0])
	elif m.groups()[3] == "No_Response_Task":
		timing_dic["LNR"].append(m.groups()[0])
	elif m.groups()[3] == "No_Response_Control":
		timing_dic["DNR"].append(m.groups()[0])

with open("timing_re_LCor.1D","w") as f:
	f.write(' '.join(timing_dic["LCor"]))
with open("timing_re_LIncor.1D","w") as f:
	f.write(' '.join(timing_dic["LIncor"]))
with open("timing_re_DResp.1D","w") as f:
	f.write(' '.join(timing_dic["DResp"]))
with open("timing_re_LNR.1D","w") as f:
	f.write(' '.join(timing_dic["LNR"]))
with open("timing_re_DNR.1D","w") as f:
	f.write(' '.join(timing_dic["DNR"]))