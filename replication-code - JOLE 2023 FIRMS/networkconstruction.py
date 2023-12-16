# -*- coding: utf-8 -*-
"""
Created on Thu Mar 25 22:13:10 2021

@author: boemic
"""


## Import the relevant libraries
from pylab import *
import os
import networkx as nx
import time
import datetime
import logging as lg
import matplotlib.pyplot as plt


## Change the directory and initialize the log-file
os.chdir("//.../JOLE-replication")

lg.basicConfig(filename='out/networkconstruction.log', filemode='w', level=lg.INFO)
now = datetime.datetime.now()

## set the parameters
#skill = 1
data = "full" ## options: "full" "sample" "simulated"


for skill in [0,1,2]:

    ## Read in the network data and generate its graph G
    G = nx.read_adjlist(f"./out/network-{data}-s{skill}.txt", delimiter = ",")
    
    ## For a small network we can plot it; for a large file comment out the following lines.
    #fig1,ax1=plt.subplots()
    #plt.figure(1) 
    #nx.draw(G, with_labels = True)
    #list(G.nodes)
    #list(G.edges)
    
    ## Work with a copy of G
    G0 = G.copy()
    print(f'number in skill={skill} going IN = {len(G0)}') 
    
    A0 = list(nx.articulation_points(G0))
    
    S = G0.copy()
    for node in A0:
        if (int(node) < 0):
            S.remove_node(node)

    #print(f'number of firms going IN = {len(A0)}') 
    
       
    ## For a small network we can plot the separate components.
    #plt.figure(2)  
    #nx.draw(S, with_labels = True)
    
    ## Find the largest connected set among these components. Strictly speaking 
    ## this should be with the most firms but practically it won't matter
    largest_cc = max(nx.connected_components(S), key=len)
      
    ## Add back ALL the nodes that we removed (worker articulation points) 
    for node in A0:
        if (int(node) < 0):
            largest_cc.add(node)
         
    G1 = nx.Graph(G0.subgraph(largest_cc))
    ## Remove the isolated nodes that we added back (ie that are not actually part of this largest cc)
    G1.remove_nodes_from(list(nx.isolates(G1)))
    
    ## For a small network we can plot the result
    #plt.figure(4)   
    #nx.draw(G0, with_labels = True)
    #plt.show()
    #list(G0.nodes)
    #print(list(G0.edges))
    
    ## Save the result
    nx.write_edgelist(G1,f"./out/result-{data}-s{skill}.txt", comments='#', delimiter=",", data=False, encoding="utf-8")
    print(f'number in skill={skill} coming OUT = {len(G1)}') 
    #A1 = list(nx.articulation_points(G1))
    #print(f'number of firms coming OUT = {len(A1)}') 



# =============================================================================
# ## Check we really have the leave-one-out set by two checks:
# R = nx.read_adjlist(f"./data/result-s{skill}.txt", delimiter = ",")
# print(len(R))
# 
# ## 1 R is a connected set (ie it is its own largest cc)
# largest_ccR = max(nx.connected_components(R), key=len)
# if (len(R) != len(largest_ccR)):
#     print("error")
# 
# ## 2 none of the articulation points is a worker
# A1 = list(nx.articulation_points(R))
# print(len(A1))
# for node in A1:
#     if (int(node) < 0):
#         print("error")
# =============================================================================
        
    

#R0 = nx.read_adjlist(f"./data/result-s0.txt", delimiter = ",")
#R0 = np.fromfile("./data/result-s1.txt", dtype=int, count=-1, sep=",")
#R0 = np.fromfile("./data/sample/wage.txt", dtype=float, count=-1, sep=" ")
