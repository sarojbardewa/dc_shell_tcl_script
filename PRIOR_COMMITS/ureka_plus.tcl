proc ureka_plus args {
	suppress_message UID-101
 	set cells 0
	set path_no 1
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
			#if {$t_object=="true"} {
			#echo [format "%10s" $name] }
								}
	} 
}

#Define my arguments
define_proc_attributes ureka_plus \
   -info "This script gives the cells in a path" \
   -define_args {
   {-noArg       "There is no argument for this script"}}

