#! /usr/bin/env python
# By Luiz Irber
# https://gist.github.com/luizirber/072b225a3d389c8413c895ee56faa83e

import sourmash


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("-k", "--ksize", type=int, default=51)
    parser.add_argument("-o", "--output", type=str, default=None)
    parser.add_argument("query")
    parser.add_argument("sbt", nargs="+")

    args = parser.parse_args()

    query = sourmash.load_one_signature(args.query, ksize=args.ksize)

    query_mins = set(query.minhash.get_mins())

    for index in args.sbt:
        sbt = sourmash.load_sbt_index(index)
        for i, dataset in enumerate(sbt.leaves()):
            dataset_mins = dataset.data.minhash.get_mins()
            del dataset._data
            query_mins -= set(dataset_mins)
            if not query_mins:
                break

            if i % 100 == 0:
                print(
                    f"Progress: {i} sigs processed, query has {len(query_mins)} hashes left"
                )

    new_mh = query.minhash.copy_and_clear()
    if new_mh.track_abundance:
        new_mh.set_abundances(
            {
                k: v
                for k, v in query.minhash.get_mins(with_abundance=True).items()
                if k in query_mins
            }
        )
    else:
        new_mh.add_many(query_mins)

    query.minhash = new_mh

    output = args.query + ".unassigned"
    if args.output:
        output = args.output

    with open(output, "w") as fp:
        sourmash.save_signatures([query], fp)
