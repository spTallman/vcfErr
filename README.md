# vcfErr
Script used to simulate errors on a VCF file

vcfErr.R takes an input VCF file (MUST BE PHASED) and simulates error by changing heterozygous genotype to a random homozygous genotype and vice versa.
TESTED ON R VERSION 3.5.1

each genotype is changed with some designated probability e.g. 0.001
test.vcf is a VCF with 100,000 genotypes and 80 samples. One would expect approximately 100 errors per sample with an error of 0.001.

Requies packages:
argparse, datatable, stringr

Usage:
Rscript vcfErr.R -v test.vcf -e 0.001

Prints how many variants were changed per individual in the VCF.

Outputs:
test.err.vcf

NOTE this script does not maintain the original header of the VCF.
to do this simply..

grep "#" test.vcf | cat - test.err.vcf > test.err.reheader.vcf

because this is a stochastic process, test.err.vcf will not be identical to the VCF provided.
example.vcf (identical to test.vcf) example.err.vcf and example.err.reheader.vcf were created using the same pipeline as above.
