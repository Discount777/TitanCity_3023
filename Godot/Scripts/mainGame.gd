extends Node2D

@onready var tileMap: TileMap = $tilemap

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

func canBePlaced(coordinates:Vector2):
	var tileData: TileData = tileMap.get_cell_tile_data(tileLayer, coordinates)
	var TileType = tileData.get_custom_data("tileType")
	var CanPlaceBuilding = tileData.get_custom_data("canPlaceBuilding")
	var isThereAdjacent = false
	for i in [Vector2(-1,1), Vector2(-1,-1), Vector2(1,1), Vector2(1,-1)]:
		if (tileMap.get_cell_tile_data(buildingLayer, coordinates +i)) != null:
			isThereAdjacent = true
	return CanPlaceBuilding and isThereAdjacent
	


func _input(event):
	var MapCoordinates = tileMap.local_to_map(get_global_mouse_position())
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















