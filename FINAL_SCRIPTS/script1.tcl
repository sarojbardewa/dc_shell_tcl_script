#Title:       path_timing.tcl
#
#Description: This Tcl procedure generates specific outputs given
#	      user input.
# 		INPUTS:
# 	      	The following are the inputs to the module:
#	 	N 	- 	Top N paths, where N is the number of paths
#	 	WNS_val -	WNS value	
#		
#		OUTPUTS:
#               Total_cells  - Total number of cells
#               N_cells      - Number of times each cell found
#               delay_cell   - Delay of each cell
#
#Options:     -N    	    Number of top N paths
#             -WNS_val      Paths with the specified WNS
#             -N -WNS_Val   Number of cells with WNS
#
#Usage:       prompt> source path_timing.tcl
#Authors:     Aachal, Bhaskar, Saroj
 
proc path_timing args {
   suppress_message UID-101
   ################################################
   # Parse the user inputs
   set option [lindex $args 0] 
   set value1 [lindex $args 1] 
   set option2 [lindex $args 2] 
   set value2 [lindex $args 3]
 
  ###################################################
   if {[string match -help* $option]} {
       echo " "
       echo "This tcl script finds the top N paths with or"
       echo "without WNS specified and draws the histogram"
       echo "to show the number of times cells appeared in"
       echo "those paths"
       echo "-path : report top N paths"
       echo "-wns  : report worst negative paths"
       return
       } elseif {[string match -path* $option] && ([string match -wns* $option2]==0)} {
          # Only number of paths specified
 	  set Npath [expr $value1*1]
	  echo '********************************************************************"
          echo 'Path_timing script"
          echo [format "%10s path specified only" $Npath]
          echo "********************************************************************"
          echo ""
          # Perform the operation
          report_timing -path full -delay max -nworst $Npath -sort_by slack
	  set cells 0
	set cellFound 0
	array set count_cell {}
	set all_paths [get_timing_paths -path full -delay max -nworst $Npath]

	# To find the Total Number of cells in the Max Timing Path
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
			# To get the combinational cells in the Timing path
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
					     #set newcount [expr $ewcount/2]
					     set count_cell($cell) $newcount
					     set cellFound 1
					    # echo [format "%10s %10s" $name_cell $count]
					     break
					    # echo [format "%10s %10s" $name_cell $newcount] 
					} else { set cellFound 0 }}
					if {$cellFound==0} { set count_cell($cell) 1}
					}}}} 
			echo " ********************************************************************** "
			echo " The Total number of cell counts in the Maximum Timing Path "
			foreach { name_cell count} [array get count_cell] { echo [format "%10s %10s" $name_cell [expr $count/2]] }
			echo " ********************************************************************** "

#array set arr $count_cell

foreach element [array names count_cell] {
    puts -nonewline "cell($element) "
    for {set i 0} {$i <= [expr $count_cell($element)/2 - 1]} {incr i} {
	#echo $count_cell($element)
        puts -nonewline "*"
    }
    puts -nonewline "[expr $count_cell($element)/2]"
	#echo $count_cell($element)
    puts "\n"
}




			return
       } elseif {[string match -path* $option]&& ([string match -wns* $option2])} {
          # Both number of path and wns specified
	  set Npath [expr $value1*1]
          set wns [expr $value2*1.0]
	  echo '********************************************************************"
          echo 'Path_timing script"
          echo [format "%10s path specified" $Npath]
          echo [format "%10.2f wns specified" $wns]
          echo "********************************************************************"
          echo ""
          # Perform the operation
          report_timing -path full -delay max -nworst $Npath -slack_lesser_than $wns -sort_by slack 
			# Operation performed to find the Tital number of cells in the Maximum timing path
			set cells 0
			set cellFound 0
			array set count_cell {}
			set all_paths [get_timing_paths -path full -delay max -nworst $Npath -slack_lesser_than $wns ]
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
					     #set newcount [expr $ewcount/2]
					     set count_cell($cell) $newcount
					     set cellFound 1
					    # echo [format "%10s %10s" $name_cell $count]
					     break
					    # echo [format "%10s %10s" $name_cell $newcount] 
					} else { set cellFound 0 }}
					if {$cellFound==0} { set count_cell($cell) 1}
						}}}} 
			echo " ********************************************************************** "
			echo " The Total number of cell counts in the Maximum Timing Path "
			foreach { name_cell count} [array get count_cell] { echo [format "%10s %10s" $name_cell [expr $count/2]] }
			echo " ********************************************************************** "
            
            #array set arr $count_cell

foreach element [array names count_cell] {
    puts -nonewline "cell($element) "
    for {set i 0} {$i <= [expr $count_cell($element)/2 - 1]} {incr i} {
	#echo $count_cell($element)
        puts -nonewline "*"
    }
    puts -nonewline "[expr $count_cell($element)/2]"
	#echo $count_cell($element)
    puts "\n"
}

			return
       } elseif {[string match -wns* $option]} {
          #Only WNS specified
          set wns [expr $value1*1.0]
    	  echo '********************************************************************"
          echo 'Path_timing script"
          echo [format "%10.2f wns only was specified" $wns]
          echo "********************************************************************"
          # Perform the operation
	  report_timing -path full -delay max -sort_by slack -slack_lesser_than $wns  
	  set cells 0
	set cellFound 0
	array set count_cell {}
	set all_paths [get_timing_paths -path full -delay max  -slack_lesser_than $wns]
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
					     #set newcount [expr $ewcount/2]
					     set count_cell($cell) $newcount
					     set cellFound 1
					    # echo [format "%10s %10s" $name_cell $count]
					     break
					    # echo [format "%10s %10s" $name_cell $newcount] 
					} else { set cellFound 0 }}
					if {$cellFound==0} { set count_cell($cell) 1}
					}}}} 
			echo " ********************************************************************** "
			echo " The Total number of cell counts in the Maximum Timing Path "
			foreach { name_cell count} [array get count_cell] { echo [format "%10s %10s" $name_cell [expr $count/2]] }
			echo " ********************************************************************* "
		    
		    #array set arr $count_cell

foreach element [array names count_cell] {
    puts -nonewline "cell($element) "
    for {set i 0} {$i <= [expr $count_cell($element)/2 - 1]} {incr i} {
	#echo $count_cell($element)
        puts -nonewline "*"
    }
    puts -nonewline "[expr $count_cell($element)/2]"
	#echo $count_cell($element)
    puts "\n"
}

		
		return
	} else {
          echo " "
          echo "  Message: Option Required"
          echo "  Usage:  path_timing \[-path\] \[-wns\]"
          echo " "
          return
      }

 	


   
}     
	
   ########################################################
 define_proc_attributes path_timing \
   -info "Procedure to report top N paths in the design" \
   -define_args {
   {-path "report top N paths"}
   {-wns  "report worst negative paths"}}

