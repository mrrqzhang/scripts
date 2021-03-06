#!/usr/releng/bin/perl
use strict ;

$#ARGV>=1 or die "command: sortseg.v2 scheme(x3/x4/x5/cf/verylowval) \n" ;

#input:  sortseg.v2 scheme

my $IN ;
open IN, "<$ARGV[0]" ;
my $scheme = $ARGV[1] ;



my $OverConfdn=5000 ;
my $MaxMainCount = 300 ;
my $MinMainCount = 10 ;
my $LowerYearCount = 3 ;
my $Y_A_RATIO = 0.3 ;
my $Second_Y_A_RATIO = 0.15 ;



my %year=() ;

my $pre = "" ;

my $cf=0 ;

my $maincount ;
while (<IN>) {

  
  chomp() ;
  my   @fields = split /\t/ ;

#  if( $fields[1] !~ /2008/ && $fields[1] !~ /平成20/ ) { next ;}

#
  if( $fields[0] eq "") {next ;}

  if ($pre eq $fields[0]) {
    if ( $fields[1] eq "" ) {
      $maincount += $fields[2] ;
      next ;
    }
    my @wy = split ' ', $fields[1] ;
    for (my $i=0;$i<=$#wy; $i++) {
      $wy[$i] =~ s/年//g ; 
      $year{$wy[$i]} += $fields[2] ;
    }
  } else {
    my $hashsize = scalar keys %year ;

    if ( $hashsize > 0 && $maincount>0) {
      my ($latestyear, $latestcount, $maxyear, $maxcount, $yearsum) = yearcount(\%year) ;
      #      print "pre:$pre\tmaincnt:$maincount\tyearsum:$yearsum\thashsize:$hashsize\n" ;
      my $out = isRecency($maincount, $yearsum, $hashsize) ;
      if( $out == 1) {
	my $val=$yearsum/$maincount ;
#	print "pre:$pre\tmaincnt:$maincount\tyearsum:$yearsum\tRATIO:$val\tYN:$hashsize\n" ;
#	if($latestyear>=2008 ){print "$pre\t$latestyear\t$maincount\n" ;}
	if($latestyear>=2008 && $scheme eq "cf") { print "$pre\t$latestyear\t$maincount\t$cf\n" ;}
	elsif($latestyear>=2008 ) { print "$pre\t$latestyear\t$maincount\n" ;}
      }
    }
    $pre = $fields[0] ;
    $maincount=0 ;
    %year = () ;
    if ( $fields[1] eq "" ) {
      $maincount += $fields[2] ;
      next ;
    }
    my @wy = split ' ', $fields[1] ;
    for (my $i=0;$i<=$#wy; $i++) {
      $wy[$i] =~ s/年//g ; 
      $year{$wy[$i]} += $fields[2] ;
    }
  }
}

 

sub yearcount {
  my $heseiyear ="平成";
  my $heseicount=0 ;
  my  $latestyear="1999" ;
  my  $latestcount=0 ;
  my  $ysum=0 ;
  my (%yr) = %{$_[0]} ;		# %$yr
  my  @ret ;
  my $key ;
  my $maxcount = 0 ;
  my $maxyear ;
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
  my ($maincnt, $yearsize, $yn) = @_ ; # yn: different year count */
  my $yes=1 ;
  my $no=0 ;
  my $val=$yearsize/$maincnt;

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
    if($maincnt>=$MinMainCount && $yearsize>=$LowerYearCount && $yn>=3 && $val>=0.8) {
      return $yes ;
    }
    return $no ;
  }
  elsif ($scheme eq "x3") {
    if ($maincnt>=5000 &&  $yn>=4 && $val>=0.8) { #software version
      return $no ;
    }

    if ($maincnt>=10 && $yearsize>=4) {
      #    print "$maincnt $MinMainCount $LowerYearCount\n" ;
      if ($val>$Y_A_RATIO) {
	return $yes ;
      } else {
	if ( $maincnt<5000  && $val>=0.15) {
	  return $yes ;
	}
      }

    } 
    return $no ;
  }
  elsif($scheme eq "x4") {
    my $out = isNotXthree($maincnt, $yearsize, $yn ) ;
#    print "$out $maincnt $val\n" ;
#    if($maincnt>=6 && $maincnt<50000 && $val<=1.0 && $val>0 && $out==0){ #this rule prove not working for Japan
    if($maincnt>=6 && $maincnt<10000 && $yearsize>1 && $val>=0.03 && $out==0) { 
       return $yes ;
    }
    return $no ;
  }
  elsif($scheme eq "x5") { # x5 is x4's extension
    my $out = isNotXthree($maincnt, $yearsize, $yn ) ;
    if($maincnt<50000 && $maincnt>=10000 && $yearsize>1 && $val>=0.03 && $out==0) {
      return $yes ;
    }
    return $no ;
  }
  elsif($scheme eq "verylowval") {
    my $out = isNotXthree($maincnt, $yearsize, $yn ) ;
    if($maincnt>=6 && $maincnt<50000 && $yearsize>=3 && $val<0.03 &&  $val>0 && $out==0) {
      return $yes ;
    }
    return $no ;
  }
  elsif($scheme eq "yichang") {  # yi want top queries to increase traffic
    if($maincnt>=50000 && $val<=1.0 && $val>0 ){
      return $yes ;
    }
    return $no ;
  }
  elsif($scheme eq "v10") {
	if($maincnt<6 ) {return $yes ;}
	return $no ;
  }
  elsif($scheme eq "cf") { # confidence measure
    if($maincnt>=50000 || $maincnt<6 ) {return $no;}
    my $valcf = $yearsize/($yearsize+$maincnt) ;
    if($valcf>=0 && $valcf < 0.1) {$cf=1; return $yes;}
    if($valcf>=0.1 && $valcf<0.3) {$cf=2; return $yes;} 
    if($valcf>=0.3 && $valcf<0.6) {$cf=3; return $yes;}
    if($valcf>=0.6 && $valcf<0.9 ) {$cf=4; return $yes;}
    if($valcf>=0.9) {$cf=5; return $yes;}
  }
    
}

sub isNotXthree {
  my $yes=1 ;
  my $no=0 ;
  my($maincnt, $yearsize, $yn) = @_ ;
  my $val=$yearsize/$maincnt;
  if ($maincnt>=$OverConfdn &&  $yn>=4 && $val>=0.8) { #software version
    return $no ;
  }

  if ($maincnt>=10 && $yearsize>=4) {
    #    print "$maincnt $MinMainCount $LowerYearCount\n" ;
    if ($val>$Y_A_RATIO) {
      return $yes ;
    } else {
      if ( $maincnt<5000  && $val>=0.15) {
	return $yes ;
      }
    }

  } 
  return $no ;
}
