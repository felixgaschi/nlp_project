
if __name__ == "__main__":

    import argparse
    import os
    import csv


    parser = argparse.ArgumentParser()
    parser.add_argument("model", type=str)
    args = parser.parse_args()

    result_dir="scripts/2024_emnlp/analysis/raw_results"
    machines_dir = os.path.join(result_dir, "machines")

    new_file = os.path.join(result_dir, f"{args.model}__xnli__opus100__aggregated_additional.csv")

    baseline_file = os.path.join(result_dir, f"{args.model}__xnli__opus100.csv")

    key_length = 4
    keys = set()

    rows = []
    with open(baseline_file, "r") as f:
        reader = csv.reader(f)
        for row in reader:
            if row[3] == "baseline":
                rows.append(list(filter(lambda x: x != "", row)))
                keys.add(tuple(row[:key_length]))

    

    found_header = False
    with open(new_file, "w") as f:
        writer = csv.writer(f)
        for machine in os.listdir(machines_dir):
            machine_dir = os.path.join(machines_dir, machine)

            fname = os.path.join(machine_dir, f"{args.model}__xnli__opus100__with_additional.csv")
            if not os.path.isfile(fname):
                continue

            with open(fname, "r") as f:
                reader = csv.reader(f)
                for i, row in enumerate(reader):
                    if i == 0:
                        if not found_header:
                            writer.writerow(row)
                            found_header = True
                        continue
                    key = tuple(row[:key_length])
                    if key in keys:
                        print(f"Found duplicate for: {key}")
                        continue
                    keys.add(key)

                    writer.writerow(row)

        writer.writerows(rows)
