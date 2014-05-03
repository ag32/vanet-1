#!/usr/bin/perl

$file_name = "hello";
if($#ARGV + 1 == 0) {
  $file_name = $ARGV[0];
}
$max_rows = 10;
$max_cols = 10;
$x_width = 50;
$y_width = 50;

$file_name = "hello";

$node_file = $file_name . ".nod.xml";
print("Create $node_file ..\n");
open(fh, ">$node_file");

print fh "<nodes>\n";
for($row = 0; $row < $max_rows; $row++) {
   for($col = 0; $col < $max_cols; $col++) {
  	$id = $row * $max_rows + $col;
  	$x = $row * $x_width;
  	$y = $col * $y_width;
  	print fh "   <node id=\"$id\" x=\"$x\" y=\"$y\" />\n";
    }
}

print fh "</nodes>\n";
close(fh);

$edge_file = $file_name . ".edg.xml";
print("Create $edge_file ..\n");
open(fh, ">$edge_file");
print fh "<edges>\n";

for($row = 0; $row < $max_rows; $row++) {
   for($col = 0; $col < ($max_cols -1); $col++) {
  	$id = $row * 10 + $col;
	$from = $id;
	$to = $id + 1;
	$edge_id = $from . "_to_" . $to;
	print fh "   <edge from=\"$from\" id=\"$edge_id\" to=\"$to\" />\n";
   }
}
print fh "</edges>\n";
close(fh);

$rou_file = $file_name . ".rou.xml";
print("Create $rou_file ..\n");
open(fh, ">$rou_file");
print fh "<routes>\n";
print fh "   <vType accel=\"1.0\" decel=\"5.0\" id=\"Car\" length=\"6.0\" maxSpeed=\"100\" sigma=\"0.0\" />\n";

for($row = 0; $row < $max_rows; $row++) {
   @edge_lst = ();
   for($col = 0; $col < ($max_cols -1); $col++) {
  	$id = $row * $max_rows + $col;
	$from = $id;
	$to = $id + 1;
	$edge_id = $from . "_to_" . $to;
	push @edge_lst, $edge_id;
   }
   print fh "<route id=\"$row\" edges=\"";
   for($i = 0; $i < @edge_lst; $i++) {
	print fh "$edge_lst[$i] ";
   }
   print fh "\"/>\n";
}

for($row = 0; $row < $max_rows; $row++) {
   $veh_id = "veh" . $row;
   print fh "<vehicle depart=\"$row\" id=\"$veh_id\" route=\"$row\" type=\"Car\" />\n";
}
print fh "</routes>\n";
close($fh);
