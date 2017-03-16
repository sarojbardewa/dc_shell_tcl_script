proc ureka_ultra args {
	suppress_message UID-101
 	set cells 0
	array set count_cell {}
	set all_paths [get_timing_paths -nworst 10 -path_type full -slack_lesser_than 10]
        foreach_in_collection path $all_paths {
		set  start [get_attribute $path startpoint]
                set  path_start [get_attribute $start full_name]
		#echo sizeof_collection [get_attribute $path startpoint]
		set end [get_attribute $path endpoint]
		set path_end [get_attribute $end full_name]
		echo "-------------------------------------------------------------"
		puts "**Path between : $path_start - $path_end**"
        	set all_points [get_attribute $path points]
		foreach_in_collection point $all_points {
			set start [get_attribute $point object]
			set name [get_attribute $start full_name]	
			set cell_name [get_cells -of_object "$name"]
			set cell [get_attribute $cell_name full_name]
			echo [format "%10s" $cell]
			set count_cell($cell_name) 1 
			#set t_cell [get_attribute $cell is_combinational]
			#only display combinational cells
			#if {$t_cell=="true"} {
			#echo [format "%10s" $cell] }						
	        } foreach { name_cell count } [array get count_cell] {
	          puts "Cell_name : $name_cell count: $count" }
       } 
	
}

#Define my arguments
define_proc_attributes ureka_ultra \
   -info "This script gives the cells in a path" \
   -define_args {
   {-noArg       "There is no argument for this script"}}

