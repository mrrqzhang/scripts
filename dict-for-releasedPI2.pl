use strict ;


if($#ARGV<1){
  print "INPUT: wordseg-map-file oringinal-dict\n" ;
  exit ;
}

my $WORDSEG ;
my $INPUT ;
my $OUTPUT ;
my %wsmap=() ;
my @val = ();


open WORDSEG, "<$ARGV[0]" ;
while(<WORDSEG>){
  chomp ;
  my @fields = split "\t" ;
  $wsmap{$fields[0]} = $fields[1] ;
}


open INPUT, "<$ARGV[1]" ;

while(<INPUT>) {
  chomp ;
  my @fields = split "\t" ;
  my $query ;
  if(defined $wsmap{$fields[0]}) {
    $query = $wsmap{$fields[0]} ;
  }
  else { next ;}
  my $temp = $fields[1]+1 ;
  my $year = "$fields[1],$temp" ;
  $val[0]=1.0 ;
  $val[1]=2.0 ;
  $val[2]=$fields[2]; if($val[2]>2.0){$val[2]=2.0;} ;
  $val[3]=$fields[2]; if($val[3]>3.0){$val[3]=3.0;} ;
  $val[4]=$fields[2]+0.5; if($val[4]>2.0){$val[4]=2.0;} ;
  $val[5]=$fields[2]+0.5; if($val[5]>3.0){$val[5]=3.0;} ;
  $val[6]=$fields[2]+1.0; if($val[6]>2.0){$val[6]=2.0;} ;
  $val[7]=$fields[2]+1.0; if($val[7]>3.0){$val[7]=3.0;} ;
  print "$query\t$year\t$val[0]\t$val[1]\t$val[2]\t$val[3]\t$val[4]\t$val[5]\t$val[6]\t$val[7]\n" ;
}

