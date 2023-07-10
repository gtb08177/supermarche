Ryan McNulty
200844047
Shopping App Submission 2013
############################
The implementation used allows two kinds of lists
	1 - Template lists. Lists used to maintain regular lists such as 'Weekly' or 'Monthly'
	2 - Purchased lists. Lists generated from Template Lists or created from scratch.

NB both list types (template and purchased) can be editted at any point.


###### Configuration Details #######
This applications matches upto and including configuration 'Auto-removal of purchased items' & also 'Managing user preferences' meaning the possibility of up to 90 marks. 
The application will also be demonstrated to Dr. Terzis on an iPhone device, 											  
allowing the addition of the 20 additional marks for demonstrating any configuration on an iOS device.	


##Basic Config
	- Both tempalte lists and purchased lists are persistently stored.
	- Both allow the adding of items and their quantities.
	- Purchased lists maintain if the item has been purchased.
	
	
##Track weekly shopping
	- Both template and purchased sections allow multiple lists to be stored.
	- Purchased lists section allows the user to create a list from scratch or start from a previous template list. 
	- Both lists allow the removal of existing items.
	- Items can be added to both lists after they have been created.
	- Quantities of items can be changed in both lists.
	- Purchased lists are stored persistently as their own object i.e. differently from Template Lists.
	- All date/time stamps are stored for each list object and be seen in the subtitle of each cell.


##Tracking Shopping Cost
	- Purchased list items allow their price to be input upon selecting the item from the lis, via a number pad.
	- The current total of all purchased list items is at the top of each list.
	- Each item on the list maintains its original quantity and the quantity that has actually been purchased (different stored integers).
	- The quantity is edited using the stepper within the item view controller.
	- These are stored differently from the original lists.
	
	
##Shopping Memory
	- If items from the prev list have not been purchased, these are copied to the new list being created.
	- If items from the prev list HAVE been purchased, if their purchased quantity is less than the intended, the item is copied with the difference.
		
		
##Price Comparison
	- Upon enabling purchased, or updating the price while purchased has been enabled, a user dialog will appear stating whether it cost more or less.
	- The alert dialog requires the user to dismiss it, meaning the user will not miss the information.
	
	
##Autoremoval
	- When an item has been purchased and the user returns to the list view, the item is removed however still kept in storage.
	- The auto generated price still calculates correctly.
	
	
##Managing user preferences
	- Upon opening the application, there is a settings button in the top right that allow the enabling and disable of options.
	- These options include:
		- Shopping Memory
		- Price comparison
		- Auto-removal


###########################################################################################################################
The application will also be demonstrated to Dr. Terzis on an iPhone device, 											  #
allowing the addition of the 20 additional marks for demonstrating any configuration on an iOS device.					  #
																														  #
Further to this, it has the following additional functionality that was not covered by any of the configurations achieved:#
1 - The ability to delete both types of lists.							   												  #
###########################################################################################################################