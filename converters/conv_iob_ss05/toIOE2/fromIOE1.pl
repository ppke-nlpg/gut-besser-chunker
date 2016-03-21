#!/usr/bin/perl

#Convert merged test file from IOE1 to IOE2
#Input: IOE1
#Output: IOE2

#use strict;

#open (inFP_ioe2, "<test.ioe2.wch100.merge");
my $line_ioe2;
#my @ref;

my $line;
my @ioe2;
my @ioe1;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_ioe2=<inFP_ioe2>;	
    #chomp($line_ioe2);
    #$ref[$i] = $line_ioe2;
     
    chomp($line);
    $ioe2[$i] = $line;
    $ioe1[$i] = $line;
    #print $ioe2[$i],"\n";
    $i++; 
}


for (my $j=0;$j<=$#ioe2;$j++){
    # === split a line into words ===	
    my @ioe2_words = split(' ',$ioe2[$j]);
    
    # === skip blank line ===
    if ($#ioe2_words < 1){
    	#print "\n";
    	next;
    }        
    
    # === split a tagged chunk, eg.I-NP => "I" and "NP" ===
    my @cur = split ('-',$ioe2_words[3]);
    
    # === get previous ===
    #my @prv_words = split(' ',$ioe1[$j-1]);
    #my @prv = split('-',$prv_words[3]);
    
    # === get follow ===
    my @flw_words = split(' ',$ioe1[$j+1]);
    my @flw = split('-',$flw_words[3]);
       
    
    # === Case "I" ===
    if ($cur[0] eq "I"){
    
    	# "I" if follow(I) is "I" or "E" and follow = cur
    	if ($flw[0]=~/^I|E$/ and $flw[1] eq $cur[1]){
    		$ioe2[$j] = $ioe2_words[0]." ".$ioe2_words[1]." ".$ioe2_words[2]." I-".$cur[1]; 
    
    	# "E" if follow(I) is "O" or empty
    	}elsif ($flw[0]=/^O|$/){
    		$ioe2[$j] = $ioe2_words[0]." ".$ioe2_words[1]." ".$ioe2_words[2]." E-".$cur[1];
    	
    	# "E" if follow(I) is "I" and follow != cur
    	}elsif ($flw[0] eq "I" and $flw[1] ne $cur[1]){
    		$ioe2[$j] = $ioe2_words[0]." ".$ioe2_words[1]." ".$ioe2_words[2]." E-".$cur[1];
    	}
    	
    }
    
}


for(my $j=0;$j<=$#ioe2;$j++){
    my @words = split(' ',$ioe2[$j]);
    #my @words_ref = split(' ',$ref[$j]);
    #print $words[0]," ";
    #print $words[1]," ";
    #print $words_ref[2]," ";
    print $words[1]," ",$words[2]," ",$words[3],"\n";	
}
