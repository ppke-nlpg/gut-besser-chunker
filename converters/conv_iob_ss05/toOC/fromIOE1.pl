#!/usr/bin/perl

#Convert merged test file from IOE1 to O+C
#Input: IOE1
#Output: O+C

#use strict;

#open (inFP_oc, "<test.o+c.wch100.merge");
my $line_oc;
#my @ref;

my $line;
my @oc;
my @ioe1;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_oc=<inFP_oc>;	
    #chomp($line_oc);
    #$ref[$i] = $line_oc;
     
    chomp($line);
    $oc[$i] = $line;
    $ioe1[$i] = $line;
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
    my @prv_words = split(' ',$ioe1[$j-1]);
    my @prv = split('-',$prv_words[3]);
    
    # === get follow ===
    my @flw_words = split(' ',$ioe1[$j+1]);
    my @flw = split('-',$flw_words[3]);
       
    
    
    
    # === Case "I" ===
    if ($cur[0] eq "I"){
    
    	if($prv[0] eq "I" and $prv[1] eq $cur[1] and $flw[I]=~/^I|E$/ and $flw[1] eq $cur[1]){# "O" if previous(I) is "I" and cur = previous and follow(I) is "I" or "E" and follow = cur
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." O-".$cur[1];     
    	}elsif ($prv[0]=~/^O|$/ and $flw[0]=~/^I|E$/ and $flw[1] eq $cur[1]){# "[" if previous(I) is "O" or empty and follow(I) is "I" or "E" and follow = cur
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." [-".$cur[1]; 
    	}elsif ($prv[0] eq "I" and $prv[1] ne $cur[1] and $flw[0]=~/^I|E$/ and $flw[1] eq $cur[1]){# "[" if previous(I) is "I" and previous != cur and follow(I) is "I" or "E" and follow = cur
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." [-".$cur[1]; 
    	}elsif ($prv[0] eq "E" and (($flw[0] eq "I" and $flw[1] eq $cur[1]) or $flw[0] eq "E")){# "[" if previous(I) is "E" and (follow(I) is "I" and follow = cur) or follow(I) is "E"	
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." [-".$cur[1];    	
    	}elsif ($prv[0] eq "I" and $prv[1] eq $cur[1] and ($flw[0] eq "O" or $flw[0]=~/^$/)){# "]" if previous(I) is "I" and cur = previous and follow(I) is "O" or empty
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." ]-".$cur[1];    
    	}elsif ($prv[0] eq "I" and $prv[1] eq $cur[1] and $flw[0] eq "I" and $flw[1] ne $cur[1]){# "]" if previous(I) is "I" and cur = previous and follow(I) is "I" and follow != cur
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." ]-".$cur[1];
    	}elsif ($prv[0]=~/^O|E|$/ and $flw[0]=~/^O|$/){# "[]" if previous(I) is "O" or "E" or empty and follow(I) is "O" or empty
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." []-".$cur[1];
    	}elsif ($prv[0] eq "I" and $prv[1] ne $cur[1] and $flw[0] eq "I" and $flw[1] ne $cur[1]){# "[]" if previous(I) is "I" and previous != cur and follow(I) is "I" and follow != cur
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." []-".$cur[1];
    	}elsif ($prv[0] eq "I" and $prv[1] ne $cur[1] and ($flw[0] eq "O" or $flw[0] eq "B")){# "[]" if previous(I) is "I" and previous != cur and follow(I) is "O" or empty
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." []-".$cur[1];
    	}elsif ($prv[0]=~/^O|E|$/ and $flw[0] eq "I" and $flw[1] ne $cur[1]){# "[]" if previous(I) is "O" or "E" or empty and follow(I) is "I" and follow != cur
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." []-".$cur[1];
    	}
    
    }
    
    # === Case "E" ===
    if ($cur[0] eq "E"){
    
    	if ($prv[0] eq "I" and $prv[1] eq $cur[1] and $flw[0]=~/^O|I|$/){# "[" if previous(E) is "I" and previous = cur and follow(E) is "O" or "I" or empty
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." ]-".$cur[1];
    	}elsif ($prv[0]=~/^O|$/ and $flw[0] eq "I"){# "[]" if previous(E) is "O" or empty and  follow(E) is "I"
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
