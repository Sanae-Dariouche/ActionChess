extends Node
#Capital letters: white pieces

var kingPositionWhite=0
var kingPositionBlack=0

onready var autoload = get_node("/root/autoload")
onready var chessBoard = autoload.b


var globalDepth=4
func possible_moves():
	var list=""
	for i in range(64):
		if((chessBoard[i/8][i%8])=="P"):
			list+=possibleP(i)
		elif(chessBoard[i/8][i%8]=="R"):
			list+=possibleR(i)
		elif(chessBoard[i/8][i%8]=="N"):
			list+=possibleN(i)
		elif(chessBoard[i/8][i%8]=="Q"):
            list+=possibleQ(i)
		elif(chessBoard[i/8][i%8]=="K"):
			list+=possibleK(i)
		elif(chessBoard[i/8][i%8]=="B"):
			list+=possibleB(i)
	return list

func possibleP(i):
	var list=""
	var temp
	var ligne=i/8
	var colonne=i%8
	for j in range (-1,2,2):
		#capture
		if(ligne-1>=0 and ligne-1<8 and colonne+j>=0 and colonne+j<8):
			temp=chessBoard[ligne-1][colonne+j]
			if (temp=="p" or temp=="r" or temp=="b" or temp=="n" or temp=="k" or temp=="q") and i>=16:
				chessBoard[ligne][colonne]="-"
				chessBoard[ligne-1][colonne+j]="P"
				if(kingSafe()):
					list=list+str(ligne)+str(colonne)+str(ligne-1)+str(colonne+j)+temp
				chessBoard[ligne][colonne]="P"
				chessBoard[ligne-1][colonne+j]=temp
		#promotion et capture
		if(ligne-1>=0 and ligne-1<8 and colonne+j>=0 and colonne+j<8):
			temp=chessBoard[ligne-1][colonne+j]
			if (temp=="p" or temp=="r" or temp=="b" or temp=="n" or temp=="k" or temp=="q") and i<16:
				var tab=["Q","R","B","K"]
				for k in range(0,4):
					temp=chessBoard[ligne-1][colonne+j]
					chessBoard[ligne][colonne]="-"
					chessBoard[ligne-1][colonne+j]=tab[k]
					if kingSafe():
						#colonne1,colonne2,capturedpiece,newpieces,P
						list=list+str(colonne)+str(colonne+j)+temp+tab[k]+"P"
					chessBoard[ligne][colonne]="P"
					chessBoard[ligne-1][colonne+j]=temp
	#move one up

	if(ligne-1>=0 and ligne-1<8 ):
		temp=chessBoard[ligne-1][colonne]
		if temp=="-" and i>=16:
			temp=chessBoard[ligne-1][colonne]
			chessBoard[ligne][colonne]="-"
			chessBoard[ligne-1][colonne]="P"
			if kingSafe():
				list=list+str(ligne)+str(colonne)+str(ligne-1)+str(colonne)+temp
			chessBoard[ligne][colonne]="P"
			chessBoard[ligne-1][colonne]=temp
	#promotion sans capture
	if(ligne-1>=0 and ligne-1<8):
		temp=chessBoard[ligne-1][colonne]
		if(temp=="-" and i<16):
			var tab=["Q","R","B","K"]
			for k in range(0,4):
				chessBoard[ligne][colonne]="-"
				chessBoard[ligne-1][colonne]=tab[k]
				if(kingSafe()):
					#colonne1,colonne2,capturedpiece,newpieces,P
					list=list+str(colonne)+str(colonne)+temp+tab[k]+"P"
				chessBoard[ligne][colonne]="P"
				chessBoard[ligne-1][colonne]=temp
	#move two up
	if(ligne-1>=0 and ligne-1<8 and ligne-2>=0 and ligne-2<8):
		temp=chessBoard[ligne-1][colonne]
		var temp2=chessBoard[ligne-2][colonne]
		if(temp=="-" and temp2=="-" and i>=48):
			chessBoard[ligne][colonne]="-"
			chessBoard[ligne-2][colonne]="P"
			if(kingSafe()):
				list=list+str(ligne)+str(colonne)+str(ligne-2)+str(colonne)+temp2;
			chessBoard[ligne][colonne]="P"
			chessBoard[ligne-2][colonne]=temp2
	return list
func possibleR(i):
	var list=""
	var temp
	var inc=1
	var ligne=i/8
	var colonne=i%8
	for j in range(-1,2,2):
		if(colonne+inc*j>=0 and colonne+inc*j<8):
			while(chessBoard[ligne][colonne+inc*j]=="-"):
				temp=chessBoard[ligne][colonne+inc*j]
				chessBoard[ligne][colonne]="-"
				chessBoard[ligne][colonne+inc*j]="R"
				if(kingSafe()):
					list=str(list)+str(ligne)+str(colonne)+str(ligne)+str(colonne+inc*j)+str(temp)
				chessBoard[ligne][colonne]="R"
				chessBoard[ligne][colonne+inc*j]=temp
				inc+=1
				if colonne+inc*j>=8 or colonne+inc*j<0:
					break
			if colonne+inc*j<8 and colonne+inc*j>=0:
				temp=chessBoard[ligne][colonne+inc*j]
				if temp=="p" or temp=="n" or temp=="k" or temp=="q" or temp=="r" or temp=="b":
					chessBoard[ligne][colonne]="-"
					chessBoard[ligne][colonne+inc*j]="R"
					if( kingSafe()):
						list=str(list)+str(ligne)+str(colonne)+str(ligne)+str(colonne+inc*j)+str(temp)
					chessBoard[ligne][colonne]="R"
					chessBoard[ligne][colonne+inc*j]=temp
		inc=1
	for j in range(-1,2,2):
		if(ligne+inc*j>=0 and ligne+inc*j<8):
			while(chessBoard[ligne+inc*j][colonne]=="-"):
				temp=chessBoard[ligne+inc*j][colonne]
				chessBoard[ligne][colonne]="-"
				chessBoard[ligne+inc*j][colonne]="R"
				if(kingSafe()):
					list=str(list)+str(ligne)+str(colonne)+str(ligne+inc*j)+str(colonne)+str(temp)
				chessBoard[ligne][colonne]="R"
				chessBoard[ligne+inc*j][colonne]=temp
				inc+=1
				if ligne+inc*j>=8 or ligne+inc*j<0:
					break
			if ligne+inc*j<8 and ligne+inc*j>=0:
				temp=chessBoard[ligne+inc*j][colonne]
				if temp=="p" or temp=="n" or temp=="k" or temp=="q" or temp=="r" or temp=="b":
					chessBoard[ligne][colonne]="-"
					chessBoard[ligne+inc*j][colonne]="R"
					if( kingSafe()):
						list=str(list)+str(ligne)+str(colonne)+str(ligne+inc*j)+str(colonne)+str(temp)
					chessBoard[ligne][colonne]="R"
					chessBoard[ligne+inc*j][colonne]=temp
					
		inc=1
	return list
func possibleN(i):
	var list=""
	var temp
	var ligne=i/8
	var colonne=i%8
	for j in range(-1,2,2):
		for k in range(-1,2,2):
			if(ligne+j>=0 and ligne+j<8 and colonne+k*2>=0 and colonne+k*2<8):
				temp=chessBoard[ligne+j][colonne+k*2]
				if temp=="-" or temp=="p" or temp=="n" or temp=="r" or temp=="k" or temp=="q" or temp=="b":
					chessBoard[ligne][colonne]="-"
					chessBoard[ligne+j][colonne+k*2]="N"
					if (kingSafe()):
						list=list+str(ligne)+str(colonne)+str(ligne+j)+str(colonne+k*2)+temp
					chessBoard[ligne][colonne]="N"
					chessBoard[ligne+j][colonne+k*2]=temp
			if(ligne+j*2>=0 and ligne+j*2<8 and colonne+k>=0 and colonne+k<8):
				temp=chessBoard[ligne+j*2][colonne+k]
				if temp=="-" or temp=="p" or temp=="n" or temp=="r" or temp=="k" or temp=="q" or temp=="b":
					chessBoard[ligne][colonne]="-"
					chessBoard[ligne+j*2][colonne+k]="N"
					if (kingSafe()):
						list=list+str(ligne)+str(colonne)+str(ligne+j*2)+str(colonne+k)+temp
					chessBoard[ligne][colonne]="N"
					chessBoard[ligne+j*2][colonne+k]=temp
	return list
func possibleQ(i):
	var list=""
	var temp
	var inc=1
	var ligne=i/8
	var colonne=i%8
	for j in range(-1,2):
		for k in range (-1,2):
			if(ligne+inc*j>=0 and ligne+inc*j<8 and colonne+inc*k>=0 and colonne+inc*k<8):
				while(chessBoard[ligne+inc*j][colonne+inc*k]=="-"):
					temp=chessBoard[ligne+inc*j][colonne+inc*k]
					chessBoard[ligne][colonne]="-"
					chessBoard[ligne+inc*j][colonne+inc*k]="Q"
					if (kingSafe()):
						list=str(list)+str(ligne)+str(colonne)+str(ligne+inc*j)+str(colonne+inc*k)+str(temp)
					chessBoard[ligne][colonne]="Q"
					chessBoard[ligne+inc*j][colonne+inc*k]=temp
					inc+=1
					if (ligne+inc*j<0 or ligne+inc*j>=8 or colonne+inc*k<0 or colonne+inc*k>=8):
						break
			if(ligne+inc*j>=0 and ligne+inc*j<8 and colonne+inc*k>=0 and colonne+inc*k<8):
				temp=chessBoard[ligne+inc*j][colonne+inc*k]
				if temp=="p" or temp=="k" or temp=="q" or temp=="n" or temp=="b" or temp=="r":
					chessBoard[ligne][colonne]="-"
					chessBoard[ligne+inc*j][colonne+inc*k]="Q"
					if( kingSafe()):
						list=str(list)+str(ligne)+str(colonne)+str(ligne+inc*j)+str(colonne+inc*k)+str(temp)
					chessBoard[ligne][colonne]="Q"
					chessBoard[ligne+inc*j][colonne+inc*k]=temp
			inc=1
	return list
	
func possibleK(i):
	var list=""
	var temp
	var ligne=i/8
	var colonne=i%8
	for j in range(9):
		if j!=4:
			if ligne-1+j/3>=0 and ligne-1+j/3<8 and colonne-1+j%3<8 and colonne-1+j%3>=0:
				temp=chessBoard[ligne-1+j/3][colonne-1+j%3]
				if temp=="p" or temp=="n" or temp=="r" or temp=="b" or temp=="q" or temp=="k" or temp=="-":
					chessBoard[ligne][colonne]="-"
					chessBoard[ligne-1+j/3][colonne-1+j%3]="K"
					var kingTemp=kingPositionWhite
					kingPositionWhite=i+(j/3)*8+j%3-9
					if kingSafe():
						list=str(list)+str(ligne)+str(colonne)+str(ligne-1+j/3)+str(colonne-1+j%3)+str(temp)
						#print(list)
					chessBoard[ligne][colonne]="K"
					chessBoard[ligne-1+j/3][colonne-1+j%3]=temp
					kingPositionWhite=kingTemp
	#need to add castling later
	return list
    
    
func possibleB(i):
	var list=""
	var temp
	var inc=1
	var ligne=i/8
	var colonne=i%8
	for j in range(-1,2,2):
		for k in range (-1,2,2):
			if ligne+inc*j>=0 and ligne+inc*j<8 and colonne+inc*k>=0 and colonne+inc*k<8:
				while(chessBoard[ligne+inc*j][colonne+inc*k]=="-"):
						temp=chessBoard[ligne+inc*j][colonne+inc*k]
						chessBoard[ligne][colonne]="-"
						chessBoard[ligne+inc*j][colonne+inc*k]="B"
						if (kingSafe()):
							list=str(list)+str(ligne)+str(colonne)+str(ligne+inc*j)+str(colonne+inc*k)+str(temp)
						chessBoard[ligne][colonne]="B"
						chessBoard[ligne+inc*j][colonne+inc*k]=temp
						inc+=1
						if (ligne+inc*j<0 or ligne+inc*j>=8 or colonne+inc*k<0 or colonne+inc*k>=8):
							break
				if(ligne+inc*j>=0 and ligne+inc*j<8 and colonne+inc*k>=0 and colonne+inc*k<8):
					temp=chessBoard[ligne+inc*j][colonne+inc*k]
					if temp=="p" or temp=="k" or temp=="q" or temp=="n" or temp=="b" or temp=="r":
						chessBoard[ligne][colonne]="-"
						chessBoard[ligne+inc*j][colonne+inc*k]="B"
						if( kingSafe()):
							list=str(list)+str(ligne)+str(colonne)+str(ligne+inc*j)+str(colonne+inc*k)+str(temp)
						chessBoard[ligne][colonne]="B"
						chessBoard[ligne+inc*j][colonne+inc*k]=temp
			inc=1
	return list
	
func kingSafe():
	#diagonal (bishop/queen)
	var inc=1
	var temp
	for j in range (-1,2,2):
		for k in range (-1,2,2):
			if(kingPositionWhite/8+inc*j>=0 and kingPositionWhite/8+inc*j<8 and kingPositionWhite%8+inc*k>=0 and kingPositionWhite%8+inc*k<8):
				temp=chessBoard[kingPositionWhite/8+inc*j][kingPositionWhite%8+inc*k]
				while(temp=="-"):
					inc+=1
					if(!(kingPositionWhite/8+inc*j>=0 and kingPositionWhite/8+inc*j<8 and kingPositionWhite%8+inc*k>=0 and kingPositionWhite%8+inc*k<8)):
						break;
					temp=chessBoard[kingPositionWhite/8+inc*j][kingPositionWhite%8+inc*k]
				if(temp=="b" or temp=="q"):
					return false
				inc=1

	#vertical and horizontal (rook/queen)
	for j in range(-1,2,2):
		if(kingPositionWhite%8+inc*j>=0 and kingPositionWhite%8+inc*j<8):
			temp=chessBoard[kingPositionWhite/8][kingPositionWhite%8+inc*j]
			while(temp=="-"):
				inc+=1
				if(!( kingPositionWhite%8+inc*j>=0 and kingPositionWhite%8+inc*j<8)):
					break;
				temp=chessBoard[kingPositionWhite/8][kingPositionWhite%8+inc*j]
			if(temp=="r" or temp=="q"):
				return false
			inc=1
		if(kingPositionWhite/8+inc*j>=0 and kingPositionWhite/8+inc*j<8):
			temp=chessBoard[kingPositionWhite/8+inc*j][kingPositionWhite%8]
			while(temp=="-"):
				inc+=1
				if(!( kingPositionWhite/8+inc*j>=0 and kingPositionWhite/8+inc*j<8)):
					break;
				temp=chessBoard[kingPositionWhite/8+inc*j][kingPositionWhite%8]
			if(temp=="r" or temp=="q"):
				return false
			inc=1
	
	#knights
	for j in range(-1,2,2):
		for k in range(-1,2,2):
			if(kingPositionWhite/8+j<8 and kingPositionWhite/8+j>=0 and kingPositionWhite%8+k*2>=0 and kingPositionWhite%8+k*2<8 ):
				temp=chessBoard[kingPositionWhite/8+j][kingPositionWhite%8+k*2]
				if temp=="n":
					return false
			if(kingPositionWhite/8+j*2<8 and kingPositionWhite/8+j*2>=0 and kingPositionWhite%8+k>=0 and kingPositionWhite%8+k<8 ):
				temp=chessBoard[kingPositionWhite/8+j*2][kingPositionWhite%8+k]
				if temp=="n":
					return false
	
	#pawns
	if kingPositionWhite>=16:
		if kingPositionWhite/8-1<8 and kingPositionWhite/8-1>=0 and kingPositionWhite%8-1>=0 and kingPositionWhite%8-1<8 :
			temp=chessBoard[kingPositionWhite/8-1][kingPositionWhite%8-1]
			if temp == "p":
				return false
	#king
	for j in range(-1,2):
		for k in range(-1,2):
			if kingPositionWhite/8+j>=0 and kingPositionWhite/8+j<8 and kingPositionWhite%8+k>=0 and kingPositionWhite%8+k<8:
				temp=chessBoard[kingPositionWhite/8+j][kingPositionWhite%8+k]
				if temp=="k":
					return false

	return true

func make_move(move):
	if move[4]!="P":
		chessBoard[int(move[2])][int(move[3])]=chessBoard[int(move[0])][int(move[1])]
		chessBoard[int(move[0])][int(move[1])]="-"
		if(chessBoard[int(move[2])][int(move[3])]=='K'):
			kingPositionWhite=8*int(move[2])+int(move[3])
	else:
		chessBoard[1][int(move[0])]="-"
		chessBoard[0][int(move[1])]=move[3]
		##colonne1,colonne2,capturedpiece,newpieces,P

func undo_move(move):
	if move[4]!="P":
		chessBoard[int(move[0])][int(move[1])]=chessBoard[int(move[2])][int(move[3])]
		chessBoard[int(move[2])][int(move[3])]=move[4]
		if(chessBoard[int(move[0])][int(move[1])]=='K'):
			kingPositionWhite=8*int(move[0])+int(move[1])
	else:
		chessBoard[1][int(move[0])]="P"
		chessBoard[0][int(move[1])]=move[2]
		##colonne1,colonne2,capturedpiece,newpieces,P
func alphaBeta(depth, alpha, beta, move, player):
	#return in the form of 1234b{score}
	var list=possible_moves()
	if (depth==0 or list.length()==0):
		#print(move+str(rating()*((player*2)-1)))
		return move+str(rating(list,depth)*((player*2)-1))
	player=1-player
	for i in range(0,list.length(),5):
		make_move(list.substr(i,i+5))
		flipboard()
		var returnString=alphaBeta(depth-1,alpha,beta,list.substr(i,i+5),player)
		var value=int(returnString.substr(5,returnString.length()))
		flipboard()
		undo_move(list.substr(i,i+5))
		if(player == 0):
			if(value<=beta):
				beta=value
				if depth==globalDepth:
					move=returnString.substr(0,5)
		else:
			if(value>alpha):
				alpha=value
				if depth==globalDepth:
					move=returnString.substr(0,5)
		if alpha>=beta:
			if player==0:
				#print(move+str(beta))
				return move+str(beta)
			else:
				#print(move+str(alpha))
				return move+str(alpha)
	if player==0:
		#print(move+str(alpha))
		return move+str(beta)
	else:
		#print(move+str(alpha))
		return move+str(alpha)
		
func rating(list,depth):
	var count=0
	count+=rateAttack()
	count+=rateMoveability(list,depth)
	count+=rateMaterial()
	flipboard()
	count-=rateAttack()
	count-=rateMoveability(list,depth)
	count-=rateMaterial()
	flipboard()
	return (count+depth*50)
func rateAttack():
	var counter=0
	var tempPositionW=kingPositionWhite
	for i in range (64):
		if (chessBoard[i/8][i%8]=="P"):
			kingPositionWhite=i
			if(!kingSafe()):
				counter=counter-64
		elif(chessBoard[i/8][i%8]=="R"):
			kingPositionWhite=i
			if(!kingSafe()):
				counter=counter-500

		elif(chessBoard[i/8][i%8]=="N"):
			kingPositionWhite=i
			if(!kingSafe()):
				counter=counter-300

		elif(chessBoard[i/8][i%8]=="B"):
			kingPositionWhite=i
			if(!kingSafe()):
				counter=counter-300

		elif(chessBoard[i/8][i%8]=="Q"):
			kingPositionWhite=i
			if(!kingSafe()):
				counter=counter-900
				
	kingPositionWhite=tempPositionW
	if(!kingSafe()):
		counter=counter-200
	return counter
func rateMaterial():
	var counter=0
	for i in range (64):
		if chessBoard[i/8][i%8]=="P":
			counter+=100
		if chessBoard[i/8][i%8]=="R":
			counter+=500
		if chessBoard[i/8][i%8]=="N":
			counter+=300
		if chessBoard[i/8][i%8]=="B":
			counter+=300
		if chessBoard[i/8][i%8]=="Q":
			counter+=900
	return counter

func rateMoveability(list,depth):
	var counter=0
	if list.length()==0:
		if(!kingSafe()):
			counter=counter-200000*depth
		else:
			counter=counter-150000*depth
	return counter

	
func flipboard():
	var temp
	for i in range(32):
		var ligne=i/8;
		var colonne=i%8;
		if(chessBoard[ligne][colonne]=='P' or chessBoard[ligne][colonne]=='B' or chessBoard[ligne][colonne]=='R' or chessBoard[ligne][colonne]=='N' or chessBoard[ligne][colonne]=='Q' or chessBoard[ligne][colonne]=="K"):
			temp=chessBoard[ligne][colonne].to_lower()
		elif (chessBoard[ligne][colonne]=='p' or chessBoard[ligne][colonne]=='b' or chessBoard[ligne][colonne]=='r' or chessBoard[ligne][colonne]=='n' or chessBoard[ligne][colonne]=='q' or chessBoard[ligne][colonne]=="k" or chessBoard[ligne][colonne]=="-"):
			temp=(chessBoard[ligne][colonne]).to_upper()
		if(chessBoard[7-ligne][7-colonne]=='P' or chessBoard[7-ligne][7-colonne]=='B' or chessBoard[7-ligne][7-colonne]=='R' or chessBoard[7-ligne][7-colonne]=='N' or chessBoard[7-ligne][7-colonne]=='Q' or chessBoard[7-ligne][7-colonne]=="K" ):
			chessBoard[ligne][colonne]=(chessBoard[7-ligne][7-colonne]).to_lower()
		elif (chessBoard[7-ligne][7-colonne]=='p' or chessBoard[7-ligne][7-colonne]=='b' or chessBoard[7-ligne][7-colonne]=='r' or chessBoard[7-ligne][7-colonne]=='n' or chessBoard[7-ligne][7-colonne]=='q' or chessBoard[7-ligne][7-colonne]=="k" or chessBoard[7-ligne][7-colonne]=="-"):
			chessBoard[ligne][colonne]=(chessBoard[7-ligne][7-colonne]).to_upper()
		chessBoard[7-ligne][7-colonne]=temp
	var kingTemp=kingPositionWhite
	kingPositionWhite=63-kingPositionBlack
	kingPositionBlack=63-kingTemp

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	while (!("K"==chessBoard[kingPositionWhite/8][kingPositionWhite%8])):
		kingPositionWhite+=1
	while (!("k"==chessBoard[kingPositionBlack/8][kingPositionBlack%8])):
		kingPositionBlack+=1
	autoload.b = chessBoard
	