proc ureka_premium args {
	suppress_message UID-101
 	set cells 0
	set cellFound 0
	array set count_cell {}
	set all_paths [get_timing_paths -nworst 10 -path_type full -slack_lesser_than 10]
        foreach_in_collection path $all_paths {
		set  start [get_attribute $path startpoint]
                set  path_start [get_attribute $start full_name]
		#echo sizeof_collection [get_attribute $path startpoint]
		set end [get_attribute $path endpoint]
		set path_end [get_attribute $end full_name]
		#echo "-------------------------------------------------------------"
		#puts "**Path between : $path_start - $path_end**"
        	set all_points [get_attribute $path points]
		foreach_in_collection point $all_points {
			set start [get_attribute $point object]
			set name [get_attribute $start full_name]	
			set cell_name [get_cells -of_object "$name"]
			set cell [get_attribute $cell_name full_name]
			#echo [format "%10s" $cell]
			set t_cell [get_attribute $cell is_combinational]
			#only if the gate is a combinational cell
			if {$t_cell=="true"} {	
				if {[array size count_cell]==0} {
				 set count_cell($cell) 1
				 set count 1
				 #echo [format "%10s %10s" $cell $count ]		
				} else { foreach { name_cell count} [array get count_cell] {
	        		         if {[string match $name_cell $cell]} {
					     set newcount [expr 1 + $count]
					     set count_cell($cell) $newcount
					     set cellFound 1
					     break
					    #echo [format "%10s %10s" $name_cell $newcount] 
					} else { set cellFound 0 }} 
					if {$cellFound==0} { set count_cell($cell) 1  }
					}}}} 
foreach { name_cell count} [array get count_cell]{ echo [format "%10s %10s" $name_cell $count] }}
			

#Define my arguments
define_proc_attributes ureka_premium \
   -info "This script gives the cells in a path" \
   -define_args {
   {-noArg       "There is no argument for this script"}}

