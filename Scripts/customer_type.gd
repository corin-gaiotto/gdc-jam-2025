extends Node

class_name CustomerType

@onready var customerTemplate = preload("res://Objects/Customer.tscn") # Packed Customer Scene which will be instantiated to create customers.

# Class for a given type of customer. Contains various attributes specific to the type, which are used to generate individual customers.

@export var CustomerMenu         : Dictionary[String, MenuItem]    # Dict of available menu items

# [ATTRIBUTES]

@export var customerPatience: float             # Multiplier for time limit on order
@export var customerTip: float                  # Customer tip on top of base price
@export var customerOrder: MenuItem             # Customer's ordered dish

@export var customerTimer: float                # Total time limit for customer order
@export var totalBill: float                    # Total customer bill with tip

#[Visuals]
@export var customerTexture: SpriteFrames       # How the customer looks.

func generateCustomer() -> Customer:
	# Instantiate an individual randomized customer based on the type attributes, and return it
	var generatedCustomer : Customer = customerTemplate.instantiate()
	
	# Set attributes based on type
	generatedCustomer.orderSatisfied = false
	generatedCustomer.customerTip = randf_range(0, 1)
	generatedCustomer.customerOrder = generateCustomerOrder() # Select random Menu Item from dictionary
	print(is_instance_of(generatedCustomer.customerOrder, MenuItem))
	# Calculate any derived attributes based on the above
	#  Calculate final payment value based on customer tip
	generatedCustomer.customerTimer = generatedCustomer.customerOrder.baseTimer * customerPatience
	generatedCustomer.totalBill = generatedCustomer.customerOrder.basePrice * generatedCustomer.customerTip
	
	# If we would like to implement multiple orders per customer
	#generatedCustomer.totalBill = calculateBillNoTip(generatedCustomer.customerOrder) * (1 + generatedCustomer.customerTip)
	
	return generatedCustomer
	
func generateCustomerOrder():
	print("[customergen]", CustomerMenu)
	# Choose a random order combination from menu items
	var choiceList = []
	for k in CustomerMenu.keys():
		choiceList.append((CustomerMenu[k]))
		
	# If we would like to implement multiiple orders per customer
	#var orderLengths = [1, 2, 3]                                   # Possible number of items for one order, can change later
	#var chosenOrderLength = orderLengths.pick_random()             # Choose a random order length for a customer
	
	var chosenOrder = []                                            # Customer final order
	
	# If we would like to implement multiiple orders per customer
	#for k in chosenOrderLength:
	print("[customergen]",choiceList)
	chosenOrder= choiceList.pick_random()
			
	return chosenOrder
	
# If we would like to implement multiiple orders per customer	
#func calculateBillNoTip(generatedCustomerOrder: Array[MenuItem]):
#	#calculate total order bill with no tip
#	var billNoTip = 0;
#	for k in generatedCustomerOrder:
#		billNoTip += generatedCustomerOrder[k].basePrice
#	return billNoTip
