extends Node2D
#Capital letters: white pieces
var lien=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
onready var autoload = get_node("/root/autoload")
onready var chessBoard = autoload.b
onready var AI = get_node("AI")
var piece_selected = false
var piece
var pos_init


#var first_click=false
var board_pos
var turn_white = true
onready var board = get_node("board")
onready var white_pieces= get_node("white")
onready var black_pieces= get_node("black")


var pieces
var enemy
var mapwhite =["B","K","N","P","Q","R"]
var mapblack =["b","k","n","p","q","r"]
func _ready():
	set_process_input(true)
	set_fixed_process(true)
	for i in range (64) :
		lien[i]=[i/8,i%8]
func _fixed_process(delta):
	if turn_white:
		var move = AI.possible_moves().substr(0,5)
		AI.make_move(move)
		print(move)
		make_piece_move(move)
		print(chessBoard)
		turn_white=false
		
func make_piece_move(move):

	var lacase = int(move[0])*8+int(move[1])
	var pos = board.map_to_world(board.get_used_cells_by_id(lacase)[0])
	var piece = white_pieces.world_to_map(pos)
	var temp = white_pieces.get_cellv(piece)
	white_pieces.set_cellv(piece,-1)
	lacase = int(move[2])*8+int(move[3])
	pos = board.map_to_world(board.get_used_cells_by_id(lacase)[0])
	piece = white_pieces.world_to_map(pos)
	white_pieces.set_cellv(piece,temp)
	if move[4]!='-':
		autoload.switch_scene("res://main.tscn")
		var bpiece = black_pieces.world_to_map(pos)
		black_pieces.set_cellv(bpiece,-1)
	
func _input(event):
	#selection de la piece a bouger
	if event.is_action_pressed("mouse") and !piece_selected and black_pieces :

		pieces=black_pieces
        
        #getting the piece pos
		pos_init = print_pos(pieces)
        #getting the piece tile type
		piece = pieces.get_cellv(pos_init)
		print(piece)
        #getting the board tile type
		board_pos = board.get_cellv(pos_init)
		print(board_pos)
		if piece!=-1:
			piece_selected=true

	#mouvement de la piece
	elif event.is_action_pressed("mouse") and piece_selected:
		#getting the pos chosen to move the peice
		var pos_selected=print_pos(board)
		var pos_sel_board=board.get_cellv(pos_selected)


		if turn_white:
			pieces = white_pieces
			enemy = black_pieces
		else:
			pieces=black_pieces
			enemy=white_pieces
			# si la case est vide ou une piece adverse
			#mouvements du pion
		if(piece==3):
			pawn_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy)
		#mouvements du roi
		if(piece==1):
			king_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy)
		#mouvements de la tour
		if(piece==5):
			rook_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy)
		#mouvements du cavalier
		if(piece==2):
			knight_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy)
		#mouvements de la reine
		if(piece==4):
			queen_mov(pos_sel_board, board_pos,pos_selected,pieces,enemy)
		#mouvements du fou
		if(piece==0):
			bishop_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy)

func print_pos(tiles):
	var mouse_pos = get_global_mouse_pos()
	var tile= tiles.world_to_map(mouse_pos)
	return tile

############################################################
############################################################

########################MOUVEMENT PION######################
func pawn_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy):
	print("enemy",enemy.get_cellv(pos_selected))
	if turn_white:
		if board_pos>=48 and board_pos<=55:
			if pieces.get_cellv(pos_selected)==-1 and enemy.get_cellv(pos_selected)==-1:
				if pos_sel_board==board_pos-8 or pos_sel_board==board_pos-16:
					basic_mov(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
		elif pos_sel_board==board_pos-8:
			if pieces.get_cellv(pos_selected)==-1  and enemy.get_cellv(pos_selected)==-1:
				basic_mov(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
		if pos_sel_board==board_pos-9 or pos_sel_board==board_pos-7:
			if enemy.get_cellv(pos_selected)>-1:
				print("in")
				capture(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
		else:
			pos_selected=false
	else :
		if board_pos>=8 and board_pos<=15:
			if pieces.get_cellv(pos_selected)==-1 :
				if pos_sel_board==board_pos+8 or pos_sel_board==board_pos+16:
					basic_mov(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
		elif pos_sel_board==board_pos+8:
			if pieces.get_cellv(pos_selected)==-1:
				basic_mov(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
		if pos_sel_board==board_pos+9 or pos_sel_board==board_pos+7:
			if enemy.get_cellv(pos_selected)!=-1:
				capture(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
		else:
			pos_selected=false
#########################MOUVEMENT CAVALIER###################
func knight_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy):
	if pieces.get_cellv(pos_selected)==-1:
		if pos_sel_board==board_pos+15 or pos_sel_board==board_pos+17 or pos_sel_board==board_pos+6 or pos_sel_board==board_pos+10 or pos_sel_board==board_pos-10 or pos_sel_board==board_pos-6 or pos_sel_board==board_pos-15 or pos_sel_board==board_pos-17:
			basic_mov(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
	elif enemy.get_cellv(pos_selected)!=-1:
		if pos_sel_board==board_pos+15 or pos_sel_board==board_pos+17 or pos_sel_board==board_pos+6 or pos_sel_board==board_pos+10 or pos_sel_board==board_pos-10 or pos_sel_board==board_pos-6 or pos_sel_board==board_pos-15 or pos_sel_board==board_pos-17:
			capture(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
	else:
		pos_selected=false
##########################MOUVEMENT ROI#######################
func king_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy):
	if pieces.get_cellv(pos_selected)==-1:
		if(pos_sel_board==board_pos-8 or pos_sel_board==board_pos+8 or pos_sel_board==board_pos+1 or pos_sel_board==board_pos-1 or pos_sel_board == board_pos+7 or pos_sel_board== board_pos+9 or pos_sel_board==board_pos-7 or pos_sel_board==board_pos-9 ):
			basic_mov(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
	elif enemy.get_cellv(pos_selected)!=-1:
		if(pos_sel_board==board_pos-8 or pos_sel_board==board_pos+8 or pos_sel_board==board_pos+1 or pos_sel_board==board_pos-1 or pos_sel_board == board_pos+7 or pos_sel_board== board_pos+9 or pos_sel_board==board_pos-7 or pos_sel_board==board_pos-9 ):
			capture(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
	else:
		pos_selected=false
##########################MOUVEMENTS REINE#####################
func queen_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy):
	rook_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy)
	bishop_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy)
	
##########################MOUVEMENTS FOU####################
func bishop_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy):
	var can_move=false
	var temp1=board_pos
	var temp2=board_pos
	if temp1 < pos_sel_board:
		while(temp1<pos_sel_board or temp2<pos_sel_board):
			temp1=temp1+7
			temp2=temp2+9
			if temp1==pos_sel_board or temp2==pos_sel_board:
				can_move=true
				break
	elif temp1> pos_sel_board:
		while(temp1>pos_sel_board or temp2>pos_sel_board):
			temp1=temp1-7
			temp2=temp2-9
			if temp1==pos_sel_board or temp2==pos_sel_board:
				can_move=true
				break
	if(can_move):
		if pieces.get_cellv(pos_selected)==-1:
			basic_mov(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
		elif enemy.get_cellv(pos_selected)!=-1:
			capture(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
	else:
		pos_selected=false
##########################MOUVEMENTS TOUR################################################
func rook_mov(pos_sel_board,board_pos,pos_selected,pieces,enemy):
	var can_move=false
	var temp=pos_sel_board
	
	if temp < board_pos:
		#mouvement possible
		if(board_pos-temp<8):
			can_move=true
		else:
			while(temp<board_pos):
				
				temp=temp+8
				

				if(temp==board_pos):
					can_move=true
					break
	elif temp > board_pos :
		
		if(temp-board_pos<8):
			can_move=true
		else:
			while temp > board_pos :
				temp=temp-8

				if(temp==board_pos):
					can_move=true
					break
		
	if(can_move):
		if pieces.get_cellv(pos_selected)==-1:
			basic_mov(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
		elif enemy.get_cellv(pos_selected)!=-1:
			capture(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
	else:
		pos_selected=false
func basic_mov(pos_sel_board,pos_init,pos_selected,piece,pieces, enemy):
	#remove the piece from the initial pos
	pieces.set_cellv(pos_init,-1)
	var pic=board.get_cellv(pos_init)
	#place the tile in the selected pos 
	pieces.set_cellv(pos_selected,piece)
	pic=board.get_cellv(pos_selected)
	piece_selected = false
	var pos = board.get_cellv(pos_init)
	for m in range (8) :
	    print(chessBoard[m])
	if turn_white:
		chessBoard[lien[pos_sel_board][0]][lien[pos_sel_board][1]]=mapwhite[piece]
		chessBoard[lien[pos][0]][lien[pos][1]]="-"
	else:
		chessBoard[lien[pos_sel_board][0]][lien[pos_sel_board][1]]=mapblack[piece]
		chessBoard[lien[pos][0]][lien[pos][1]]="-"
	turn_white = !turn_white
	autoload.b = chessBoard
	print(pos_sel_board)

func capture(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy):
	#save the id of the piece in the initial position
	#var tp=pieces.get_cellv(pos_init)
	#remove the attacked piece
	#var combat = load("res://main.tscn").instance()
	#print(combat)
	#get_node("/root/main_scene").add_child(combat)
	#var en = combat.get_child(4)
	#if(en.death):
	#	remove_child(combat)
	enemy.set_cellv(pos_selected,-1)
	#remove the piece from the initial pos and place it in the new position
	basic_mov(pos_sel_board,pos_init,pos_selected,piece,pieces,enemy)
	piece_selected=false
	autoload.switch_scene("res://main.tscn")
	#get_tree().change_scene("res://main.tscn")
	print("CAPTURED NIAHAAHHAHAHA")
	
