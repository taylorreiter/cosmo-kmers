#! /usr/bin/env python
"""
Given a list of sourmash signatures, find the common hashes and then
output a hash co-occurrence matrix that can be used to cluster samples.
"""
from __future__ import print_function

import argparse
import collections
import sourmash_lib.signature
import numpy


def main():
    p = argparse.ArgumentParser()
    p.add_argument('inp_signatures', nargs='+')
    p.add_argument('-k', '--ksize', type=int, default=31)
    p.add_argument('--scaled', type=int, default=100000)
    p.add_argument('-o', '--output-name')
    p.add_argument('--threshold', type=int, default=2)
    p.add_argument('--max-threshold', type=int, default=None)
    p.add_argument('--frequency', action='store_true')
    p.add_argument('--intersect', nargs='+',
                   help='only use hashes in the given files')
    args = p.parse_args()

    counts = collections.Counter()

    intersect_hashes = set()
    if args.intersect:
        for n, filename in enumerate(args.intersect):
            print('...loading intersect {}'.format(n + 1), end='\r')
            sig = sourmash_lib.signature.load_one_signature(filename,
                                                            ksize=args.ksize)
            mh = sig.minhash.downsample_scaled(args.scaled)
            hashes = mh.get_mins()
            intersect_hashes.update(hashes)
        print('')

    print('loading signatures from', len(args.inp_signatures), 'files')
    sig_hashes = {}
    for n, filename in enumerate(args.inp_signatures):
        print('... {}'.format(n + 1), end='\r')
        sig = sourmash_lib.load_one_signature(filename, ksize=args.ksize)
        mh = sig.minhash.downsample_scaled(args.scaled)
        hashes = mh.get_mins()

        if intersect_hashes:
            hashes = set(hashes)
            hashes.intersection_update(intersect_hashes)

        sig_hashes[filename] = hashes

        for k in hashes:
            counts[k] += 1

    print('\n...done. Now finding common hashes among >= {} samples'.format(args.threshold))

    n = 0
    abundant_hashes = set()
    for hash, count in counts.most_common():
        if args.max_threshold and count > args.max_threshold:
            continue

        if count < args.threshold:
            break

        n += 1
        abundant_hashes.add(hash)

    print('found', n, 'hashes from', len(args.inp_signatures), 'signatures')
    print('min threshold: {}'.format(args.threshold))

    # go over the files again, this time creating an n x n_files matrix
    # with 0 etc.
    pa = numpy.zeros((len(abundant_hashes), len(abundant_hashes)),
                      dtype=numpy.float)

    # sort for no particular reason
    hashlist = list(sorted(abundant_hashes))
    hashdict = {}
    for n, k in enumerate(hashlist):
        hashdict[k] = n                   # hash -> index in hashlist
                         
    print('calculating matrix {} x {}'.format(len(abundant_hashes),
                                              len(abundant_hashes)))

    print('iterate x 2 signatures from', len(args.inp_signatures), 'files')
    for fn, (filename, hashes) in enumerate(sig_hashes.items()):
        print('... {}'.format(fn + 1), end='\r')

        x = abundant_hashes.intersection(hashes)
        for hashval in x:
            for hashval2 in x:
                idx = hashdict[hashval]
                idx2 = hashdict[hashval2]
                if args.frequency:
                    pa[idx2][idx] += 1
                else:
                    pa[idx2][idx] = 1

    if args.frequency:
        pa /= len(sig_hashes)

    print('\ndone! saving to:', args.output_name)

    with open(args.output_name, 'wb') as fp:
        numpy.save(fp, pa)

    with open(args.output_name + '.labels.txt', 'w') as fp:
        fp.write("\n".join(map(str, hashlist)))
            

if __name__ == '__main__':
    main()
