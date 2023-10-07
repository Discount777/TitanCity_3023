extends Node2D

@onready var tileMap: TileMap = $tilemap

@onready var metalCount = int($Control/HBoxMat/Mat/MatVal.text)
@onready var waterCount = int($Control/HBoxWater/Water/WaterVal.text)
@onready var energyCount = int($Control/HBoxEnergy/Energy/EnergyVal.text)
@onready var popCount = int($Control/HBoxPop/Pop/PopVal.text)
@onready var foodCount = int($Control/HBoxFood/Food/FoodVal.text)


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
					buildingModes.mats:
						if (mousePositionTileType == "metal"):
							tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(1,0))
						else:
							tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(2,0))
					buildingModes.energy:
						tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(3,0))
					buildingModes.water:
						tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(4,0))
					buildingModes.population:
						tileMap.set_cell(buildingLayer, MapCoordinates, 1, Vector2i(5,0))
						
						
	
	
	
	var data = $tilemap.get_cell_tile_data(tileLayer,MapCoordinates)
	if data:
		var resType = data.get_custom_data('tileType')
		#print(resType)
#	else:
		#print("No tile data at ", MapCoordinates)
		
		
		



func _on_ResourceTimer_timeout():
	for cell in tileMap.get_used_cells(buildingLayer):
		var tileData = tileMap.get_cell_tile_data(buildingLayer, cell)
		if tileData:
			var buildingType = tileData.get_custom_data("buildingType")
			var tileType = tileData.get_custom_data('tileType')
			if buildingType == 'matsMetal' and tileType == 'metal':
				metalCount += 150
			if buildingType == 'food' and tileType == 'x':
				foodCount += 150
			if buildingType == 'energy' and tileType == 'oil':
				energyCount += 150
			if buildingType == 'water' and tileType == 'ice':
				waterCount += 150
				
			elif buildingType == 'water' and tileType != 'ice':
				waterCount +=100
			elif buildingType == 'matsMetal' and tileType != 'metal':
				metalCount +=100
	$Control/HBoxWater/Water/WaterVal.text = str(waterCount)
	$Control/HBoxEnergy/Energy/EnergyVal.text = str(energyCount)
	$Control/HBoxFood/Food/FoodVal.text = str(foodCount)
	$Control/HBoxMat/Mat/MatVal.text = str(metalCount)
	$Control/HBoxPop/Pop/PopVal.text = str(popCount)
	
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












