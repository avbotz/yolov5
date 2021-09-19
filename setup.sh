#!/bin/bash

path="$(pwd)/dataset"
echo "path: $path"
rm -rf venv dataset yolov5 

DRIVE_ID="1J79VQQolr-KMhWg5cYk0pjp3K9uIowkV"
python3 -m venv ./venv
source ./venv/bin/activate
pip3 install gdown wheel

mkdir dataset
cd dataset
gdown "https://drive.google.com/uc?id=$DRIVE_ID"
unzip -Bj *.zip -d training_images/


git clone https://github.com/CraigWang1/custom-dataset-tools.git
pip3 install -r custom-dataset-tools/requirements.txt
python ./custom-dataset-tools/dataset/YOLO_format.py \
  --image_dir $path/training_images \
  --annot_dir $path/training_images \
  --save_dir $path/training_dset \
  --ext png \
  --train_test_split 0.7

cd ..
git clone https://github.com/ultralytics/yolov5
pip3 install --pre torch torchvision torchaudio -f https://download.pytorch.org/whl/nightly/cu111/torch_nightly.html
# pip3 install --pre torch torchvision -f https://download.pytorch.org/whl/nightly/cu110/torch_nightly.html -U
pip3 install -r yolo_custom_requirements.txt

python3 -c 'import torch; print("Setup complete. Using torch %s %s" % (torch.__version__, torch.cuda.get_device_properties(0) if torch.cuda.is_available() else "CPU"))'

pwd
python3 write_yaml.py

cd yolov5
python3 train.py \
    --img 640 \
    --batch 16 \
    --epochs 200 \
    --data '../dataset/data.yaml' \
    --cfg ./models/yolov5s.yaml \
    --weights yolov5s.pt \
    --name botz_yolov5s_results \
    --cache
