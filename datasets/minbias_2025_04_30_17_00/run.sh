call_dir=$PWD
nov=$1 && \
n_workers=$2 && \
events_per_job=$3 && \
timeout=$4 && \
lzt_workspace=${HOME}/workspaces/lorenzetti && \
lzt_repo="${HOME}/workspaces/lorenzetti/lorenzetti" && \
seed=729378 && \
# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
base_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) && \
echo "Saving data in ${base_dir}" && \
evt_dir="${base_dir}/EVT" && \
hit_dir="${base_dir}/HIT" && \
esd_dir="${base_dir}/ESD" && \
aod_dir="${base_dir}/AOD" && \
ntuple_dir="${base_dir}/NTUPLE" && \
cd "${lzt_repo}/build" && source lzt_setup.sh && \
# generate events with pythia
mkdir -p "${base_dir}/EVT" && cd "${base_dir}/EVT" && \
echo "$(date -d "today" +"%Y/%m/%d %H-%M-%s") - Started EVT sim" > "${base_dir}/started_EVT.log" && \
(gen_minbias.py --output-file minbias.EVT.root -nt $n_workers --nov $nov --seed $seed --events-per-job 10 --pileup-avg 200 --pileup-sigma 0 -o "${base_dir}/EVT/minbias.EVT.root" |& tee "${base_dir}/minbias.EVT.log")  && \
echo "$(date -d "today" +"%Y/%m/%d %H-%M-%s") - Finished EVT sim" > "${base_dir}/finished_EVT.log"
# generate hits around the truth particle seed
mkdir -p $hit_dir && cd $hit_dir && \
echo "$(date -d "today" +"%Y/%m/%d %H-%M-%s") - Started HIT sim" |& tee "${base_dir}/started_HIT.log" && \
(simu_trf.py -i $evt_dir -o "minbias.HIT.root" -nt $n_workers --save-all-hits --timeout $timeout |& tee "${base_dir}/minbias.HIT.log") && \
echo "$(date -d "today" +"%Y/%m/%d %H-%M-%s") - Finished HIT sim" |& tee "${base_dir}/finished_HIT.log"

cd $call_dir
