machines="l4-base-image-ars l4-base-image-3 h100-base-image-2 l4-base-image-4 h100-2-base-image-5 l4-2-base-image-6"
models="distilbert-base-multilingual-cased bert-base-multilingual-cased xlm-roberta-base"

result_dir=scripts/2024_emnlp/analysis/raw_results
machine_dir=$result_dir/machines

if [ -d $machine_dir ]; then
    rm -r $machine_dir
fi
mkdir -p $machine_dir

for machine in $machines; do
    if [ "$machine" = "l4-base-image-ars" ] ; then
        data_dir=/data0
        id=felix
    else
        data_dir=/data
        id=root
    fi
    mkdir $machine_dir/$machine
    scp -r $id@$machine:$data_dir/felix/align_freeze/raw_results/*__with_additional.csv $machine_dir/$machine/
done

mkdir $machine_dir/h100-base-image
cp -r /data3/felix/align_freeze/align_freeze/raw_results/*__with_additional.csv $machine_dir/h100-base-image/

python scripts/2024_emnlp/analysis/result_retrieval/merge_files.py distilbert-base-multilingual-cased
python scripts/2024_emnlp/analysis/result_retrieval/merge_files.py bert-base-multilingual-cased
python scripts/2024_emnlp/analysis/result_retrieval/merge_files.py xlm-roberta-base
