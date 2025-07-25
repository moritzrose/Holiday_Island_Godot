extends Node

# parameter
const H_TILES := 10
const V_TILES := 10
const MIN_HEIGHT := 0
const MAX_HEIGHT := 5
const DOWN_PROB : Array = [0.00, 0.10, 0.35, 0.45, 0.5, 0.80] # probabilites to go higher depending on the current height
const UP_PROB   : Array = [0.70, 0.65, 0.55, 0.45, 0.25, 0.00] # probabilites to go lower depending on the current height

func _ready():
	var H = generate_binary_corner_heightmap(H_TILES, V_TILES)
	for row in H:
		print(row)
#    print_corner_grid(H)
#    var patterns = extract_tile_patterns(H)
#    print_tile_patterns(patterns)
	
func generate_binary_corner_heightmap(h_tiles: int, v_tiles: int) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# corner-grid-dimensions:
	var h_corners := h_tiles + 1
	var v_corners := v_tiles + 1

	# initialize heightmap values with -1 for safety and debugging purposes
	var H: Array = []
	for v in range(v_corners): # for v = 0; v < v_corners; v++
		H.append([])
		for h in range(h_corners):
			H[v].append(-1)
			
			
	for v in range(v_corners):
		for h in range(h_corners):
			var neighbours :Array = []

			# adjust to neighbours, upper left, upper right, bottom right, bottom left - depending on what is already set
			if h > 0 and H[v][h-1] != -1:      neighbours.append(H[v][h-1]) # set left to neighbours right if existend
			if v > 0 and H[v-1][h] != -1:      neighbours.append(H[v-1][h]) # set upper to neighbours lower if existend

			var level := 0 # initialize height with 0
			
			# not dependent from other corners, set value random
			if neighbours.is_empty():
				level = rng.randi_range(0, MAX_HEIGHT)
			else:
				# dependent from other corners, using value# to mark different calculation steps
				var sum_height := 0
				for height in neighbours:
					sum_height += height
				
				# current average height as 0 1 2 3 ... sorry for the type mess, feel free to optimize
				var avg_height := float(sum_height/neighbours.size())
				var level1 := int(round(avg_height))

				# making sure there are no height differences > 1 between corners
				var lower := 0
				var upper := MAX_HEIGHT
				for i in neighbours:
					lower = max(lower, i - 1)
					upper = min(upper, i + 1)
				var level2 = clamp(level1, lower, upper)

				# calculate height progression based on current average height
				var propability_down :float = DOWN_PROB[min(level2, DOWN_PROB.size() - 1)]
				var propability_up :float = UP_PROB[min(level2, UP_PROB.size() - 1)]
				
				var level3 :int = level2
				if rng.randf() < propability_down:
					level3 -= 1
				elif rng.randf() < propability_up:
					level3 += 1
					
				# making sure there are no height differences > 1 between corners
				level = clamp(level3, lower, upper)
				
			H[v][h] = level

	return H
