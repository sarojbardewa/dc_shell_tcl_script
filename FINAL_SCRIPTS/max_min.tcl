#Title:       	max_min.tcl
#
#Description: 	This Tcl procedure generates specific outputs given
#	      	user input for maximum paths.
# 	      	INPUTS:
# 	      	The following are the inputs to the module:
#	      	from_port     	- Report timing from a port
#	      	to_port     	- Report timing to a port	      			
#	      	nets     	- Report timing for all nets
#	      	cells     	- Report timing for all cells		
#	  	OUTPUTS:
#           from_port     	- max min timing from a port
#	      	to_port     	- max min timing to a port	      			
#	      	nets     	- max min timing for nets
#	      	cells     	- max min timing for cells
#
#Options:     	-from_port    	Specify input port
#             	-to_port    	Specify output port
#             	-nets    	Specify nets
#		-cells 		Specify cells
#
#Usage:       	prompt> max_min \[-from_port {A}]\[-to_port {A}]\[-cells\]\[-nets\]
#Authors:     	Aachal, Bhaskar, Saroj
 
proc max_min args {
   suppress_message UID-101
   ################################################
   # Parse the user inputs
   set com_args0 [lindex $args 0] 
   set com_args1 [lindex $args 1] 
   # Default maximum timing paths to report
   set Npath 100  
   ###################################################
   if {[string match -help* $com_args0]} {
       echo " "
       echo "This tcl script reports maximun and minimum"
       echo "timing for cells/nets/ an IO port in  "
       echo "maximum timing paths"
       echo "-from_port  : report max and min timing from a port"
       echo "-to_port    : report max and min timing to a port "
       echo "-cells      : report min and max timing margin of all cells"
       echo "-nets       : report min and max timing of all nets"

       } elseif {[string match -cells* $com_args0]} {
          # Cell information
	  echo "********************************************************************"
          echo "max_min script"
	  echo "Min and max margin for each cells in the max timing paths"
          echo "********************************************************************"
          echo ""
          # Perform the operation 
          report_timing -path full -delay max -nworst $Npath
          report_timing -path full -delay min -nworst $Npath

	  echo "********************************************************************"
	  echo "Max margin on other side of sequential in the max timing paths"
          echo "********************************************************************"
          echo ""
 	  report_timing -delay max_fall -nworst $Npath 
	  report_timing -delay max_rise -nworst $Npath 
       } elseif {[string match -nets* $com_args0]} {
 	  # Nets in the maximum timing path
	  echo "********************************************************************"
          echo "max_min script"
          echo "Reporting timing margin of nets"
          echo "********************************************************************"
          echo ""
          # Perform the operation
          report_timing -nets -delay max -nworst $Npath
	  report_timing -nets -delay min -nworst $Npath

	  echo "********************************************************************"
	  echo "Max margin on the other side of sequential in the max timing paths"
          echo "********************************************************************"
          echo ""
	  report_timing -delay max_fall -nworst $Npath 
	  report_timing -delay max_rise -nworst $Npath 
		  
       } elseif {[string match -from_port* $com_args0]} {
          # Both number of path and wns specified
	  set port $com_args1
	  echo "********************************************************************"
          echo "max_min script"
          echo [format " Reporting timing from port %10s " $port]
          echo "********************************************************************"
          echo ""          
	  report_timing -from $port -delay max -nworst $Npath
	  report_timing -from $port -delay min -nworst $Npath

	  echo "********************************************************************"
	  echo "Max margin on other side of sequential in the max timing paths"
          echo "********************************************************************"
          echo ""
	  report_timing -delay max_fall -nworst $Npath 
	  report_timing -delay max_rise -nworst $Npath 		
       } elseif {[string match -to_port* $com_args0]} {
          # Both number of path and wns specified
	  set port $com_args1
	  echo "********************************************************************"
          echo "max_min script"
          echo [format " Reporting timing to port %10s " $port]
          echo "********************************************************************"
          echo ""         
	  report_timing -to $port -delay max -nworst $Npath
	  report_timing -to $port -delay min -nworst $Npath
	
	  echo "********************************************************************"
	  echo "Max margin on other side of sequential in the max timing paths"
          echo "********************************************************************"
          echo ""
	  report_timing -delay max_fall -nworst $Npath 
	  report_timing -delay max_rise -nworst $Npath 				
       } else {
	  echo " "
          echo "  Message: Option Required"
          echo "  Usage  : max_min\[-from_port {A}]\[-to_port {A}]\[-cells\]\[-nets\]"
          echo " "
       }
}     
	
   ########################################################
   define_proc_attributes max_min \
   -info "Procedure to report timing margins in the design" \
   -define_args {
   {-from_port  "report max and min timing from a port "}
   {-to_port    "report max and min timing to a port "}
   {-cells      "report min and max timing margin of all cells"}
   {-nets       "report min and max timing of all nets"}}

