import yaml
import os

with open('dataset/training_dset/data/obj.data', 'r') as f:
  classes = int(f.readline().split()[-1])
with open('dataset/training_dset/data/obj.names', 'r') as f:
  names = [f.readline().strip() for i in range(classes)]

cwd = os.getcwd()
data = f"""
train: {cwd}/dataset/training_dset/data/train.txt
val: {cwd}/dataset/training_dset/data/test.txt

nc: {classes}
classes: {names}
"""

with open('dataset/data.yaml', 'w+') as f:
    f.write(data)

with open('yolov5/models/yolov5s.yaml') as f:
    model = yaml.safe_load(f)

model['nc'] = classes

with open('yolov5/models/yolov5s.yaml', 'w') as f:
    yaml.safe_dump(model, f)
