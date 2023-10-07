extends Control




var Water := 100
var Energy :=100
var Food :=100
var Mat :=100
var Pop :=50


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HBoxWater/Water/WaterVal.text = str(Water)
	$HBoxEnergy/Energy/EnergyVal.text = str(Energy)
	$HBoxFood/Food/FoodVal.text = str(Food)
	$HBoxMat/Mat/MatVal.text = str(Mat)
	$HBoxPop/Pop/PopVal.text = str(Pop)
	




