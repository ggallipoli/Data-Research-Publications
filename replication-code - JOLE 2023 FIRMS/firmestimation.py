import numpy as np
from scipy.sparse import csc_matrix, csr_matrix, lil_matrix, hstack, linalg, diags, vstack, coo_matrix
import os
import matplotlib.pylab as plt
import time
import pandas as pd
import datetime
import logging as lg
from scipy import sparse


t0 = time.time()

os.chdir("//.../JOLE-replication")


##############################
## parameters to be specified
##############################

data = "full" ## options: "sample" "simulated" "full" "fullObs"
spec = "2slopeXb" ## options: "1slope" "2slope" "1slopeXb" "2slopeXb"
skill = "norm" ## options: "stanine" "norm" "dummy" 
PiiPolicy = "new" ## options: "new" "read"
alg = "minres" ## options: "minres" "cg"
p = 50

now = datetime.datetime.now()

# smaller sample or simulated data for debugging
if data=="sample" or data=="simulated": 
  lg.basicConfig(filename=f'out/firmlevel-{data}-{spec}.log', filemode='w', 
                 level=lg.INFO)  
# actual estimation sample
else:    
  lg.basicConfig(filename=f'out/firmlevel-{data}-{spec}-{skill}.log', 
                   filemode='w', level=lg.INFO)


lg.info(f' program STARTED at date-time: {now}')
print(f' program STARTED: time is {now}\n')

lg.info(f' Specifications: Spec={spec}, data={data}, Pii={PiiPolicy}, iterations={p}\n')


wID = np.fromfile(f"./out/{data}/worker_ID.txt", dtype=int, sep=" ")
fID = np.fromfile(f"./out/{data}/firm_ID.txt", dtype=int, sep=" ")
tID = np.fromfile(f"./out/{data}/time_ID.txt", dtype=int, sep=" ")
Y = np.fromfile(f"./out/{data}/wage.txt", dtype=float, sep=" ")
wC = np.fromfile(f"./out/{data}/worker_C.txt", dtype=float, sep=" ")
wCID = np.fromfile(f"./out/{data}/worker_CID.txt", dtype=int, sep=" ")
wN = np.fromfile(f"./out/{data}/worker_N.txt", dtype=float, sep=" ")
wNID = np.fromfile(f"./out/{data}/worker_NID.txt", dtype=int, sep=" ")
ageID = np.fromfile(f"./out/{data}/age_ID.txt", dtype=int, sep=" ")


# coarsen the controls
tIDold = tID.copy()
tID = np.where(tIDold >= 2, 1, 0)
tID = np.where(tIDold >= 4, 2, tID)
tID = np.where(tIDold >= 6, 3, tID)
tID = np.where(tIDold >= 8, 4, tID)  
del(tIDold)
 
if skill=="stanine" or skill=="norm":
    wCIDold = wCID.copy()
    wCID = np.where(wCIDold >= 4, 1, 0)
    wCID = np.where(wCIDold >= 7, 2, wCID)
    wNIDold = wNID.copy()
    wNID = np.where(wNIDold >= 4, 1, 0)
    wNID = np.where(wNIDold >= 7, 2, wNID)    
    del(wCIDold,wNIDold)

# other skill definitions    
if skill=="dummy": 
    wC = np.where(wC >= 6, 1, 0)
    wCID = np.where(wCID >= 6, 1, 0)
    wN = np.where(wN >= 6, 1, 0)
    wNID = np.where(wNID >= 6, 1, 0)

if skill=="norm": #make uniform within [0,1]  
     wC = (wC - 1)/8
     wN = (wN - 1)/8
     lg.info(np.unique(wC))
     lg.info(np.unique(wN))   
    

uCID = len(np.unique(wCID))
uNID = len(np.unique(wNID))
    

n = len(wID) 
I = max(wID)+1
J = max(fID)+1
T = max(tID)+1


ones = np.ones(n)
row = np.arange(n)
wFE = csc_matrix((ones,(row,wID)))
lam0 = csc_matrix((ones,(row,fID)))
lamC = csc_matrix((wC,(row,fID)))
lamN = csc_matrix((wN,(row,fID)))



###################
## Specify the model we are estimating
################### 

## No controls
if spec=="1slope":
    X = hstack([wFE, lam0[0:,1:], lamC[0:,1:]]) 
 
## Only cognitive controls
if spec=="1slopeXb":
    ctrls = csc_matrix((ones,(row,ageID*uCID*T+wCID*T+tID)))
    X = hstack([wFE, lam0[0:,1:], lamC[0:,1:], ctrls[0:,1:]]) 

## No controls but both returns    
if spec=="2slope":
    X = hstack([wFE, lam0[0:,1:], lamC[0:,1:], lamN[0:,1:]]) 

## Both cogn. and non-cogn controls
if spec=="2slopeXb":
    ctrls = csc_matrix((ones,(row,ageID*uCID*uNID*T+wCID*uNID*T+wNID*T+tID)))
    X = hstack([wFE, lam0[0:,1:], lamC[0:,1:], lamN[0:,1:], ctrls[0:,1:]]) 


###################
## Construct the relevant matrices
################### 

X = X[:, np.where(X.sum(axis=0)!=0)[1]].tocsc()

XT = np.transpose(X)
Sxx = XT.dot(X)

k = Sxx.shape[0]

S11 = Sxx[0:I,0:I].tocsc()
S12 = Sxx[0:I,I:].tocsc()
S21 = Sxx[I:,0:I].tocsc()
S22 = Sxx[I:,I:].tocsc()

S11inv = diags(1/S11.diagonal())
S21S11inv = S21.dot(S11inv)
nonDiagBlock = (S22-S21S11inv.dot(S12)).tocsc()


XTY = XT.dot(Y)

b1 = XTY[0:I]
b2 = XTY[I:]
x2 = linalg.cg(nonDiagBlock,b2-S21S11inv.dot(b1),tol=10 ** -5)[0]

x1 = S11inv.dot(b1-S12.dot(x2))   
beta = np.concatenate((x1,x2),axis=0).transpose()
# beta = linalg.spsolve(Sxx, XT.dot(Y))
res = np.array(Y-X.dot(beta))

lg.info(f'beta elements = {beta[0:10]}: time is {datetime.datetime.now()}\n') 



###################
## "Naive" plugin Variances
################### 


XtildeTlam0 = hstack([csc_matrix((n,I)), lam0[0:,1:], csc_matrix((n,k-I-J+1))]).transpose() # uncomment for var(lambda0)
lam0hat = XtildeTlam0.transpose().dot(beta)
lg.info(f'plugin sdev firm FE = {np.sqrt(np.var(lam0hat))}\n')
print(f'plugin sdev firm FE = {np.sqrt(np.var(lam0hat))}\n')

XtildeTlamC = hstack([csc_matrix((n,I+J-1)), lam0[0:,1:], csc_matrix((n,k-I-2*(J-1)))]).transpose() # uncomment for var(lambdaC) 
lamChat = XtildeTlamC.transpose().dot(beta)
lg.info(f'plugin sdev firm C slope = {np.sqrt(np.var(lamChat))}\n')
print(f'plugin sdev firm C slope = {np.sqrt(np.var(lamChat))}\n')
#de-meaning lamChat for variance contribution below
helpmeanC = np.mean(lamChat)
betaC = []
for i in np.arange(len(beta)):
    betaC.append(beta[i]-helpmeanC)
lg.info(f'lamChat: Mean near 0? {np.mean(XtildeTlamC.transpose().dot(betaC))}')
lg.info(f'lamChat: Correlation = 1? {np.corrcoef(beta, betaC)[0,1]}\n')        

XtildeTlamN = hstack([csc_matrix((n,I+2*(J-1))), lam0[0:,1:], csc_matrix((n,k-I-3*(J-1)))]).transpose() # uncomment for var(lambdaN) 
lamNhat = XtildeTlamN.transpose().dot(beta)
lg.info(f'plugin sdev firm N slope = {np.sqrt(np.var(lamNhat))}\n')
print(f'plugin sdev firm N slope = {np.sqrt(np.var(lamNhat))}\n')
#de-meaning lamNhat for variance contribution below
helpmeanN = np.mean(lamNhat)
betaN = []
for i in np.arange(len(beta)):
    betaN.append(beta[i]-helpmeanN)
lg.info(f'lamNhat: Mean near 0? {np.mean(XtildeTlamN.transpose().dot(betaN))}')
lg.info(f'lamNhat: Correlation = 1? {np.corrcoef(beta, betaN)[0,1]}')         
lg.info(f' \n Demeaning lamC and lamN DONE {datetime.datetime.now()} \n')


XtildeTwFE = hstack([wFE, csc_matrix((n,k-I))]).transpose()  # uncomment for var(worker FE)
wFEhat = XtildeTwFE.transpose().dot(beta)
lg.info(f'unadjusted variance worker FE = {np.var(wFEhat)}\n')
lg.info(f'unadjusted sdev worker FE = {np.sqrt(np.var(wFEhat))}\n')
if data=="sample" or data=="simulated":
    print(f'unadjusted variance worker FE = {np.var(wFEhat)}\n')
    print(f'unadjusted sdev worker FE = {np.sqrt(np.var(wFEhat))}\n')
wFEhat = wFEhat + helpmeanC*wC + helpmeanN*wN
lg.info(f'plugin variance worker FE = {np.var(wFEhat)}\n')
lg.info(f'plugin sdev worker FE = {np.sqrt(np.var(wFEhat))}\n')
if data=="sample" or data=="simulated":
    print(f'plugin variance worker FE = {np.var(wFEhat)}\n')
    print(f'plugin sdev worker FE = {np.sqrt(np.var(wFEhat))}\n')
    
# variance contribution of lamCNhat
XtildeTlam00 = hstack([csc_matrix((n,I+J-1)), lam0[0:,1:], lam0[0:,1:], csc_matrix((n,k-I-3*(J-1)))]).transpose() # uncomment for var(lambdaN) 
lam00hat = XtildeTlam00.transpose().dot(beta)
lg.info(f'plugin sdev firm lamC*1 + lamN*1 contribution = {np.sqrt(np.var(lam00hat))}\n')
print(f'plugin sdev firm lamC*1 + lamN*1 contribution = {np.sqrt(np.var(lam00hat))}\n')
   
XtildeTlamCC = hstack([csc_matrix((n,I+J-1)), lamC[0:,1:], csc_matrix((n,k-I-2*(J-1)))]).transpose() 
lamCChat = XtildeTlamCC.transpose().dot(beta)
lg.info(f'unadjusted sdev firm lamC*C contribution = {np.sqrt(np.var(lamCChat))}\n')
lamCChat = XtildeTlamCC.transpose().dot(betaC)
lg.info(f'Wage level firm lamC*C contribution = {np.mean(lamCChat)}\n')
lg.info(f'plugin sdev firm lamC*C contribution = {np.sqrt(np.var(lamCChat))}\n')
print(f'plugin sdev firm lamC*C contribution = {np.sqrt(np.var(lamCChat))}\n')
    
XtildeTlamNN = hstack([csc_matrix((n,I+2*(J-1))), lamN[0:,1:], csc_matrix((n,k-I-3*(J-1)))]).transpose() 
lamNNhat = XtildeTlamNN.transpose().dot(beta)
lg.info(f'unadjusted sdev firm lamN*N contribution = {np.sqrt(np.var(lamNNhat))}\n')
lamNNhat = XtildeTlamNN.transpose().dot(betaN)
lg.info(f'Wage level firm lamN*N contribution = {np.mean(lamNNhat)}\n')
lg.info(f'plugin sdev firm lamN*N contribution = {np.sqrt(np.var(lamNNhat))}\n')
print(f'plugin sdev firm lamN*N contribution = {np.sqrt(np.var(lamNNhat))}\n')
 

XtildeTlamCN = hstack([csc_matrix((n,I+J-1)), lamC[0:,1:], lamN[0:,1:], csc_matrix((n,k-I-3*(J-1)))]).transpose()  
lamCNhatNonnorm = XtildeTlamCN.transpose().dot(beta)
lg.info(f'unadjusted sdev firm lamC*C + lamN*N contribution = {np.sqrt(np.var(lamCNhatNonnorm))}\n')

lamCNhat = lamCChat + lamNNhat 
lg.info(f'Wage level firm lamC*C + lamN*N contribution = {np.mean(lamCNhat)}\n')
lg.info(f'plugin sdev firm lamC*C + lamN*N contribution = {np.sqrt(np.var(lamCNhat))}\n')
print(f'plugin sdev firm lamC*C + lamN*N contribution = {np.sqrt(np.var(lamCNhat))}\n')

     
lg.info(f'XtildeT defined: time is {datetime.datetime.now()}\n') 




###################
## KSS-Pii estimation
###################

RPT = 2*np.random.randint(2,size=(n,p))-1
RBT = 2*np.random.randint(2,size=(n,p))-1
RBTbar = np.zeros((n,p))

for i in range(p):
    RBTbar[:,i] = np.mean(RBT[:,i])
    

XTRPT = XT.dot(RPT)
#A1TRBT = (XtildeT.dot(RBT)-XtildeT.dot(RBTbar))/np.sqrt(n)
A1TwFERBT = (XtildeTwFE.dot(RBT)-XtildeTwFE.dot(RBTbar))/np.sqrt(n)
A1Tlam0RBT = (XtildeTlam0.dot(RBT)-XtildeTlam0.dot(RBTbar))/np.sqrt(n)
A1TlamCRBT = (XtildeTlamC.dot(RBT)-XtildeTlamC.dot(RBTbar))/np.sqrt(n)
A1TlamNRBT = (XtildeTlamN.dot(RBT)-XtildeTlamN.dot(RBTbar))/np.sqrt(n)

A1Tlam00RBT = (XtildeTlam00.dot(RBT)-XtildeTlam00.dot(RBTbar))/np.sqrt(n)
A1TlamCCRBT = (XtildeTlamCC.dot(RBT)-XtildeTlamCC.dot(RBTbar))/np.sqrt(n)
A1TlamNNRBT = (XtildeTlamNN.dot(RBT)-XtildeTlamNN.dot(RBTbar))/np.sqrt(n)
A1TlamCNRBT = (XtildeTlamCN.dot(RBT)-XtildeTlamCN.dot(RBTbar))/np.sqrt(n)


lg.info(f'first loop completed, A1TRBT calculated: time is {datetime.datetime.now()}\n') 


## Estimate P anew
if PiiPolicy == "new":
    b1 = XTRPT[0:I,:].copy()
    b2 = XTRPT[I:,:].copy()
    
    x2 = np.zeros((k-I,p), dtype=float)
    JLAtemp = b2-S21S11inv.dot(b1)
    def JLAi1(i):
        x2temp = linalg.cg(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),
                           tol=10 ** -5)[0]
        x2[:,i] = x2temp
        #print(nonDiagBlock.dot(x2temp)-JLAtemp[:,i])
           
    for i in range(p):
        t0=time.time()
        JLAi1(i)
        lg.info(f'i = {i+1} from {p} of Pii; passed time {time.time()-t0}')
        if data=="sample" or data=="simulated":
            print(f'i = {i+1} from {p} of Pii; passed time {time.time()-t0}')
        
    x1 = S11inv.dot(b1-S12.dot(x2))   
    SinvXTRPT = vstack([x1, x2]).toarray()
    Z = X.dot(SinvXTRPT)
    P = np.sum(Z**2,axis=1)/p
    Psq = np.sum(Z**4,axis=1)/p
        
    M = np.sum((RPT-Z)**2,axis=1)/p
    Msq = np.sum((RPT-Z)**4,axis=1)/p
   
    PM = np.sum((Z**2)*((RPT-Z)**2),axis=1)/p
       
    P = P/(P+M)
    M = 1-P
    
    V = (1/p)*((M**2)*Psq+(P**2)*Msq-2*M*P*PM)
    Bi = (1/p)*(M*Psq-P*Msq+2*(M-P)*PM)
    sig2 = (Y-np.mean(Y))*res/M*(1-V/(M**2)+Bi/M)

    if data=="sample" or data=="simulated":
        np.savetxt(f"./out/{data}-P.txt", P)
        np.savetxt(f"./out/{data}-sig2.txt", sig2)
    else: 
        np.savetxt(f"./out/firmlevel-{data}-{spec}-{skill}-P.txt", P)
        np.savetxt(f"./out/firmlevel-{data}-{spec}-{skill}-sig2.txt", sig2)
        
    lg.info(f'Pii estimation is done: time is {datetime.datetime.now()}\n')
      
## Read in P from prior estimate
else:
    if data=="sample" or data=="simulated":
        sig2 = np.fromfile(f"./out/{data}-sig2.txt", dtype=float, sep=" ") 
        P = np.fromfile(f"./out/{data}-P.txt", dtype=float, sep=" ")
    else:  
        source = f'firmlevel-{data}-{spec}-{skill}'
        sig2 = np.fromfile(f"./out/{source}-sig2.txt", 
                    dtype=float, sep=" ") 
        P = np.fromfile(f"./out/{source}-P.txt", 
                    dtype=float, sep=" ")
        
    M = 1-P
    lg.info(f'Pii loading is done: time is {datetime.datetime.now()}\n')
    
lg.info(f'Pii elements = {P[0:10]}: time is {datetime.datetime.now()}\n') 


###################
## Bii estimation for parameters
###################

# compute basic naive moments we will use
naiveCOVlamNlam0 = np.cov(XtildeTlamN.transpose().dot(beta),XtildeTlam0.transpose().dot(beta))
naiveCOVlamNlamC = np.cov(XtildeTlamN.transpose().dot(beta),XtildeTlamC.transpose().dot(beta))
naiveCOVlam0lamC = np.cov(XtildeTlam0.transpose().dot(beta),XtildeTlamC.transpose().dot(beta))
naiveCOVlam0lamCN = np.cov(XtildeTlam0.transpose().dot(beta),XtildeTlamCN.transpose().dot(beta))

naiveCOVlam0wFE = np.cov(XtildeTlam0.transpose().dot(beta),XtildeTwFE.transpose().dot(beta))
naiveCOVlamCwFE = np.cov(XtildeTlamC.transpose().dot(beta),XtildeTwFE.transpose().dot(beta))
naiveCOVlamNwFE = np.cov(XtildeTlamN.transpose().dot(beta),XtildeTwFE.transpose().dot(beta))
naiveCOVlamCNwFE = np.cov(XtildeTlamCN.transpose().dot(beta),XtildeTwFE.transpose().dot(beta))


########## wFE #############
lg.info('\n\n **********start Bii for wFE********** \n')

b1 = A1TwFERBT[0:I,:]
b2 = A1TwFERBT[I:,:]

x2 = np.zeros((k-I,p), dtype=float)
JLAtemp = b2-S21S11inv.dot(b1)
def JLAi2(i):
    if alg=="minres":
        x2temp, exitcode = linalg.minres(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -10)
        lg.info(f'exitcode = {exitcode}')
    else:
        x2temp = linalg.cg(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -5)[0] 

    lg.info(f'min(x2) = {min(x2temp)}, max(x2) = {max(x2temp)}')
    x2[:,i] = x2temp
     
for i in range(p):
    t0=time.time()
    JLAi2(i)
    
    lg.info(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')
    if data=="sample" or data=="simulated":
        print(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')

x1 = S11inv.dot(b1-S12.dot(x2))   
SinvA1TwFERBT = vstack([x1, x2]).toarray()

XSinvA1TwFERBT = X.dot(SinvA1TwFERBT)
BwFEwFE = sum(np.transpose(XSinvA1TwFERBT) * np.transpose(XSinvA1TwFERBT))/p
naiveVARwFE = naiveCOVlam0wFE[1,1]
VARwFE = naiveVARwFE - sum(BwFEwFE*sig2)
lg.info(f'Naive SDEVwFE = {np.sqrt(naiveVARwFE)}\n')
lg.info(f'Adjusted SDEVwFE = {np.sqrt(VARwFE)}\n')
lg.info(f'\n Naive VARwFE = {naiveVARwFE}\n')
lg.info(f'Adjusted VARwFE = {VARwFE}\n')


########## lam0 #############
lg.info('\n\n **********start Bii for lam0********** \n')

b1 = A1Tlam0RBT[0:I,:]
b2 = A1Tlam0RBT[I:,:]

x2 = np.zeros((k-I,p), dtype=float)
JLAtemp = b2-S21S11inv.dot(b1)
def JLAi2(i):
    if alg=="minres":
        x2temp, exitcode = linalg.minres(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -10)
        lg.info(f'exitcode = {exitcode}')
    else:
        x2temp = linalg.cg(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -5)[0] 

    lg.info(f'min(x2) = {min(x2temp)}, max(x2) = {max(x2temp)}')
    x2[:,i] = x2temp
     
for i in range(p):
    t0=time.time()
    JLAi2(i)
    
    lg.info(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')
    if data=="sample" or data=="simulated":
        print(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')

x1 = S11inv.dot(b1-S12.dot(x2))   
SinvA1Tlam0RBT = vstack([x1, x2]).toarray()

XSinvA1Tlam0RBT = X.dot(SinvA1Tlam0RBT)
Blam0lam0 = sum(np.transpose(XSinvA1Tlam0RBT) * np.transpose(XSinvA1Tlam0RBT))/p
naiveVARlam0 = naiveCOVlam0lamC[0,0]
VARlam0 = naiveVARlam0 - sum(Blam0lam0*sig2)
lg.info(f'Naive SDEVlam0 = {np.sqrt(naiveVARlam0)}\n')
lg.info(f'Adjusted SDEVlam0 = {np.sqrt(VARlam0)}\n')
lg.info(f'\n Naive VARlam0 = {naiveVARlam0}\n')
lg.info(f'Adjusted VARlam0 = {VARlam0}\n')


########## lamC #############
lg.info('\n\n **********start Bii for lamC********** \n')

b1 = A1TlamCRBT[0:I,:]
b2 = A1TlamCRBT[I:,:]

x2 = np.zeros((k-I,p), dtype=float)
JLAtemp = b2-S21S11inv.dot(b1)
def JLAi2(i):
    if alg=="minres":
        x2temp, exitcode = linalg.minres(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -10)
        lg.info(f'exitcode = {exitcode}')
    else:
        x2temp = linalg.cg(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -5)[0] 

    lg.info(f'min(x2) = {min(x2temp)}, max(x2) = {max(x2temp)}')
    x2[:,i] = x2temp
    
for i in range(p):
    t0=time.time()
    JLAi2(i)
    
    lg.info(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')
    if data=="sample" or data=="simulated":
        print(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')

x1 = S11inv.dot(b1-S12.dot(x2))   
SinvA1TlamCRBT = vstack([x1, x2]).toarray()

XSinvA1TlamCRBT = X.dot(SinvA1TlamCRBT)
BlamClamC = sum(np.transpose(XSinvA1TlamCRBT) * np.transpose(XSinvA1TlamCRBT))/p
naiveVARlamC = naiveCOVlamNlamC[1,1]
VARlamC = naiveVARlamC - sum(BlamClamC*sig2)
lg.info(f'Naive SDEVlamC = {np.sqrt(naiveVARlamC)}\n')
lg.info(f'Adjusted SDEVlamC = {np.sqrt(VARlamC)}\n')
lg.info(f'\n Naive VARlamC = {naiveVARlamC}\n')
lg.info(f'Adjusted VARlamC = {VARlamC}\n')


########## lamN #############
lg.info('\n\n **********start Bii for lamN********** \n')

b1 = A1TlamNRBT[0:I,:]
b2 = A1TlamNRBT[I:,:]

x2 = np.zeros((k-I,p), dtype=float)
JLAtemp = b2-S21S11inv.dot(b1)
def JLAi2(i):
    if alg=="minres":
        x2temp, exitcode = linalg.minres(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -10)
        lg.info(f'exitcode = {exitcode}')
    else:
        x2temp = linalg.cg(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -5)[0] 

    lg.info(f'min(x2) = {min(x2temp)}, max(x2) = {max(x2temp)}')
    x2[:,i] = x2temp
    
for i in range(p):
    t0=time.time()
    JLAi2(i)
    
    lg.info(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')
    if data=="sample" or data=="simulated":
        print(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')

x1 = S11inv.dot(b1-S12.dot(x2))   
SinvA1TlamNRBT = vstack([x1, x2]).toarray()

XSinvA1TlamNRBT = X.dot(SinvA1TlamNRBT)
BlamNlamN = sum(np.transpose(XSinvA1TlamNRBT) * np.transpose(XSinvA1TlamNRBT))/p
naiveVARlamN = naiveCOVlamNlam0[0,0]
VARlamN = naiveVARlamN - sum(BlamNlamN*sig2)
lg.info(f'Naive SDEVlamN = {np.sqrt(naiveVARlamN)}\n')
lg.info(f'Adjusted SDEVlamN = {np.sqrt(VARlamN)}\n')
lg.info(f'\n Naive VARlamN = {naiveVARlamN}\n')
lg.info(f'Adjusted VARlamN = {VARlamN}\n')


lg.info('\n\n **********Compute the proper covariances********** \n')
      
Blam0lamC = sum(np.transpose(XSinvA1Tlam0RBT) * np.transpose(XSinvA1TlamCRBT))/p
BlamNlam0 = sum(np.transpose(XSinvA1TlamNRBT) * np.transpose(XSinvA1Tlam0RBT))/p
BlamNlamC = sum(np.transpose(XSinvA1TlamNRBT) * np.transpose(XSinvA1TlamCRBT))/p

Blam0wFE = sum(np.transpose(XSinvA1Tlam0RBT) * np.transpose(XSinvA1TwFERBT))/p
BlamCwFE = sum(np.transpose(XSinvA1TlamCRBT) * np.transpose(XSinvA1TwFERBT))/p
BlamNwFE = sum(np.transpose(XSinvA1TlamNRBT) * np.transpose(XSinvA1TwFERBT))/p


naiveCOVlamNlam0 = naiveCOVlamNlam0[0,1]
COVlamNlam0 = naiveCOVlamNlam0 - sum(BlamNlam0*sig2)
naiveCOVlamNlamC = naiveCOVlamNlamC[0,1]
COVlamNlamC = naiveCOVlamNlamC - sum(BlamNlamC*sig2)
naiveCOVlam0lamC = naiveCOVlam0lamC[0,1]
COVlam0lamC = naiveCOVlam0lamC - sum(Blam0lamC*sig2)

naiveCOVlam0wFE = naiveCOVlam0wFE[0,1]
COVlam0wFE = naiveCOVlam0wFE - sum(Blam0wFE*sig2)
naiveCOVlamCwFE = naiveCOVlamCwFE[0,1]
COVlamCwFE = naiveCOVlamCwFE - sum(BlamCwFE*sig2)
naiveCOVlamNwFE = naiveCOVlamNwFE[0,1]
COVlamNwFE = naiveCOVlamNwFE - sum(BlamNwFE*sig2)

lg.info(f'\n Naive COVlam0lamC = {naiveCOVlam0lamC}\n')
lg.info(f'Adjusted COVlam0lamC = {COVlam0lamC}\n')

lg.info(f'Naive COVlamNlam0 = {naiveCOVlamNlam0}\n')
lg.info(f'Adjusted COVlamNlam0 = {COVlamNlam0}\n')

lg.info(f'Naive COVlamNlamC = {naiveCOVlamNlamC}\n')
lg.info(f'Adjusted COVlamNlamC = {COVlamNlamC}\n')

lg.info(f'\n Naive COVlam0wFE = {naiveCOVlam0wFE}\n')
lg.info(f'Adjusted COVlam0wFE = {COVlam0wFE}\n')

lg.info(f'Naive COVlamCwFE = {naiveCOVlamCwFE}\n')
lg.info(f'Adjusted COVlamCwFE = {COVlamCwFE}\n')

lg.info(f'Naive COVlamNwFE = {naiveCOVlamNwFE}\n')
lg.info(f'Adjusted COVlamNwFE = {COVlamNwFE}\n')

lg.info(f'Naive CORRlam0lamC = {naiveCOVlam0lamC / (np.sqrt(naiveVARlam0)*np.sqrt(naiveVARlamC))}\n')
lg.info(f'Adjusted CORRlam0lamC = {COVlam0lamC / (np.sqrt(VARlam0)*np.sqrt(VARlamC))}\n')

lg.info(f'Naive CORRlamNlam0 = {naiveCOVlamNlam0 / (np.sqrt(naiveVARlamN)*np.sqrt(naiveVARlam0))}\n')
lg.info(f'Adjusted CORRlamNlam0 = {COVlamNlam0 / (np.sqrt(VARlamN)*np.sqrt(VARlam0))}\n')

lg.info(f'Naive CORRlamNlamC = {naiveCOVlamNlamC / (np.sqrt(naiveVARlamN)*np.sqrt(naiveVARlamC))}\n')
lg.info(f'Adjusted CORRlamNlamC = {COVlamNlamC / (np.sqrt(VARlamN)*np.sqrt(VARlamC))}\n')

lg.info(f'Naive CORRlam0wFE = {naiveCOVlam0wFE / (np.sqrt(naiveVARlam0)*np.sqrt(naiveVARwFE))}\n')
lg.info(f'Adjusted CORRlam0wFE = {COVlam0wFE / (np.sqrt(VARlam0)*np.sqrt(VARwFE))}\n')

lg.info(f'Naive CORRlamCwFE = {naiveCOVlamCwFE / (np.sqrt(naiveVARlamC)*np.sqrt(naiveVARwFE))}\n')
lg.info(f'Adjusted CORRlamCwFE = {COVlamCwFE / (np.sqrt(VARlamC)*np.sqrt(VARwFE))}\n')

lg.info(f'Naive CORRlamNwFE = {naiveCOVlamNwFE / (np.sqrt(naiveVARlamN)*np.sqrt(naiveVARwFE))}\n')
lg.info(f'Adjusted CORRlamNwFE = {COVlamNwFE / (np.sqrt(VARlamN)*np.sqrt(VARwFE))}\n')


###################
## Bii estimation for Wage variance contributions
###################


# lamC*C
lg.info('\n\n **********start Bii for lamCC********** \n')

b1 = A1TlamCCRBT[0:I,:]
b2 = A1TlamCCRBT[I:,:]

x2 = np.zeros((k-I,p), dtype=float)
JLAtemp = b2-S21S11inv.dot(b1)
def JLAi2(i):
    x2temp, exitcode = linalg.minres(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -10)
    lg.info(f'min(x2) = {min(x2temp)}, max(x2) = {max(x2temp)}')
    x2[:,i] = x2temp
    
for i in range(p):
    t0=time.time()
    JLAi2(i)
    
    lg.info(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')
    if data=="sample" or data=="simulated":
        print(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')

x1 = S11inv.dot(b1-S12.dot(x2))   
SinvA1TlamCCRBT = vstack([x1, x2]).toarray()

XSinvA1TlamCCRBT = X.dot(SinvA1TlamCCRBT)
BlamCClamCC = sum(np.transpose(XSinvA1TlamCCRBT) * np.transpose(XSinvA1TlamCCRBT))/p
naiveVARlamCC = np.var(XtildeTlamCC.transpose().dot(betaC))
VARlamCC = naiveVARlamCC - sum(BlamCClamCC*sig2) 

lg.info(f'\n Naive VAR(lamC*C) = {naiveVARlamCC}\n')
lg.info(f'Adjusted VAR(lamC*C) = {VARlamCC}\n')

lg.info(f'Naive SDEV(lamC*C) = {np.sqrt(naiveVARlamCC)}\n')
lg.info(f'Adjusted SDEV(lamC*C) = {np.sqrt(VARlamCC)}\n')

lg.info(f'Bii estimation is done: time is {datetime.datetime.now()}\n')


# lamN*N
lg.info('\n\n **********start Bii for lamNN********** \n')

b1 = A1TlamNNRBT[0:I,:]
b2 = A1TlamNNRBT[I:,:]

x2 = np.zeros((k-I,p), dtype=float)
JLAtemp = b2-S21S11inv.dot(b1)
def JLAi2(i):
    x2temp, exitcode = linalg.minres(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -10)  
    lg.info(f'min(x2) = {min(x2temp)}, max(x2) = {max(x2temp)}')
    x2[:,i] = x2temp
    
for i in range(p):
    t0=time.time()
    JLAi2(i)
    
    lg.info(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')
    if data=="sample" or data=="simulated":
        print(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')

x1 = S11inv.dot(b1-S12.dot(x2))   
SinvA1TlamNNRBT = vstack([x1, x2]).toarray()

XSinvA1TlamNNRBT = X.dot(SinvA1TlamNNRBT)
BlamNNlamNN = sum(np.transpose(XSinvA1TlamNNRBT) * np.transpose(XSinvA1TlamNNRBT))/p
naiveVARlamNN = np.var(XtildeTlamNN.transpose().dot(betaN))
VARlamNN = naiveVARlamNN - sum(BlamNNlamNN*sig2) 

lg.info(f'\n Naive VAR(lamN*N) = {naiveVARlamNN}\n')
lg.info(f'Adjusted VAR(lamN*N) = {VARlamNN}\n')

lg.info(f'Naive SDEV(lamN*N) = {np.sqrt(naiveVARlamNN)}\n')
lg.info(f'Adjusted SDEV(lamN*N) = {np.sqrt(VARlamNN)}\n')

lg.info(f'Bii estimation is done: time is {datetime.datetime.now()}\n')


# lamC*C + lamN*N
lg.info('\n\n **********start Bii for lamCN********** \n')

b1 = A1TlamCNRBT[0:I,:]
b2 = A1TlamCNRBT[I:,:]

x2 = np.zeros((k-I,p), dtype=float)
JLAtemp = b2-S21S11inv.dot(b1)
def JLAi2(i):
    x2temp, exitcode = linalg.minres(nonDiagBlock,JLAtemp[:,i],x0=np.zeros((k-I,1)),tol=10 ** -10)     
    lg.info(f'min(x2) = {min(x2temp)}, max(x2) = {max(x2temp)}')
    x2[:,i] = x2temp
    
for i in range(p):
    t0=time.time()
    JLAi2(i)
    
    lg.info(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')
    if data=="sample" or data=="simulated":
        print(f'i = {i+1} from {p} of Bii; passed time {time.time()-t0}')

x1 = S11inv.dot(b1-S12.dot(x2))   
SinvA1TlamCNRBT = vstack([x1, x2]).toarray()

XSinvA1TlamCNRBT = X.dot(SinvA1TlamCNRBT)
BlamCNlamCN = sum(np.transpose(XSinvA1TlamCNRBT) * np.transpose(XSinvA1TlamCNRBT))/p
#naiveVARlamCN = np.var(XtildeTlamCN.transpose().dot(beta))
naiveVARlamCN = np.var(lamCNhat)
VARlamCN = naiveVARlamCN - sum(BlamCNlamCN*sig2) 

lg.info(f'\n Naive VAR(lamC*C + lamN*N) = {naiveVARlamCN}\n')
lg.info(f'Adjusted VAR(lamC*C + lamN*N) = {VARlamCN}\n')

lg.info(f'Naive SDEV(lamC*C + lamN*N) = {np.sqrt(naiveVARlamCN)}\n')
lg.info(f'Adjusted SDEV(lamC*C + lamN*N) = {np.sqrt(VARlamCN)}\n')


lg.info(f'Bii estimation is done: time is {datetime.datetime.now()}\n')


lg.info('\n\n **********Compute the remaining covariances********** \n')
      
Blam0lamCN = sum(np.transpose(XSinvA1Tlam0RBT) * np.transpose(XSinvA1TlamCNRBT))/p
BlamCNwFE = sum(np.transpose(XSinvA1TlamCNRBT) * np.transpose(XSinvA1TwFERBT))/p

naiveCOVlam0lamCN = naiveCOVlam0lamCN[0,1]
COVlam0lamCN = naiveCOVlam0lamCN - sum(Blam0lamCN*sig2)

naiveCOVlamCNwFE = naiveCOVlamCNwFE[0,1]
COVlamCNwFE = naiveCOVlamCNwFE - sum(BlamCNwFE*sig2)

lg.info(f'\n Naive COVlam0lamCN = {naiveCOVlam0lamCN}\n')
lg.info(f'Adjusted COVlam0lamCN = {COVlam0lamCN}\n')

lg.info(f'Naive COVlamCNwFE = {naiveCOVlamCNwFE}\n')
lg.info(f'Adjusted COVlamCNwFE = {COVlamCNwFE}\n')

lg.info(f'Naive CORRlam0lamCN = {naiveCOVlam0lamCN / (np.sqrt(naiveVARlam0)*np.sqrt(naiveVARlamCN))}\n')
lg.info(f'Adjusted CORRlam0lamCN = {COVlam0lamCN / (np.sqrt(VARlam0)*np.sqrt(VARlamCN))}\n')

lg.info(f'Naive CORRlamCNwFE = {naiveCOVlamCNwFE / (np.sqrt(naiveVARlamCN)*np.sqrt(naiveVARwFE))}\n')
lg.info(f'Adjusted CORRlamCNwFE = {COVlamCNwFE / (np.sqrt(VARlamCN)*np.sqrt(VARwFE))}\n')



##########################
## Summarize the results once again!
##########################

lg.info(f'number sig2 negative = {np.sum(sig2 < 0)}')
lg.info(f'number sig2 positive = {np.sum(sig2 >= 0)}')
lg.info(f'number Pii>=1 = {np.sum(P >=1)}')
lg.info(f'max Pii = {max(P)}\n')


lg.info('\n\n\n\n******VAR-COV MATRIX******\n')

# VAR
lg.info(f'Naive VARwFE = {naiveVARwFE}')
lg.info(f'Adjusted VARwFE = {VARwFE}')

lg.info(f'Naive VARlam0 = {naiveVARlam0}')
lg.info(f'Adjusted VARlam0 = {VARlam0}')

lg.info(f'Naive VARlamC = {naiveVARlamC}')
lg.info(f'Adjusted VARlamC = {VARlamC}')

lg.info(f'Naive VARlamN = {naiveVARlamN}')
lg.info(f'Adjusted VARlamN = {VARlamN}')

# COV
lg.info(f'Naive COVlam0lamC = {naiveCOVlam0lamC}')
lg.info(f'Adjusted COVlam0lamC = {COVlam0lamC}\n')

lg.info(f'Naive COVlamNlam0 = {naiveCOVlamNlam0}')
lg.info(f'Adjusted COVlamNlam0 = {COVlamNlam0}\n')

lg.info(f'Naive COVlamNlamC = {naiveCOVlamNlamC}')
lg.info(f'Adjusted COVlamNlamC = {COVlamNlamC}\n')

lg.info(f'\n Naive COVlam0wFE = {naiveCOVlam0wFE}\n')
lg.info(f'Adjusted COVlam0wFE = {COVlam0wFE}\n')

lg.info(f'Naive COVlamCwFE = {naiveCOVlamCwFE}\n')
lg.info(f'Adjusted COVlamCwFE = {COVlamCwFE}\n')

lg.info(f'Naive COVlamNwFE = {naiveCOVlamNwFE}\n')
lg.info(f'Adjusted COVlamNwFE = {COVlamNwFE}\n')


# Wage Variance
lg.info(f'Naive VAR(lamC*C + lamN*N) = {naiveVARlamCN}')
lg.info(f'Adjusted VAR(lamC*C + lamN*N) = {VARlamCN}\n')

lg.info(f'Naive COVlam0lamCN = {naiveCOVlam0lamCN}')
lg.info(f'Adjusted COVlam0lamCN = {COVlam0lamCN}\n')

lg.info(f'Naive COVlamCNwFE = {naiveCOVlamCNwFE}\n')
lg.info(f'Adjusted COVlamCNwFE = {COVlamCNwFE}\n')

lg.info(f'total log wage variance = {np.var(Y)}\n')


lg.info('\n\n\n\n******SDEV AND CORRELATIONS******\n')

# SDEV
lg.info(f'Naive SDEVwFE = {np.sqrt(naiveVARwFE)}')
lg.info(f'Adjusted SDEVwFE = {np.sqrt(VARwFE)}\n')

lg.info(f'Naive SDEVlam0 = {np.sqrt(naiveVARlam0)}')
lg.info(f'Adjusted SDEVlam0 = {np.sqrt(VARlam0)}\n')

lg.info(f'Naive SDEVlamC = {np.sqrt(naiveVARlamC)}')
lg.info(f'Adjusted SDEVlamC = {np.sqrt(VARlamC)}\n')

lg.info(f'Naive SDEVlamN = {np.sqrt(naiveVARlamN)}')
lg.info(f'Adjusted SDEVlamN = {np.sqrt(VARlamN)}\n')


# CORR
lg.info(f'Naive CORRlam0lamC = {naiveCOVlam0lamC / (np.sqrt(naiveVARlam0)*np.sqrt(naiveVARlamC))}')
lg.info(f'Adjusted CORRlam0lamC = {COVlam0lamC / (np.sqrt(VARlam0)*np.sqrt(VARlamC))}\n')

lg.info(f'Naive CORRlamNlam0 = {naiveCOVlamNlam0 / (np.sqrt(naiveVARlamN)*np.sqrt(naiveVARlam0))}')
lg.info(f'Adjusted CORRlamNlam0 = {COVlamNlam0 / (np.sqrt(VARlamN)*np.sqrt(VARlam0))}\n')

lg.info(f'Naive CORRlamNlamC = {naiveCOVlamNlamC / (np.sqrt(naiveVARlamN)*np.sqrt(naiveVARlamC))}')
lg.info(f'Adjusted CORRlamNlamC = {COVlamNlamC / (np.sqrt(VARlamN)*np.sqrt(VARlamC))}\n')

lg.info(f'Naive CORRlam0wFE = {naiveCOVlam0wFE / (np.sqrt(naiveVARlam0)*np.sqrt(naiveVARwFE))}\n')
lg.info(f'Adjusted CORRlam0wFE = {COVlam0wFE / (np.sqrt(VARlam0)*np.sqrt(VARwFE))}\n')

lg.info(f'Naive CORRlamCwFE = {naiveCOVlamCwFE / (np.sqrt(naiveVARlamC)*np.sqrt(naiveVARwFE))}\n')
lg.info(f'Adjusted CORRlamCwFE = {COVlamCwFE / (np.sqrt(VARlamC)*np.sqrt(VARwFE))}\n')

lg.info(f'Naive CORRlamNwFE = {naiveCOVlamNwFE / (np.sqrt(naiveVARlamN)*np.sqrt(naiveVARwFE))}\n')
lg.info(f'Adjusted CORRlamNwFE = {COVlamNwFE / (np.sqrt(VARlamN)*np.sqrt(VARwFE))}\n')


# Wage dispersion
lg.info(f'Naive SDEV(lamC*C) = {np.sqrt(naiveVARlamCC)}\n')
lg.info(f'Adjusted SDEV(lamC*C) = {np.sqrt(VARlamCC)}\n')

lg.info(f'Naive SDEV(lamN*N) = {np.sqrt(naiveVARlamNN)}\n')
lg.info(f'Adjusted SDEV(lamN*N) = {np.sqrt(VARlamNN)}\n')

lg.info(f'Naive SDEV(lamC*C + lamN*N) = {np.sqrt(naiveVARlamCN)}')
lg.info(f'Adjusted SDEV(lamC*C + lamN*N) = {np.sqrt(VARlamCN)}\n')


lg.info(f'program ENDED: time is {datetime.datetime.now()}\n')

lg.shutdown()





