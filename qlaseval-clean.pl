
use strict ;
my $th=$ARGV[0] ;

while(<STDIN>) {
  chomp() ;
  my @fields = split /\t/ ;
  if($#fields<=2) {print "$_\n"; next ;} ;
  print "$fields[0]\t$fields[1]\t" ;
  my $use=0 ;
  if($fields[$#fields]>=$th) {
    for(my $i=2;$i<=$#fields;$i++) {
      if($i%2==1 && $fields[$i] ne "token") {$use=1;last ;}
    }
    if($use==1) {
      for(my $i=2;$i<$#fields-1; $i++) {
	print "$fields[$i]\t" ;
      }
      print "$fields[$#fields-1]\n" ;
    }
    else {
      for(my $i=2;$i<$#fields-1; $i++) {
        if($i%2==0) {print "$fields[$i]\t";}
        else {print "NONE\t" ;}
      }
      print "NONE\n" ;
    }
  }
  else {
    for(my $i=2;$i<$#fields-1; $i++) {
        if($i%2==0) {print "$fields[$i]\t";}
        else {print "NONE\t" ;}
    }
    print "NONE\n" ;
  }
 
}
  
