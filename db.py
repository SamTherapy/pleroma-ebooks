# SPDX-License-Identifier: AGPL-3.0-only
import argparse, sqlite3, shutil, os

def arg_parser():
    params = argparse.ArgumentParser()

    params.add_argument(
        "-f",
        "--file",
        help="The path to the filter file",
        type=str,
    )
    return params.parse_args()


def scrub_db(filter):
    print("Scrubbing DB")
    shutil.copyfile("toots.db", "toots-copy.db")
    db = sqlite3.connect("toots-copy.db")
    db.text_factory = str
    c = db.cursor()

    try:
        fp = open(f{filter})
        for word in fp:
 			c.execute(f"DELETE FROM toots WHERE content LIKE '%{word}%'") #deletes rows from DB with whatever value word is set to 
    finally:
        fp.close()

    db.commit()

    shutil.copyfile("toots-copy.db", "toots.db")
    os.remove("toots-copy.db")

    print("Scrubbing complete")
    return 1


def main():
    args = arg_parser()

    scrub_db(args.file)

if __name__ == "__main__":
    main()
