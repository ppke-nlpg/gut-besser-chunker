#!/usr/bin/perl

#Convert merged test file from IOB2 to IOE2
#Input: IOB2
#Output: IOE2

#use strict;

#open (inFP_ioe2, "<test.ioe2.wch100.merge");
my $line_ioe2;
#my @ref;

my $line;
my @ioe2;
my @iob2;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_ioe2=<inFP_ioe2>;	
    #chomp($line_ioe2);
    #$ref[$i] = $line_ioe2;
     
    chomp($line);
    $ioe2[$i] = $line;
    $iob2[$i] = $line;
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
    #my @prv_words = split(' ',$iob2[$j-1]);
    #my @prv = split('-',$prv_words[3]);
    
    # === get follow ===
    my @flw_words = split(' ',$iob2[$j+1]);
    my @flw = split('-',$flw_words[3]);
       
    
    # === Case "I" ===
    if ($cur[0] eq "I"){
    
    	# "I" if follow(I) is "I"
    	if ($flw[0] eq "I" ){
    		$ioe2[$j] = $ioe2_words[0]." ".$ioe2_words[1]." ".$ioe2_words[2]." I-".$cur[1]; 
    
    	# "E" if follow(I) is "O" or "B" or empty
    	}elsif ($flw[0]=/^O|B|$/){
    		$ioe2[$j] = $ioe2_words[0]." ".$ioe2_words[1]." ".$ioe2_words[2]." E-".$cur[1];
    	}
    }
    
    # === Case "B" ===
    if ($cur[0] eq "B"){
    
    	if ($flw[0] eq "I"){# "I" if follow(I) is "I"
    		$ioe2[$j] = $ioe2_words[0]." ".$ioe2_words[1]." ".$ioe2_words[2]." I-".$cur[1];
    	}else{# E if o.w.
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
