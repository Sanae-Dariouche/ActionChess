extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var saved_scene
var R1=["r","n","b","q","k","b","n","r"]
var R2=["p","p","p","p","p","p","p","p"]
var R3=["-","-","-","-","-","-","-","-"]
var R4=["-","-","-","-","-","-","-","-"]
var R5=["-","-","-","-","-","-","-","-"]
var R6=["-","-","-","-","-","-","-","-"]
var R7=["P","P","P","P","P","P","P","P"]
var R8=["R","N","B","Q","K","B","N","R"]

var b=[R1,R2,R3,R4,R5,R6,R7,R8]


func switch_scene( temp_scene ):
    # save scene and remove it from the tree
    saved_scene = get_tree().get_current_scene()
    get_tree().get_root().remove_child( saved_scene )
    # instance and add temporary scene as current scene
    var new_scene = load(temp_scene).instance()
    get_tree().get_root().add_child( new_scene )
    get_tree().set_current_scene( new_scene )

func load_scene():
    if saved_scene != null:
        # free temporary scene
        get_tree().get_current_scene().queue_free()
        # add saved scene back to the tree
        get_tree().get_root().add_child(saved_scene)
        saved_scene = null