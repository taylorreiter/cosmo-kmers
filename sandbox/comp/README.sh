# run sourmash compare on signatures from MTX and MGX iHMP data

# MTX
ln -s ../../outputs/sigs/*sig
sourmash compare -k 51 --csv mtx_comp.csv *sig

# MGX 
rm *sig
ln -s ../../outputs/mgx_sigs/*sig
sourmash compare -k 51 --csv mgx_comp.csv *sig
