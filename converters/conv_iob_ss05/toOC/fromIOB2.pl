#!/usr/bin/perl

#Convert merged test file from IOB2 to O+C
#Input: IOB2
#Output: O+C

#use strict;

#open (inFP_oc, "<test.o+c.wch100.merge");
my $line_oc;
#my @ref;

my $line;
my @oc;
my @iob2;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_oc=<inFP_oc>;	
    #chomp($line_oc);
    #$ref[$i] = $line_oc;
     
    chomp($line);
    $oc[$i] = $line;
    $iob2[$i] = $line;
    #print $oc[$i],"\n";
    $i++; 
}


for (my $j=0;$j<=$#oc;$j++){
    # === split a line into words ===	
    my @oc_words = split(' ',$oc[$j]);
    
    # === skip blank line ===
    if ($#oc_words < 1){
    	#print "\n";
    	next;
    }        
    
    # === split a tagged chunk, eg.I-NP => "I" and "NP" ===
    my @cur = split ('-',$oc_words[3]);
    
    # === get previous ===
    my @prv_words = split(' ',$iob2[$j-1]);
    my @prv = split('-',$prv_words[3]);
    
    # === get follow ===
    my @flw_words = split(' ',$iob2[$j+1]);
    my @flw = split('-',$flw_words[3]);
       
    
    
    
    # === Case "I" ===
    if ($cur[0] eq "I"){
    
    	# "]" if follow(I) is "O" or "B"
    	if ($flw[0] eq "O" or $flw[0] eq "B" ){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." ]-".$cur[1]; 
    	
    	# "O" if follow(I) is "I"
    	}elsif ($flw[0] eq "I"){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." O-".$cur[1]; 
    	}
    }
    
    
    # === Case "B" ===
    if ($cur[0] eq "B"){
    	
    	# "[" if follow(B) is "I"
    	if ($flw[0] eq "I"){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." [-".$cur[1];
    	
    	# "[]" if o.w.
    	}else{
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." []-".$cur[1];
    	}
    }
    
    
    
}

for(my $j=0;$j<=$#oc;$j++){
    my @words = split(' ',$oc[$j]);
    #my @words_ref = split(' ',$ref[$j]);
    #print $words[0]," ";
    #print $words[1]," ";
    #print $words_ref[2]," ";
    print $words[1]," ",$words[2]," ",$words[3],"\n";	
}
