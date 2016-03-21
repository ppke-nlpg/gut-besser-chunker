#!/usr/bin/perl

#Convert merged test file from IOE2 to O+C
#Input: IOE2
#Output: O+C

#use strict;

#open (inFP_oc, "<test.o+c.wch100.merge");
my $line_oc;
#my @ref;

my $line;
my @oc;
my @ioe2;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_oc=<inFP_oc>;	
    #chomp($line_oc);
    #$ref[$i] = $line_oc;
     
    chomp($line);
    $oc[$i] = $line;
    $ioe2[$i] = $line;
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
    my @prv_words = split(' ',$ioe2[$j-1]);
    my @prv = split('-',$prv_words[3]);
    
    # === get follow ===
    my @flw_words = split(' ',$ioe2[$j+1]);
    my @flw = split('-',$flw_words[3]);
       
    
    
    
    # === Case "I" ===
    if ($cur[0] eq "I"){
    
    	if ($prv[0] eq "I" and $flw[0]=~/^I|E$/){# "O" previous(I) is "I" and follow(I) is "I" or "E"
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." O-".$cur[1]; 
    	}elsif($prv[0]=~/^O|E|$/ ){# "[" if previous(I) is "O" or "E" or empty
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." [-".$cur[1];  	
    	}
    
    }
    
    # === Case "E" ===
    if ($cur[0] eq "E"){
    
    	if ($prv[0] eq "I"){# "]" if previous(E) is "I"
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." ]-".$cur[1];
    	}else{# o.w.
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
