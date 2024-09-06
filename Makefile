All:Send_Alert65BPap Receive_Alert65BPap SendBCM2835Pap ReceiveBCM2835Pap

Receive_Alert65BPap:Receive_Alert65BPap.c
	cc -o Receive_Alert65BPap Receive_Alert65BPap.c -lpigpio -lrt

Send_Alert65BPap: Send_Alert65BPap.c
	cc -o Send_Alert65BPap Send_Alert65BPap.c -lpigpio -lrt

SendBCM2835Pap:SendBCM2835Pap.c
	cc -o SendBCM2835Pap SendBCM2835Pap.c -lrt -lbcm2835

ReceiveBCM2835Pap:ReceiveBCM2835Pap.c
	cc -o ReceiveBCM2835Pap ReceiveBCM2835Pap.c -lrt -lbcm2835

clean::
	rm Send_Alert65BPap Receive_Alert65BPap SendBCM2835Pap ReceiveBCM2835Pap
