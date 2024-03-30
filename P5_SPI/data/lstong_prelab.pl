#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $Max_NumWeight_layer = 1;
my $Max_FV_num = 128;

open my $input_file, '<', 'weights.txt' or die "Cannot open input file: $!";
open my $output_file, '>', 'weight_input.txt' or die "Cannot open output file: $!";

my @data_lines;
my @data;  # Declare the @data array

while (my $line = <$input_file>) {
    chomp $line;
    push @data, $line;  # Store each line in the @data array
}

for my $i (0..$Max_NumWeight_layer) {
    for my $j (0..$Max_FV_num-1) {
        push @data_lines, "Weight_Buffer[$i][$j] <= #1 'd" . $data[$i*$Max_FV_num+$j] . ";";
    }
}

my $out = join("\n", @data_lines) . "\n";
print $output_file $out;

close $input_file;
close $output_file;
