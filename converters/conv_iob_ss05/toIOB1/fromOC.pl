#!/usr/bin/perl

#Convert merged test file from O+C to IOB1
#Input: O+C
#Output: IOB1

#use strict;

#open (inFP_iob1, "<test.iob1.wch100.merge");
my $line_iob1;
#my @ref;

my $line;
my @iob1;
my @oc;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_iob1=<inFP_iob1>;	
    #chomp($line_iob1);
    #$ref[$i] = $line_iob1;
     
    chomp($line);
    $iob1[$i] = $line;
    $oc[$i] = $line;
    #print $iob1[$i],"\n";
    $i++; 
}


for (my $j=0;$j<=$#iob1;$j++){
    # === split a line into words ===	
    my @iob1_words = split(' ',$iob1[$j]);
    
    # === skip blank line ===
    if ($#iob1_words < 1){
    	#print "\n";
    	next;
    }        
    
    # === split a tagged chunk, eg.I-NP => "I" and "NP" ===
    my @cur = split ('-',$iob1_words[3]);
    
    # === get previous ===
    my @prv_words = split(' ',$oc[$j-1]);
    my @prv = split('-',$prv_words[3]);
    
    # === get follow ===
    my @flw_words = split(' ',$oc[$j+1]);
    my @flw = split('-',$flw_words[3]);
      
    
    # === Case "[" ===
    if ($cur[0] eq "["){
    	
    	# "B" if previous = cur
    	if ($prv[1] eq $cur[1]){
    		$iob1[$j] = $iob1_words[0]." ".$iob1_words[1]." ".$iob1_words[2]." B-".$cur[1];
    	
    	# "I" if o.w.
    	}else{
    		$iob1[$j] = $iob1_words[0]." ".$iob1_words[1]." ".$iob1_words[2]." I-".$cur[1];
    	}
    }  
    
    
    # === Case "]" ===
    if ($cur[0] eq "]"){
    	$iob1[$j] = $iob1_words[0]." ".$iob1_words[1]." ".$iob1_words[2]." I-".$cur[1];
    }
    
    
    # === Case "[]" ===
    if ($cur[0] eq "[]"){
    
    	# "B" if previous = cur
    	if ($prv[1] eq $cur[1]){
    		$iob1[$j] = $iob1_words[0]." ".$iob1_words[1]." ".$iob1_words[2]." B-".$cur[1];
    
    	# "I" if o.w.
    	}else{
    		$iob1[$j] = $iob1_words[0]." ".$iob1_words[1]." ".$iob1_words[2]." I-".$cur[1];
    	}
    }
    
    
    # === Case "O" inside chunk ===
        if ($cur[0] eq "O" and $cur[1]!~/^$/){
        	$iob1[$j] = $iob1_words[0]." ".$iob1_words[1]." ".$iob1_words[2]." I-".$cur[1];
    }
      
}


for(my $j=0;$j<=$#iob1;$j++){
    my @words = split(' ',$iob1[$j]);
    #my @words_ref = split(' ',$ref[$j]);
    #print $words[0]," ";
    #print $words[1]," ";
    #print $words_ref[2]," ";
    print $words[1]," ",$words[2]," ",$words[3],"\n";	
}
