extends Node2D

@onready var tileMap: TileMap = $tilemap


@onready var metalCount = int($Control/MatCont/Mat/MatVal.text)
@onready var waterCount = int($Control/WaterCont/Water/WaterVal.text)
@onready var energyCount = int($Control/EnergyCont/Energy/EnergyVal.text)
@onready var popCount = int($Control/PopCont/Pop/PopVal.text)
@onready var foodCount = int($Control/FoodCont/Food/FoodVal.text)


enum buildingModes {food, mats, energy, water, population, none}
var currentBuildingMode = buildingModes.none

var buildingLayer = 1
var tileLayer = 0



func _ready():
	pass 


func _process(delta):
	pass

#functions to change Building modes
func _on_water_button_pressed():
	currentBuildingMode = buildingModes.water
func _on_energy_button_pressed():
	currentBuildingMode = buildingModes.energy
func _on_food_button_pressed():
	currentBuildingMode = buildingModes.food
func _on_material_button_pressed():
	currentBuildingMode = buildingModes.mats
func _on_population_button_pressed():
	currentBuildingMode = buildingModes.population

func canBePlaced(coordinates:Vector2i):
	var tileData: TileData = tileMap.get_cell_tile_data(tileLayer, coordinates)
	var CanPlaceBuilding = tileData.get_custom_data("canPlaceBuilding")
	var isThereBuildingAlready = (tileMap.get_cell_tile_data(buildingLayer, coordinates)) != null
	var isThereAdjacent = false
	for i in [Vector2i(-1,0), Vector2i(1,0), Vector2i(0,1), Vector2i(0,-1)]:
		if (tileMap.get_cell_tile_data(buildingLayer, coordinates +i)) != null:
			isThereAdjacent = true
	return CanPlaceBuilding and isThereAdjacent and not isThereBuildingAlready
	




func _input(_event):
	var MapCoordinates = tileMap.local_to_map(get_global_mouse_position())
	#print(MapCoordinates)
	var tileData: TileData = tileMap.get_cell_tile_data(tileLayer, MapCoordinates)
	if Input.is_action_just_pressed("leftMouseButton"):
		if tileData:
			var mousePositionTileType = tileData.get_custom_data("tileType")
			if canBePlaced(MapCoordinates):
				#using case of statement to firgure out which tile to place
				match currentBuildingMode:
					buildingModes.food:
						tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(0,0))
						metalCount -=20
					buildingModes.mats:
						if (mousePositionTileType == "metal"):
							tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(1,0))
							metalCount -=10
						else:
							tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(2,0))
					buildingModes.energy:
						tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(3,0))
						metalCount -=15
					buildingModes.water:
						tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(4,0))
						metalCount -=15
						
					buildingModes.population:
						tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(5,0))
						popCount += 5
						metalCount-=25
						
						
	
	
	$Control/WaterCont/Water/WaterVal.text = str(waterCount)
	$Control/EnergyCont/Energy/EnergyVal.text = str(energyCount)
	$Control/FoodCont/Food/FoodVal.text = str(foodCount)
	$Control/MatCont/Mat/MatVal.text = str(metalCount)
	$Control/PopCont/Pop/PopVal.text = str(popCount)
	
	if waterCount > 0 and energyCount > 0 and foodCount > 0 and metalCount > 0 and popCount >0:
		pass
	else:
		get_tree().change_scene_to_file("res://TitleScreen.tscn")
		
		
		



func _on_ResourceTimer_timeout():
	for cell in tileMap.get_used_cells(buildingLayer):
		var buildData = tileMap.get_cell_tile_data(buildingLayer, cell)
		var tileData = tileMap.get_cell_tile_data(tileLayer, cell)
		var matProd = 16
		var waterProd = 10
		var energyProd = 10
		var foodProd = 10
		var popProd = 2

		if tileData:
			var buildingType = buildData.get_custom_data("buildingType")
			var tileType = tileData.get_custom_data('tileType')
			print(buildingType)
			print(tileType)
			if buildingType == 'matsMetal' and tileType == 'metal':
				metalCount += matProd*1.5
			if buildingType == 'matsOil' and tileType == 'oil':
				metalCount += matProd*1.5
			if buildingType == 'water' and tileType == 'ice':
				waterCount += waterProd*1.5
			for i in [Vector2i(-1,0), Vector2i(1,0), Vector2i(0,1), Vector2i(0,-1)]:
				if (tileMap.get_cell_tile_data(tileLayer, cell +i).get_custom_data('tileType')) == 'river':
					foodCount += foodProd*1.5
			if buildingType == 'water' and tileType != 'ice':
				waterCount +=10
				energyCount -=15
			if buildingType == 'matsOil' and tileType != 'metal':
				metalCount +=16
				energyCount -=3
				waterCount -=3
			if buildingType == 'energy' and tileType != 'oil':
				energyCount += 10
				waterCount -=10
			if buildingType == 'food':
				foodCount += 10
				energyCount-=5
				waterCount -=5
			if buildingType == 'population':
				popCount += 2
				foodCount -=10
				energyCount -= 10
				waterCount -=10


	$Control/WaterCont/Water/WaterVal.text = str(waterCount)
	$Control/EnergyCont/Energy/EnergyVal.text = str(energyCount)
	$Control/FoodCont/Food/FoodVal.text = str(foodCount)
	$Control/MatCont/Mat/MatVal.text = str(metalCount)
	$Control/PopCont/Pop/PopVal.text = str(popCount)

	print(popCount, metalCount, energyCount, waterCount, foodCount)
			






#func _on_timer_timeout():
#	for i in tileMap.get_used_cells(buildingLayer):
#		var MapCoordinates = tileMap.local_to_map(i)
#		var tileData: TileData = tileMap.get_cell_tile_data(tileLayer, MapCoordinates)
#		var buildData: TileData = tileMap.get_cell_tile_data(buildingLayer, MapCoordinates)
#	#	var metalCount = int($Control/HBoxMat/Mat/MatVal.text)
#		if tileData and buildData:
#				print('123')
#				$Control/HBoxMat/Mat/MatVal.text = str(metalCount)
#				var resType = tileData.get_custom_data("tileType")
#				var buildType = buildData.get_custom_data("buildingType")
#				if resType == 'metal' and buildType == 'matsMetal':
#	#				print(resources.Water)
#	#				print(str($Control/HBoxWater/Water/WaterVal.text))
#					print(metalCount)
			

	
	
	





#var resource_generation_rate = 1
#
#func _physics_process(delta):
#	var overlapping_bodies = get_node('Area2D/CollisionPolygon2D').get_overlapping_bodies()
#	for body in overlapping_bodies:
#		if body.name == "ResourceTile":
#			resource_generation_rate = 1.5
#		else:
#			resource_generation_rate = 1
#
#func _resource_addition(delta):
#	$Control/HBoxMat/Mat/MatVal.int += resource_generation_rate * delta
#	print($Control/HBoxMat/Mat/MatVal.text)


#func _input(buildingLayer,_MouseCoordinates):
#	var MapCoordinates = tileMap.local_to_map(get_global_mouse_position())
#	print(MapCoordinates)
#	var tile_data = $tilemap.get_cell_tile_data(buildingLayer,_MouseCoordinates)
#	print(tile_data.get_custom_data('Resource_Type'))
#














func _on_ui_ready():
	pass # Replace with function body.
