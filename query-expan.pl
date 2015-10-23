#!/usr/releng/bin/perl


#input:  sortseg.v2 scheme

open IN, "<$ARGV[0]" ;
$scheme = $ARGV[1] ;



$OverConfdn=5000 ;
$MaxMainCount = 300 ;
$MinMainCount = 10 ;
$LowerYearCount = 3 ;
$Y_A_RATIO = 0.3 ;
$Second_Y_A_RATIO = 0.15 ;



%year=() ;

$pre = "" ;

while (<IN>) {
  chomp() ;
  @fields = split /\t/ ;

#  if( $fields[1] !~ /2008/ && $fields[1] !~ /平成20/ ) { next ;}

  if( $fields[0] eq "") {next ;}
  if ($pre eq $fields[0]) {
    if ( $fields[1] eq "" ) {
      $maincount += $fields[2] ;
      next ;
    }
    @wy = split ' ', $fields[1] ;
    for ($i=0;$i<=$#wy; $i++) {
      $wy[$i] =~ s/年//g ; 
      $year{$wy[$i]} += $fields[2] ;
    }
  } else {
    my $hashsize = scalar keys %year ;
    if ( $hashsize > 0 && $maincount>0) {
      my ($latestyear, $latestcount, $maxyear, $maxcount, $yearsum) = yearcount(\%year) ;
#      print "pre:$pre\tmaincnt:$maincount\tyearsum:$yearsum\thashsize:$hashsize\n" ;
      $out = isRecency($maincount, $yearsum, $hashsize) ;
      if( $out == 1) {
	$val=$yearsum/$maincount ;
#	print "pre:$pre\tmaincnt:$maincount\tyearsum:$yearsum\tRATIO:$val\tYN:$hashsize\n" ;
	print "$pre\t$latestyear\n" ;
      }
    }
    $pre = $fields[0] ;
    $maincount=0 ;
    %year = () ;
    if ( $fields[1] eq "" ) {
      $maincount += $fields[2] ;
      next ;
    }
    @wy = split ' ', $fields[1] ;
    for ($i=0;$i<=$#wy; $i++) {
      $wy[$i] =~ s/年//g ; 
      $year{$wy[$i]} += $fields[2] ;
    }
  }
}

 

sub yearcount {
  local $heseiyear ="平成";
  local $heseicount=0 ;
  local $latestyear="1999" ;
  local $latestcount=0 ;
  local $ysum=0 ;
  my (%yr) = %{$_[0]} ;		# %$yr
  local @ret ;
  foreach $key ( keys %yr ) {
#    print "here $key $yr{$key}\n" ;
    $ysum += $yr{$key} ;
    if ( $maxcount <$yr{$key} ) {
      $maxcount = $yr{$key} ;
      $maxyear = $key ;
    }
    if ( $key =~ /平成/) {
      if ("$heseiyear" ge "$key" ) {
	next ;
      }
      $heseiyear = $key ;
      $heseicount = $yr{$key} ;
    }
    if ( $key =~ /200[0-9]/ ) {
      if ( "$latestyear" ge "$key" ) {
	next ;
      } 
      $latestyear = $key ;
      $latestcount = $yr{$key} ;
    }
  }
  $key = $heseiyear ;
  $key =~ s/平成//g ;
  $key = 1988+$key ;
  if ( $key-$latestyear >=0 ) {
    $latestyear = $heseiyear ;
    $latestcount = $heseicount ;
  }
#  print "$latestyear, $latestcount, $maxyear, $maxcount, $ysum" ;
  return ($latestyear, $latestcount, $maxyear, $maxcount, $ysum) ;
}
     
        

      
sub isRecency {
  my ($maincnt, $yearsize, $yn) = @_ ;
  my $yes=1 ;
  my $no=0 ;
  $val=$yearsize/$maincnt;

  if ($scheme eq "x1") {
    if ($maincnt>=$OverConfdn  ) { 
      return $no ;
    }

    if ($maincnt>=$MinMainCount && $yearsize>=$LowerYearCount) {
      #    print "$maincnt $MinMainCount $LowerYearCount\n" ;
      if ($val>$Y_A_RATIO) {
	return $yes ;
      } else {
	if ( $maincnt<$MaxMainCount  && $val>=$Second_Y_A_RATIO) {
	  return $yes ;
	}
      }

    } 
    return $no ;
  }
  elsif($scheme eq "x2" ) {
    if ($maincnt>=$OverConfdn) { 
      return $no ;
    }
    if($maincnt>=$MinMainCount && $yearsize>=$LowerYearCoun && $yn>=3 && $val>=0.8) {
      return $yes ;
    }
    return $no ;
  }
  elsif ($scheme eq "x3") {
    if ($maincnt>=$OverConfdn &&  $yn>=4 && $val>=0.8) { #software version
      return $no ;
    }

    if ($maincnt>=10 && $yearsize>=4) {
      #    print "$maincnt $MinMainCount $LowerYearCount\n" ;
      if ($val>$Y_A_RATIO) {
	return $yes ;
      } else {
	if ( $maincnt<300  && $val>=0.15) {
	  return $yes ;
	}
      }

    } 
    return $no ;
  }
  elsif($scheme eq "x4") {
    if($maincnt>=6 && $maincnt<50000 && $val<=1.0){
#     if($maincnt>=40000 && $maincnt<50000){
      return $yes ;
    }
    return $no ;
  }

}
